<?php

namespace App\Http\Controllers;

use App\Models\ServiceBooking;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class ServiceBookingsController extends Controller
{
    /**
     * Display a listing of service bookings
     */
    public function index(Request $request): JsonResponse
    {
        try {
            $query = ServiceBooking::with(['client', 'serviceProvider', 'service']);

            // Filter by user role
            $user = $request->user();
            if ($user->role_type === 'client') {
                $query->where('client_id', $user->id);
            } elseif ($user->role_type === 'service_provider') {
                $query->whereHas('serviceProvider', function ($q) use ($user) {
                    $q->where('user_id', $user->id);
                });
            }

            // Add filtering options
            if ($request->has('status')) {
                $query->where('status', $request->status);
            }

            if ($request->has('service_id')) {
                $query->where('service_id', $request->service_id);
            }

            if ($request->has('booking_date')) {
                $query->whereDate('booking_date', $request->booking_date);
            }

            if ($request->has('date_range')) {
                $dates = explode(',', $request->date_range);
                if (count($dates) === 2) {
                    $query->whereBetween('booking_date', $dates);
                }
            }

            // Sorting
            $sortBy = $request->input('sort_by', 'booking_date');
            $sortOrder = $request->input('sort_order', 'desc');
            $query->orderBy($sortBy, $sortOrder);

            // Pagination
            $perPage = $request->input('per_page', 15);
            $bookings = $query->paginate($perPage);

            return response()->json([
                'success' => true,
                'message' => 'Service bookings retrieved successfully',
                'data' => $bookings
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Store a newly created service booking
     */
    public function store(Request $request): JsonResponse
    {
        try {
            $request->validate([
                'service_provider_id' => 'required|exists:service_providers,id',
                'service_id' => 'required|exists:services,id',
                'booking_date' => 'required|date|after_or_equal:today',
                'start_time' => 'required|date',
                'end_time' => 'nullable|date|after:start_time',
                'special_requirements' => 'nullable|string',
                'location_type' => 'required|in:client_location,provider_location,custom',
                'service_address' => 'nullable|string',
                'latitude' => 'nullable|numeric|between:-90,90',
                'longitude' => 'nullable|numeric|between:-180,180',
            ]);

            // Add client_id from authenticated user
            $bookingData = $request->all();
            $bookingData['client_id'] = $request->user()->id;
            $bookingData['status'] = 'pending';
            $bookingData['booking_reference'] = 'BK' . date('YmdHis') . rand(100, 999);

            $booking = ServiceBooking::create($bookingData);

            return response()->json([
                'success' => true,
                'message' => 'Service booking created successfully',
                'data' => $booking->load(['client', 'serviceProvider', 'service'])
            ], 201);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Display the specified service booking
     */
    public function show(ServiceBooking $serviceBooking): JsonResponse
    {
        try {
            // Check if user has permission to view this booking
            $user = request()->user();
            if ($user->role_type === 'client' && $serviceBooking->client_id !== $user->id) {
                return response()->json([
                    'success' => false,
                    'message' => 'Unauthorized to view this booking'
                ], 403);
            }

            if ($user->role_type === 'service_provider') {
                $hasAccess = $serviceBooking->serviceProvider()
                    ->where('user_id', $user->id)
                    ->exists();
                
                if (!$hasAccess) {
                    return response()->json([
                        'success' => false,
                        'message' => 'Unauthorized to view this booking'
                    ], 403);
                }
            }

            $serviceBooking->load(['client', 'serviceProvider.user', 'service', 'payment']);

            return response()->json([
                'success' => true,
                'data' => $serviceBooking
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Update the specified service booking
     */
    public function update(Request $request, ServiceBooking $serviceBooking): JsonResponse
    {
        try {
            $user = $request->user();

            // Only allow certain updates based on user role and booking status
            if ($user->role_type === 'client' && $serviceBooking->client_id === $user->id) {
                // Clients can update if booking is still pending
                if ($serviceBooking->status !== 'pending') {
                    return response()->json([
                        'success' => false,
                        'message' => 'Cannot modify booking after confirmation'
                    ], 400);
                }

                $request->validate([
                    'booking_date' => 'sometimes|date|after_or_equal:today',
                    'start_time' => 'sometimes|date',
                    'end_time' => 'nullable|date|after:start_time',
                    'special_requirements' => 'nullable|string',
                    'service_address' => 'nullable|string',
                ]);

            } elseif ($user->role_type === 'service_provider') {
                // Service providers can confirm, cancel, or complete bookings
                $request->validate([
                    'status' => 'sometimes|in:confirmed,cancelled,completed,in_progress',
                    'notes' => 'nullable|string',
                    'actual_duration' => 'nullable|integer|min:1',
                ]);

                if ($request->status === 'completed') {
                    $serviceBooking->completed_at = now();
                }

                if ($request->status === 'cancelled') {
                    $serviceBooking->cancelled_at = now();
                }

            } else {
                return response()->json([
                    'success' => false,
                    'message' => 'Unauthorized to update this booking'
                ], 403);
            }

            $serviceBooking->update($request->all());

            return response()->json([
                'success' => true,
                'message' => 'Service booking updated successfully',
                'data' => $serviceBooking->fresh()->load(['client', 'serviceProvider', 'service'])
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Cancel a service booking
     */
    public function cancel(Request $request, ServiceBooking $serviceBooking): JsonResponse
    {
        try {
            $user = $request->user();

            // Check permissions
            if ($user->role_type === 'client' && $serviceBooking->client_id !== $user->id) {
                return response()->json([
                    'success' => false,
                    'message' => 'Unauthorized to cancel this booking'
                ], 403);
            }

            if ($serviceBooking->status === 'completed') {
                return response()->json([
                    'success' => false,
                    'message' => 'Cannot cancel completed booking'
                ], 400);
            }

            $request->validate([
                'cancellation_reason' => 'required|string|max:500'
            ]);

            $serviceBooking->update([
                'status' => 'cancelled',
                'cancellation_reason' => $request->cancellation_reason,
                'cancelled_at' => now()
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Service booking cancelled successfully',
                'data' => $serviceBooking->fresh()
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get upcoming bookings
     */
    public function upcoming(Request $request): JsonResponse
    {
        try {
            $user = $request->user();
            $query = ServiceBooking::with(['client', 'serviceProvider', 'service'])
                ->where('booking_date', '>=', today())
                ->whereIn('status', ['pending', 'confirmed']);

            if ($user->role_type === 'client') {
                $query->where('client_id', $user->id);
            } elseif ($user->role_type === 'service_provider') {
                $query->whereHas('serviceProvider', function ($q) use ($user) {
                    $q->where('user_id', $user->id);
                });
            }

            $bookings = $query->orderBy('booking_date')
                ->orderBy('start_time')
                ->limit($request->input('limit', 10))
                ->get();

            return response()->json([
                'success' => true,
                'data' => $bookings
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }
}
