<?php

namespace App\Http\Controllers;

use App\Models\Address;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class AddressesController extends Controller
{
    /**
     * Display a listing of user's addresses
     */
    public function index(Request $request): JsonResponse
    {
        try {
            $user = $request->user();
            $addresses = Address::where('user_id', $user->id)
                ->where('is_active', true)
                ->orderBy('is_default', 'desc')
                ->orderBy('created_at', 'desc')
                ->get();

            return response()->json([
                'success' => true,
                'message' => 'Addresses retrieved successfully',
                'data' => $addresses
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Store a newly created address
     */
    public function store(Request $request): JsonResponse
    {
        try {
            $request->validate([
                'type' => 'required|in:home,work,delivery,billing,other',
                'label' => 'nullable|string|max:255',
                'address_line_1' => 'required|string|max:255',
                'address_line_2' => 'nullable|string|max:255',
                'city' => 'required|string|max:100',
                'state' => 'nullable|string|max:100',
                'postal_code' => 'nullable|string|max:20',
                'country' => 'required|string|max:100',
                'latitude' => 'nullable|numeric|between:-90,90',
                'longitude' => 'nullable|numeric|between:-180,180',
                'is_default' => 'boolean',
            ]);

            $addressData = $request->all();
            $addressData['user_id'] = $request->user()->id;

            // If this is set as default, unset other default addresses
            if ($request->boolean('is_default')) {
                Address::where('user_id', $request->user()->id)
                    ->update(['is_default' => false]);
            }

            $address = Address::create($addressData);

            return response()->json([
                'success' => true,
                'message' => 'Address created successfully',
                'data' => $address
            ], 201);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Display the specified address
     */
    public function show(Address $address): JsonResponse
    {
        try {
            // Check if address belongs to authenticated user
            if ($address->user_id !== request()->user()->id) {
                return response()->json([
                    'success' => false,
                    'message' => 'Unauthorized to view this address'
                ], 403);
            }

            return response()->json([
                'success' => true,
                'data' => $address
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Update the specified address
     */
    public function update(Request $request, Address $address): JsonResponse
    {
        try {
            // Check if address belongs to authenticated user
            if ($address->user_id !== $request->user()->id) {
                return response()->json([
                    'success' => false,
                    'message' => 'Unauthorized to update this address'
                ], 403);
            }

            $request->validate([
                'type' => 'sometimes|in:home,work,delivery,billing,other',
                'label' => 'nullable|string|max:255',
                'address_line_1' => 'sometimes|string|max:255',
                'address_line_2' => 'nullable|string|max:255',
                'city' => 'sometimes|string|max:100',
                'state' => 'nullable|string|max:100',
                'postal_code' => 'nullable|string|max:20',
                'country' => 'sometimes|string|max:100',
                'latitude' => 'nullable|numeric|between:-90,90',
                'longitude' => 'nullable|numeric|between:-180,180',
                'is_default' => 'boolean',
            ]);

            // If this is set as default, unset other default addresses
            if ($request->boolean('is_default')) {
                Address::where('user_id', $request->user()->id)
                    ->where('id', '!=', $address->id)
                    ->update(['is_default' => false]);
            }

            $address->update($request->all());

            return response()->json([
                'success' => true,
                'message' => 'Address updated successfully',
                'data' => $address->fresh()
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Remove the specified address
     */
    public function destroy(Address $address): JsonResponse
    {
        try {
            // Check if address belongs to authenticated user
            if ($address->user_id !== request()->user()->id) {
                return response()->json([
                    'success' => false,
                    'message' => 'Unauthorized to delete this address'
                ], 403);
            }

            // If this was the default address, set another as default
            if ($address->is_default) {
                $nextAddress = Address::where('user_id', $address->user_id)
                    ->where('id', '!=', $address->id)
                    ->where('is_active', true)
                    ->first();
                
                if ($nextAddress) {
                    $nextAddress->update(['is_default' => true]);
                }
            }

            $address->delete();

            return response()->json([
                'success' => true,
                'message' => 'Address deleted successfully'
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Set address as default
     */
    public function setDefault(Request $request, Address $address): JsonResponse
    {
        try {
            // Check if address belongs to authenticated user
            if ($address->user_id !== $request->user()->id) {
                return response()->json([
                    'success' => false,
                    'message' => 'Unauthorized to modify this address'
                ], 403);
            }

            // Unset other default addresses
            Address::where('user_id', $request->user()->id)
                ->update(['is_default' => false]);

            // Set this address as default
            $address->update(['is_default' => true]);

            return response()->json([
                'success' => true,
                'message' => 'Address set as default successfully',
                'data' => $address->fresh()
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get addresses by type
     */
    public function getByType(Request $request, $type): JsonResponse
    {
        try {
            $addresses = Address::where('user_id', $request->user()->id)
                ->where('type', $type)
                ->where('is_active', true)
                ->orderBy('is_default', 'desc')
                ->get();

            return response()->json([
                'success' => true,
                'data' => $addresses
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }
}
