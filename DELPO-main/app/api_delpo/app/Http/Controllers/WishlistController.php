<?php

namespace App\Http\Controllers;

use App\Models\Wishlist;
use App\Models\Product;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Auth;

class WishlistController extends Controller
{
    /**
     * Display the user's wishlist
     */
    public function index(): JsonResponse
    {
        $user = Auth::user();
        
        $wishlist = Wishlist::with(['product.images', 'product.category', 'product.store'])
            ->where('user_id', $user->id)
            ->get();

        return response()->json([
            'success' => true,
            'wishlist' => $wishlist
        ]);
    }

    /**
     * Add product to wishlist
     */
    public function store(Request $request): JsonResponse
    {
        $request->validate([
            'product_id' => 'required|exists:products,id'
        ]);

        $user = Auth::user();
        $productId = $request->product_id;

        // Check if product is already in wishlist
        $existingWishlist = Wishlist::where('user_id', $user->id)
            ->where('product_id', $productId)
            ->first();

        if ($existingWishlist) {
            return response()->json([
                'success' => false,
                'message' => 'Product is already in your wishlist'
            ], 400);
        }

        $wishlist = Wishlist::create([
            'user_id' => $user->id,
            'product_id' => $productId
        ]);

        $wishlist->load(['product.images', 'product.category', 'product.store']);

        return response()->json([
            'success' => true,
            'message' => 'Product added to wishlist',
            'wishlist_item' => $wishlist
        ], 201);
    }

    /**
     * Remove product from wishlist
     */
    public function destroy(Wishlist $wishlist): JsonResponse
    {
        $user = Auth::user();
        
        // Check if user owns this wishlist item
        if ($wishlist->user_id !== $user->id) {
            return response()->json([
                'success' => false,
                'message' => 'Wishlist item not found'
            ], 404);
        }

        $wishlist->delete();

        return response()->json([
            'success' => true,
            'message' => 'Product removed from wishlist'
        ]);
    }

    /**
     * Remove product from wishlist by product ID
     */
    public function removeProduct(Request $request): JsonResponse
    {
        $request->validate([
            'product_id' => 'required|exists:products,id'
        ]);

        $user = Auth::user();
        
        $wishlist = Wishlist::where('user_id', $user->id)
            ->where('product_id', $request->product_id)
            ->first();

        if (!$wishlist) {
            return response()->json([
                'success' => false,
                'message' => 'Product not found in wishlist'
            ], 404);
        }

        $wishlist->delete();

        return response()->json([
            'success' => true,
            'message' => 'Product removed from wishlist'
        ]);
    }

    /**
     * Check if product is in user's wishlist
     */
    public function checkProduct(Request $request): JsonResponse
    {
        $request->validate([
            'product_id' => 'required|exists:products,id'
        ]);

        $user = Auth::user();
        
        $inWishlist = Wishlist::where('user_id', $user->id)
            ->where('product_id', $request->product_id)
            ->exists();

        return response()->json([
            'success' => true,
            'in_wishlist' => $inWishlist
        ]);
    }

    /**
     * Clear entire wishlist
     */
    public function clear(): JsonResponse
    {
        $user = Auth::user();
        
        $deletedCount = Wishlist::where('user_id', $user->id)->delete();

        return response()->json([
            'success' => true,
            'message' => "Removed {$deletedCount} items from wishlist"
        ]);
    }
}
