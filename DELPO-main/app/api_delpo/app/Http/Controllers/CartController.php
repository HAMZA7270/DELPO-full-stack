<?php

namespace App\Http\Controllers;

use App\Models\Cart;
use App\Models\CartItem;
use App\Models\Product;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Auth;
use Illuminate\Validation\ValidationException;

class CartController extends Controller
{
    /**
     * Get user's cart
     */
    public function index(): JsonResponse
    {
        try {
            $userId = Auth::id();
            
            $cart = Cart::with(['items.product.images', 'items.product.store'])
                ->where('user_id', $userId)
                ->first();
            
            if (!$cart) {
                $cart = Cart::create(['user_id' => $userId]);
            }
            
            return response()->json([
                'success' => true,
                'data' => [
                    'cart' => $cart,
                    'total_items' => $cart->items->sum('quantity'),
                    'total_amount' => $cart->getTotalAmount()
                ]
            ]);
            
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Add item to cart
     */
    public function addItem(Request $request): JsonResponse
    {
        try {
            $request->validate([
                'product_id' => 'required|exists:products,id',
                'quantity' => 'required|integer|min:1'
            ]);
            
            $userId = Auth::id();
            $product = Product::findOrFail($request->product_id);
            
            // Check if product is active and in stock
            if (!$product->is_active || !$product->isInStock()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Product is not available'
                ], 400);
            }
            
            // Check if requested quantity is available
            if ($product->stock_quantity < $request->quantity) {
                return response()->json([
                    'success' => false,
                    'message' => 'Insufficient stock. Available: ' . $product->stock_quantity
                ], 400);
            }
            
            // Get or create cart
            $cart = Cart::firstOrCreate(['user_id' => $userId]);
            
            // Check if item already exists in cart
            $cartItem = CartItem::where('cart_id', $cart->id)
                ->where('product_id', $request->product_id)
                ->first();
            
            if ($cartItem) {
                // Update quantity
                $newQuantity = $cartItem->quantity + $request->quantity;
                
                if ($product->stock_quantity < $newQuantity) {
                    return response()->json([
                        'success' => false,
                        'message' => 'Insufficient stock. Available: ' . $product->stock_quantity . ', In cart: ' . $cartItem->quantity
                    ], 400);
                }
                
                $cartItem->update(['quantity' => $newQuantity]);
            } else {
                // Create new cart item
                $cartItem = CartItem::create([
                    'cart_id' => $cart->id,
                    'product_id' => $request->product_id,
                    'quantity' => $request->quantity,
                    'price' => $product->price
                ]);
            }
            
            return response()->json([
                'success' => true,
                'message' => 'Item added to cart successfully',
                'data' => $cartItem->load('product.images')
            ]);
            
        } catch (ValidationException $e) {
            return response()->json([
                'success' => false,
                'message' => 'Validation failed',
                'errors' => $e->errors()
            ], 422);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Update cart item quantity
     */
    public function updateItem(Request $request, CartItem $cartItem): JsonResponse
    {
        try {
            $request->validate([
                'quantity' => 'required|integer|min:1'
            ]);
            
            $userId = Auth::id();
            
            // Check if user owns this cart item
            if ($cartItem->cart->user_id !== $userId) {
                return response()->json([
                    'success' => false,
                    'message' => 'Unauthorized'
                ], 403);
            }
            
            $product = $cartItem->product;
            
            // Check stock availability
            if ($product->stock_quantity < $request->quantity) {
                return response()->json([
                    'success' => false,
                    'message' => 'Insufficient stock. Available: ' . $product->stock_quantity
                ], 400);
            }
            
            $cartItem->update(['quantity' => $request->quantity]);
            
            return response()->json([
                'success' => true,
                'message' => 'Cart item updated successfully',
                'data' => $cartItem->load('product.images')
            ]);
            
        } catch (ValidationException $e) {
            return response()->json([
                'success' => false,
                'message' => 'Validation failed',
                'errors' => $e->errors()
            ], 422);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Remove item from cart
     */
    public function removeItem(CartItem $cartItem): JsonResponse
    {
        try {
            $userId = Auth::id();
            
            // Check if user owns this cart item
            if ($cartItem->cart->user_id !== $userId) {
                return response()->json([
                    'success' => false,
                    'message' => 'Unauthorized'
                ], 403);
            }
            
            $cartItem->delete();
            
            return response()->json([
                'success' => true,
                'message' => 'Item removed from cart successfully'
            ]);
            
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Clear entire cart
     */
    public function clear(): JsonResponse
    {
        try {
            $userId = Auth::id();
            
            $cart = Cart::where('user_id', $userId)->first();
            
            if ($cart) {
                $cart->items()->delete();
            }
            
            return response()->json([
                'success' => true,
                'message' => 'Cart cleared successfully'
            ]);
            
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }
}
