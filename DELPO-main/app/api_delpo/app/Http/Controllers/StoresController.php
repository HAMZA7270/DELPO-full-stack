<?php

namespace App\Http\Controllers;

use App\Models\Stores;
use Illuminate\Http\Request;
use App\Http\Requests\StorestoresRequest;
use App\Http\Requests\UpdatestoresRequest;

class StoresController extends Controller
{
	/**
	 * Display a listing of the resource.
	 */
	public function index(Request $request)
	{
		try {
			$query = Stores::with(['user', 'category']);
			
			// Add filtering options
			if ($request->has('category_id')) {
				$query->where('category_id', $request->category_id);
			}
			
			if ($request->has('operational_status')) {
				$query->where('operational_status', $request->operational_status);
			}
			
			if ($request->has('is_active')) {
				$query->where('is_active', $request->boolean('is_active'));
			}
			
			if ($request->has('area_name')) {
				$query->where('area_name', 'like', '%' . $request->area_name . '%');
			}
			
			// Add search functionality
			if ($request->has('search')) {
				$search = $request->search;
				$query->where(function ($q) use ($search) {
					$q->where('name', 'like', "%{$search}%")
					->orWhere('description', 'like', "%{$search}%")
					->orWhere('area_name', 'like', "%{$search}%");
				});
			}
			
			// Pagination
			$perPage = $request->input('per_page', 15);
			$stores = $query->paginate($perPage);
			
			return response()->json([
				'status' => 'ok',
				'message' => 'Stores retrieved successfully',
				'data' => $stores
			], 200);
			
		} catch (\Exception $e) {
			return response()->json([
				'status' => 'NOT OKAY',
				'message' => $e->getMessage()
			], 500);
		}
	}

	/**
	 * Store a newly created resource in storage.
	 */
	public function store(Request $request)
	{
		try {
			// Basic validation
			$fields = $request->validate([
				'name' => 'required|string|max:255',
				'user_id' => 'required|exists:users,id',
				'area_name' => 'required|string|max:255',
				'phone_number' => 'required|string|max:20',
				'email_address' => 'nullable|email|max:255',
				'category_id' => 'required|exists:categories,id',
				'logo_image_url' => 'nullable|url',
				'background_image_url' => 'nullable|url',
				'store_photos_urls' => 'nullable|string',
				'staff_photos_urls' => 'nullable|string',
				'latitude_coordinate' => 'nullable|numeric|between:-90,90',
				'longitude_coordinate' => 'nullable|numeric|between:-180,180',
				'street_address' => 'required|string',
				'description' => 'nullable|string',
				'operational_status' => 'required|in:open,closed,temporarily_closed',
				'is_active' => 'boolean'
			]);
			// Create the store
			$store = Stores::create($fields);

			return response()->json([
				'status' => 'ok',
				'message' => 'Store created successfully',
				'data' => $store
			], 201);

		} catch (\Exception $e) {
			return response()->json([
				'status' => 'NOT OKAY',
				'message' => $e->getMessage(), // Error message
				'received_data' => $request->all()
			], 500);
		}
	}
	/**
	 * Display the specified resource.
	 */
	public function show(Stores $store)
	{
		try {
			// Load relationships for more complete data
			$store->load(['user', 'category', 'products']);
			
			return response()->json([
				'status' => 'ok',
				'message' => 'Store retrieved successfully',
				'data' => $store
			], 200);
			
		} catch (\Exception $e) {
			return response()->json([
				'status' => 'NOT OKAY',
				'message' => $e->getMessage()
			], 500);
		}
	}

	/**
	 * Update the specified resource in storage.
	 */
	public function update(Request $request, Stores $store)
	{
		try {
			// Validation for update - all fields are optional
			$fields = $request->validate([
				'name' => 'sometimes|string|max:255',
				'user_id' => 'sometimes|exists:users,id',
				'area_name' => 'sometimes|string|max:255',
				'phone_number' => 'sometimes|string|max:20',
				'email_address' => 'nullable|email|max:255',
				'category_id' => 'sometimes|exists:categories,id',
				'logo_image_url' => 'nullable|url',
				'background_image_url' => 'nullable|url',
				'store_photos_urls' => 'nullable|string',
				'staff_photos_urls' => 'nullable|string',
				'latitude_coordinate' => 'nullable|numeric|between:-90,90',
				'longitude_coordinate' => 'nullable|numeric|between:-180,180',
				'street_address' => 'sometimes|string',
				'description' => 'nullable|string',
				'operational_status' => 'sometimes|in:open,closed,temporarily_closed',
				'is_active' => 'boolean'
			]);

			// Update the store
			$store->update($fields);

			return response()->json([
				'status' => 'ok',
				'message' => 'Store updated successfully',
				'data' => $store->fresh() // Get the updated model
			], 200);

		} catch (\Exception $e) {
			return response()->json([
				'status' => 'NOT OKAY',
				'message' => $e->getMessage(),
				'received_data' => $request->all()
			], 500);
		}
	}

	/**
	 * Remove the specified resource from storage.
	 */
	public function destroy(Stores $store)
	{
		try {
			// Check if store has any active orders or products before deletion
			$activeOrdersCount = $store->orders()->whereIn('status', ['pending', 'processing', 'confirmed'])->count();
			
			if ($activeOrdersCount > 0) {
				return response()->json([
					'status' => 'NOT OKAY',
					'message' => 'Cannot delete store with active orders. Please complete or cancel active orders first.',
					'active_orders_count' => $activeOrdersCount
				], 400);
			}

			// Store name for response message
			$storeName = $store->name;
			
			// Delete the store
			$store->delete();

			return response()->json([
				'status' => 'ok',
				'message' => "Store '{$storeName}' deleted successfully"
			], 200);

		} catch (\Exception $e) {
			return response()->json([
				'status' => 'NOT OKAY',
				'message' => $e->getMessage()
			], 500);
		}
	}
}
