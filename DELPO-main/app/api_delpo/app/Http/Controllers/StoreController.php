<?php

namespace App\Http\Controllers;

use App\Models\Stores;
use App\Models\Product;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;
use Illuminate\Validation\ValidationException;

class StoreController extends Controller
{
    /**
     * Display a listing of stores
     */
    public function index(Request $request): JsonResponse
    {
        $query = Stores::with(['user']);

        // Search by name or description
        if ($request->has('search')) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('name', 'like', "%{$search}%")
                ->orWhere('description', 'like', "%{$search}%");
            });
        }

        // Filter by status
        if ($request->has('status')) {
            $query->where('status', $request->status);
        }

        // Filter by category
        if ($request->has('category')) {
            $query->where('category', $request->category);
        }

        $stores = $query->paginate($request->get('per_page', 15));

        return response()->json([
            'success' => true,
            'stores' => $stores
        ]);
    }

    /**
     * Show the specified store
     */
    public function show(Stores $store): JsonResponse
    {
        $store->load(['user', 'products' => function ($query) {
            $query->where('status', 'active')->with(['images', 'category']);
        }]);

        return response()->json([
            'success' => true,
            'store' => $store
        ]);
    }

    /**
     * Create a new store
     */
    public function store(Request $request): JsonResponse
    {
        $request->validate([
            'name' => 'required|string|max:255|unique:stores',
            'description' => 'required|string|max:1000',
            'category' => 'required|string|max:100',
            'phone' => 'required|string|max:20',
            'email' => 'required|email|unique:stores',
            'address' => 'required|string|max:500',
            'city' => 'required|string|max:100',
            'state' => 'required|string|max:100',
            'postal_code' => 'required|string|max:20',
            'country' => 'required|string|max:100',
            'logo' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
            'banner' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:5120'
        ]);

        $user = Auth::user();

        // Check if user already has a store
        if ($user->store) {
            return response()->json([
                'success' => false,
                'message' => 'You already have a store'
            ], 400);
        }

        $storeData = $request->except(['logo', 'banner']);
        $storeData['user_id'] = $user->id;
        $storeData['status'] = 'pending'; // Store needs approval

        // Handle logo upload
        if ($request->hasFile('logo')) {
            $logoPath = $request->file('logo')->store('stores/logos', 'public');
            $storeData['logo'] = $logoPath;
        }

        // Handle banner upload
        if ($request->hasFile('banner')) {
            $bannerPath = $request->file('banner')->store('stores/banners', 'public');
            $storeData['banner'] = $bannerPath;
        }

        $store = Stores::create($storeData);

        return response()->json([
            'success' => true,
            'message' => 'Store created successfully and pending approval',
            'store' => $store
        ], 201);
    }

    /**
     * Update the specified store
     */
    public function update(Request $request, Stores $store): JsonResponse
    {
        $user = Auth::user();

        // Check if user owns this store
        if ($store->user_id !== $user->id) {
            return response()->json([
                'success' => false,
                'message' => 'Unauthorized'
            ], 403);
        }

        $request->validate([
            'name' => 'sometimes|string|max:255|unique:stores,name,' . $store->id,
            'description' => 'sometimes|string|max:1000',
            'category' => 'sometimes|string|max:100',
            'phone' => 'sometimes|string|max:20',
            'email' => 'sometimes|email|unique:stores,email,' . $store->id,
            'address' => 'sometimes|string|max:500',
            'city' => 'sometimes|string|max:100',
            'state' => 'sometimes|string|max:100',
            'postal_code' => 'sometimes|string|max:20',
            'country' => 'sometimes|string|max:100',
            'logo' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
            'banner' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:5120'
        ]);

        $updateData = $request->except(['logo', 'banner']);

        // Handle logo upload
        if ($request->hasFile('logo')) {
            // Delete old logo
            if ($store->logo) {
                Storage::disk('public')->delete($store->logo);
            }
            
            $logoPath = $request->file('logo')->store('stores/logos', 'public');
            $updateData['logo'] = $logoPath;
        }

        // Handle banner upload
        if ($request->hasFile('banner')) {
            // Delete old banner
            if ($store->banner) {
                Storage::disk('public')->delete($store->banner);
            }
            
            $bannerPath = $request->file('banner')->store('stores/banners', 'public');
            $updateData['banner'] = $bannerPath;
        }

        $store->update($updateData);

        return response()->json([
            'success' => true,
            'message' => 'Store updated successfully',
            'store' => $store
        ]);
    }

    /**
     * Get store products
     */
    public function products(Request $request, Stores $store): JsonResponse
    {
        $query = $store->products()->with(['images', 'category']);

        // Filter by status
        if ($request->has('status')) {
            $query->where('status', $request->status);
        } else {
            $query->where('status', 'active'); // Default to active products
        }

        // Search products
        if ($request->has('search')) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('name', 'like', "%{$search}%")
                  ->orWhere('description', 'like', "%{$search}%");
            });
        }

        // Filter by category
        if ($request->has('category_id')) {
            $query->where('category_id', $request->category_id);
        }

        $products = $query->paginate($request->get('per_page', 20));

        return response()->json([
            'success' => true,
            'store' => [
                'id' => $store->id,
                'name' => $store->name,
                'description' => $store->description
            ],
            'products' => $products
        ]);
    }

    /**
     * Get store statistics (for store owners)
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

        $store = $user->store;

        $stats = [
            'total_products' => $store->products()->count(),
            'active_products' => $store->products()->where('status', 'active')->count(),
            'out_of_stock' => $store->products()->where('stock_quantity', '<=', 0)->count(),
            'low_stock' => $store->products()->where('stock_quantity', '>', 0)
                ->where('stock_quantity', '<=', 10)->count(),
            'total_orders' => $store->orders()->count(),
            'pending_orders' => $store->orders()->where('status', 'pending')->count(),
            'total_revenue' => $store->orders()->where('status', 'delivered')->sum('total_amount'),
            'monthly_revenue' => $store->orders()
                ->where('status', 'delivered')
                ->whereMonth('order_date', now()->month)
                ->whereYear('order_date', now()->year)
                ->sum('total_amount')
        ];

        return response()->json([
            'success' => true,
            'store' => $store,
            'statistics' => $stats
        ]);
    }

    /**
     * Update store status (admin only)
     */
    public function updateStatus(Request $request, Stores $store): JsonResponse
    {
        $request->validate([
            'status' => 'required|string|in:pending,active,suspended,closed'
        ]);

        $user = Auth::user();

        // Check if user is admin (you might want to implement proper role-based access)
        if ($user->role !== 'admin') {
            return response()->json([
                'success' => false,
                'message' => 'Unauthorized'
            ], 403);
        }

        $store->update(['status' => $request->status]);

        return response()->json([
            'success' => true,
            'message' => 'Store status updated successfully',
            'store' => $store
        ]);
    }
}
