<?php

namespace App\Http\Controllers;

use App\Models\Service;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class ServicesController extends Controller
{
    /**
     * Display a listing of services
     */
    public function index(Request $request): JsonResponse
    {
        try {
            $query = Service::with(['serviceProvider', 'category']);

            // Add filtering options
            if ($request->has('service_provider_id')) {
                $query->where('service_provider_id', $request->service_provider_id);
            }

            if ($request->has('category_id')) {
                $query->where('category_id', $request->category_id);
            }

            if ($request->has('price_type')) {
                $query->where('price_type', $request->price_type);
            }

            if ($request->has('is_active')) {
                $query->where('is_active', $request->boolean('is_active'));
            }

            if ($request->has('is_featured')) {
                $query->where('is_featured', $request->boolean('is_featured'));
            }

            // Price range filtering
            if ($request->has('min_price') && $request->has('max_price')) {
                $query->whereBetween('base_price', [$request->min_price, $request->max_price]);
            }

            // Search functionality
            if ($request->has('search')) {
                $search = $request->search;
                $query->where(function ($q) use ($search) {
                    $q->where('name', 'like', "%{$search}%")
                      ->orWhere('description', 'like', "%{$search}%")
                      ->orWhereHas('serviceProvider', function ($provider) use ($search) {
                          $provider->where('business_name', 'like', "%{$search}%");
                      });
                });
            }

            // Sorting
            $sortBy = $request->input('sort_by', 'created_at');
            $sortOrder = $request->input('sort_order', 'desc');
            $query->orderBy($sortBy, $sortOrder);

            // Pagination
            $perPage = $request->input('per_page', 15);
            $services = $query->paginate($perPage);

            return response()->json([
                'success' => true,
                'message' => 'Services retrieved successfully',
                'data' => $services
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Store a newly created service
     */
    public function store(Request $request): JsonResponse
    {
        try {
            $request->validate([
                'service_provider_id' => 'required|exists:service_providers,id',
                'name' => 'required|string|max:255',
                'description' => 'required|string',
                'category_id' => 'nullable|exists:categories,id',
                'price_type' => 'required|in:hourly,fixed,custom',
                'base_price' => 'nullable|numeric|min:0',
                'hourly_rate' => 'nullable|numeric|min:0',
                'duration_hours' => 'nullable|numeric|min:0',
                'requirements' => 'nullable|array',
                'service_images' => 'nullable|array',
                'max_distance' => 'nullable|numeric|min:0',
                'preparation_time' => 'nullable|integer|min:0',
            ]);

            $service = Service::create($request->all());

            return response()->json([
                'success' => true,
                'message' => 'Service created successfully',
                'data' => $service->load(['serviceProvider', 'category'])
            ], 201);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Display the specified service
     */
    public function show(Service $service): JsonResponse
    {
        try {
            $service->load(['serviceProvider.user', 'category', 'reviews']);

            return response()->json([
                'success' => true,
                'data' => $service
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Update the specified service
     */
    public function update(Request $request, Service $service): JsonResponse
    {
        try {
            $request->validate([
                'name' => 'sometimes|string|max:255',
                'description' => 'sometimes|string',
                'category_id' => 'nullable|exists:categories,id',
                'price_type' => 'sometimes|in:hourly,fixed,custom',
                'base_price' => 'nullable|numeric|min:0',
                'hourly_rate' => 'nullable|numeric|min:0',
                'duration_hours' => 'nullable|numeric|min:0',
                'requirements' => 'nullable|array',
                'service_images' => 'nullable|array',
                'max_distance' => 'nullable|numeric|min:0',
                'preparation_time' => 'nullable|integer|min:0',
                'is_active' => 'boolean',
                'is_featured' => 'boolean',
            ]);

            $service->update($request->all());

            return response()->json([
                'success' => true,
                'message' => 'Service updated successfully',
                'data' => $service->fresh()->load(['serviceProvider', 'category'])
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Remove the specified service
     */
    public function destroy(Service $service): JsonResponse
    {
        try {
            // Check for active bookings
            $activeBookings = $service->serviceBookings()
                ->whereIn('status', ['pending', 'confirmed', 'in_progress'])
                ->count();

            if ($activeBookings > 0) {
                return response()->json([
                    'success' => false,
                    'message' => 'Cannot delete service with active bookings',
                    'active_bookings_count' => $activeBookings
                ], 400);
            }

            $service->delete();

            return response()->json([
                'success' => true,
                'message' => 'Service deleted successfully'
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get services by provider
     */
    public function getByProvider(Request $request, $providerId): JsonResponse
    {
        try {
            $services = Service::where('service_provider_id', $providerId)
                ->with(['category'])
                ->where('is_active', true)
                ->get();

            return response()->json([
                'success' => true,
                'data' => $services
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get featured services
     */
    public function featured(Request $request): JsonResponse
    {
        try {
            $services = Service::with(['serviceProvider.user', 'category'])
                ->where('is_featured', true)
                ->where('is_active', true)
                ->limit($request->input('limit', 10))
                ->get();

            return response()->json([
                'success' => true,
                'data' => $services
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }
}
