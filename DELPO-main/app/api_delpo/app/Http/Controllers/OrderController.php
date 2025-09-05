<?php

namespace App\Http\Controllers;

use App\Models\Order;
use App\Models\OrderItem;
use App\Models\Cart;
use App\Models\Product;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;

class OrderController extends Controller
{
    /**
     * Display a listing of orders for the authenticated user
     */
    public function index(Request $request): JsonResponse
    {
        $userId = Auth::id();
        
        $query = Order::with(['items.product', 'payment', 'delivery'])
            ->where('user_id', $userId);

        // Filter by status if provided
        if ($request->has('status')) {
            $query->where('status', $request->status);
        }

        // Filter by date range
        if ($request->has('from_date')) {
            $query->where('order_date', '>=', $request->from_date);
        }
        
        if ($request->has('to_date')) {
            $query->where('order_date', '<=', $request->to_date);
        }

        $orders = $query->orderBy('order_date', 'desc')
            ->paginate($request->get('per_page', 15));

        return response()->json([
            'success' => true,
            'orders' => $orders
        ]);
    }

    /**
     * Show the specified order
     */
    public function show(Order $order): JsonResponse
    {
        $userId = Auth::id();
        
        // Check if user owns this order
        if ($order->getAttribute('user_id') !== $userId) {
            // For store owners, check if they own the store
            $user = Auth::user();
            if (!$user->store || $order->getAttribute('store_id') !== $user->store->getKey()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Order not found'
                ], 404);
            }
        }

        $order->load(['items.product', 'payment', 'delivery', 'store']);

        return response()->json([
            'success' => true,
            'order' => $order
        ]);
    }

    /**
     * Create order from cart
     */
    public function createFromCart(Request $request): JsonResponse
    {
        $request->validate([
            'shipping_address' => 'required|array',
            'shipping_address.street' => 'required|string',
            'shipping_address.city' => 'required|string',
            'shipping_address.state' => 'required|string',
            'shipping_address.postal_code' => 'required|string',
            'shipping_address.country' => 'required|string',
            'billing_address' => 'nullable|array',
            'payment_method' => 'required|string|in:credit_card,debit_card,paypal,bank_transfer,cash_on_delivery',
            'notes' => 'nullable|string|max:500'
        ]);

        $userId = Auth::id();
        $cart = Cart::with(['items.product'])->where('user_id', $userId)->first();

        if (!$cart || $cart->items->isEmpty()) {
            return response()->json([
                'success' => false,
                'message' => 'Cart is empty'
            ], 400);
        }

        // Group cart items by store
        $itemsByStore = $cart->items->groupBy(function ($item) {
            return $item->product->store_id;
        });

        DB::beginTransaction();
        
        try {
            $orders = [];
            
            foreach ($itemsByStore as $storeId => $items) {
                // Calculate total for this store
                $totalAmount = $items->sum(function ($item) {
                    return $item->quantity * $item->price;
                });

                // Create order
                $order = Order::create([
                    'user_id' => $userId,
                    'store_id' => $storeId,
                    'order_number' => Order::generateOrderNumber(),
                    'status' => 'pending',
                    'total_amount' => $totalAmount,
                    'shipping_address' => json_encode($request->shipping_address),
                    'billing_address' => json_encode($request->billing_address ?? $request->shipping_address),
                    'notes' => $request->notes,
                    'order_date' => now()
                ]);

                // Create order items
                foreach ($items as $cartItem) {
                    // Check stock availability
                    if ($cartItem->product->stock_quantity < $cartItem->quantity) {
                        throw ValidationException::withMessages([
                            'stock' => "Insufficient stock for product: {$cartItem->product->name}"
                        ]);
                    }

                    OrderItem::create([
                        'order_id' => $order->getKey(),
                        'product_id' => $cartItem->product_id,
                        'quantity' => $cartItem->quantity,
                        'price' => $cartItem->price
                    ]);

                    // Update product stock
                    $cartItem->product->decrement('stock_quantity', $cartItem->quantity);
                }

                $orders[] = $order->load(['items.product', 'store']);
            }

            // Clear the cart
            $cart->items()->delete();
            $cart->delete();

            DB::commit();

            return response()->json([
                'success' => true,
                'message' => 'Orders created successfully',
                'orders' => $orders
            ], 201);

        } catch (\Exception $e) {
            DB::rollBack();
            
            if ($e instanceof ValidationException) {
                throw $e;
            }
            
            return response()->json([
                'success' => false,
                'message' => 'Failed to create order: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Update order status (for store owners)
     */
    public function updateStatus(Request $request, Order $order): JsonResponse
    {
        $request->validate([
            'status' => 'required|string|in:pending,confirmed,processing,shipped,delivered,cancelled'
        ]);

        $user = Auth::user();
        
        // Check if user is the store owner
        if (!$user->store || $order->getAttribute('store_id') !== $user->store->getKey()) {
            return response()->json([
                'success' => false,
                'message' => 'Unauthorized'
            ], 403);
        }

        $oldStatus = $order->status;
        $order->update(['status' => $request->status]);

        // If status changed to shipped, create delivery record
        if ($request->status === 'shipped' && $oldStatus !== 'shipped') {
            $order->delivery()->create([
                'delivery_address' => $order->shipping_address,
                'delivery_method' => 'standard',
                'delivery_status' => 'in_transit',
                'estimated_delivery_date' => now()->addDays(3)
            ]);
        }

        return response()->json([
            'success' => true,
            'message' => 'Order status updated successfully',
            'order' => $order->load(['items.product', 'delivery'])
        ]);
    }

    /**
     * Cancel order
     */
    public function cancel(Order $order): JsonResponse
    {
        $userId = Auth::id();
        
        // Check if user owns this order
        if ($order->getAttribute('user_id') !== $userId) {
            return response()->json([
                'success' => false,
                'message' => 'Order not found'
            ], 404);
        }

        // Check if order can be cancelled (only pending or confirmed orders)
        if (!in_array($order->status, ['pending', 'confirmed'])) {
            return response()->json([
                'success' => false,
                'message' => 'Order cannot be cancelled at this stage'
            ], 400);
        }

        DB::beginTransaction();
        
        try {
            // Restore product stock
            foreach ($order->items as $item) {
                $item->product->increment('stock_quantity', $item->quantity);
            }

            $order->update(['status' => 'cancelled']);

            DB::commit();

            return response()->json([
                'success' => true,
                'message' => 'Order cancelled successfully',
                'order' => $order
            ]);

        } catch (\Exception $e) {
            DB::rollBack();
            
            return response()->json([
                'success' => false,
                'message' => 'Failed to cancel order'
            ], 500);
        }
    }

    /**
     * Get order statistics for store owners
     */
    public function statistics(): JsonResponse
    {
        $user = Auth::user();
        
        if (!$user->store) {
            return response()->json([
                'success' => false,
                'message' => 'Store not found'
            ], 404);
        }

        $storeId = $user->store->getKey();

        $stats = [
            'total_orders' => Order::where('store_id', $storeId)->count(),
            'pending_orders' => Order::where('store_id', $storeId)
                ->where('status', 'pending')->count(),
            'completed_orders' => Order::where('store_id', $storeId)
                ->where('status', 'delivered')->count(),
            'total_revenue' => Order::where('store_id', $storeId)
                ->where('status', 'delivered')
                ->sum('total_amount'),
            'monthly_revenue' => Order::where('store_id', $storeId)
                ->where('status', 'delivered')
                ->whereMonth('order_date', now()->month)
                ->whereYear('order_date', now()->year)
                ->sum('total_amount')
        ];

        return response()->json([
            'success' => true,
            'statistics' => $stats
        ]);
    }
}
