<?php

namespace App\Http\Controllers;

use App\Models\ServiceProvider;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class ServiceProvidersController extends Controller
{
    /**
     * Display a listing of service providers
     */
    public function index(Request $request): JsonResponse
    {
        try {
            $query = ServiceProvider::with(['user', 'serviceCategory']);

            // Add filtering options
            if ($request->has('service_category_id')) {
                $query->where('service_category_id', $request->service_category_id);
            }

            if ($request->has('is_verified')) {
                $query->where('is_verified', $request->boolean('is_verified'));
            }

            if ($request->has('is_active')) {
                $query->where('is_active', $request->boolean('is_active'));
            }

            if ($request->has('is_available')) {
                $query->where('is_available', $request->boolean('is_available'));
            }

            if ($request->has('min_rating')) {
                $query->where('rating', '>=', $request->min_rating);
            }

            // Search functionality
            if ($request->has('search')) {
                $search = $request->search;
                $query->where(function ($q) use ($search) {
                    $q->where('business_name', 'like', "%{$search}%")
                      ->orWhere('description', 'like', "%{$search}%")
                      ->orWhereJsonContains('skills', $search);
                });
            }

            // Location-based search
            if ($request->has('latitude') && $request->has('longitude') && $request->has('radius')) {
                $lat = $request->latitude;
                $lng = $request->longitude;
                $radius = $request->radius;
                
                $query->selectRaw("*, 
                        ( 6371 * acos( cos( radians(?) ) *
                          cos( radians( latitude ) )
                          * cos( radians( longitude ) - radians(?) )
                          + sin( radians(?) ) *
                          sin( radians( latitude ) ) ) ) AS distance", 
                        [$lat, $lng, $lat])
                      ->whereRaw("( 6371 * acos( cos( radians(?) ) *
                        cos( radians( latitude ) )
                        * cos( radians( longitude ) - radians(?) )
                        + sin( radians(?) ) *
                        sin( radians( latitude ) ) ) ) < ?", 
                        [$lat, $lng, $lat, $radius])
                      ->orderBy('distance');
            }

            // Pagination
            $perPage = $request->input('per_page', 15);
            $providers = $query->paginate($perPage);

            return response()->json([
                'success' => true,
                'message' => 'Service providers retrieved successfully',
                'data' => $providers
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Store a newly created service provider
     */
    public function store(Request $request): JsonResponse
    {
        try {
            $request->validate([
                'user_id' => 'required|exists:users,id|unique:service_providers,user_id',
                'business_name' => 'required|string|max:255',
                'service_category_id' => 'nullable|exists:categories,id',
                'skills' => 'nullable|array',
                'experience_years' => 'nullable|integer|min:0',
                'hourly_rate' => 'nullable|numeric|min:0',
                'description' => 'nullable|string',
                'phone' => 'nullable|string|max:20',
                'email' => 'nullable|email',
                'address' => 'nullable|string',
                'latitude' => 'nullable|numeric|between:-90,90',
                'longitude' => 'nullable|numeric|between:-180,180',
                'service_radius' => 'nullable|numeric|min:0',
            ]);

            $provider = ServiceProvider::create($request->all());

            return response()->json([
                'success' => true,
                'message' => 'Service provider created successfully',
                'data' => $provider->load(['user', 'serviceCategory'])
            ], 201);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Display the specified service provider
     */
    public function show(ServiceProvider $serviceProvider): JsonResponse
    {
        try {
            $serviceProvider->load(['user', 'serviceCategory', 'services', 'reviews']);

            return response()->json([
                'success' => true,
                'data' => $serviceProvider
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Update the specified service provider
     */
    public function update(Request $request, ServiceProvider $serviceProvider): JsonResponse
    {
        try {
            $request->validate([
                'business_name' => 'sometimes|string|max:255',
                'service_category_id' => 'nullable|exists:categories,id',
                'skills' => 'nullable|array',
                'experience_years' => 'nullable|integer|min:0',
                'hourly_rate' => 'nullable|numeric|min:0',
                'description' => 'nullable|string',
                'phone' => 'nullable|string|max:20',
                'email' => 'nullable|email',
                'address' => 'nullable|string',
                'latitude' => 'nullable|numeric|between:-90,90',
                'longitude' => 'nullable|numeric|between:-180,180',
                'service_radius' => 'nullable|numeric|min:0',
                'is_available' => 'boolean',
            ]);

            $serviceProvider->update($request->all());

            return response()->json([
                'success' => true,
                'message' => 'Service provider updated successfully',
                'data' => $serviceProvider->fresh()->load(['user', 'serviceCategory'])
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Remove the specified service provider
     */
    public function destroy(ServiceProvider $serviceProvider): JsonResponse
    {
        try {
            // Check for active bookings
            $activeBookings = $serviceProvider->serviceBookings()
                ->whereIn('status', ['pending', 'confirmed', 'in_progress'])
                ->count();

            if ($activeBookings > 0) {
                return response()->json([
                    'success' => false,
                    'message' => 'Cannot delete service provider with active bookings',
                    'active_bookings_count' => $activeBookings
                ], 400);
            }

            $serviceProvider->delete();

            return response()->json([
                'success' => true,
                'message' => 'Service provider deleted successfully'
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get service provider by user ID
     */
    public function getByUser(Request $request, $userId): JsonResponse
    {
        try {
            $provider = ServiceProvider::where('user_id', $userId)
                ->with(['user', 'serviceCategory', 'services'])
                ->first();

            if (!$provider) {
                return response()->json([
                    'success' => false,
                    'message' => 'Service provider profile not found'
                ], 404);
            }

            return response()->json([
                'success' => true,
                'data' => $provider
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }
}
