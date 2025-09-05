<?php

namespace App\Http\Controllers;

use App\Models\Product;
use App\Models\Stores;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Auth;
use Illuminate\Validation\ValidationException;
use Illuminate\Support\Facades\Storage;

class ProductController extends Controller
{
    /**
     * Display a listing of products
     */
    public function index(Request $request): JsonResponse
    {
        try {
            $query = Product::with(['store', 'category', 'images']);
            
            // Filter by category
            if ($request->has('category_id')) {
                $query->where('category_id', $request->category_id);
            }
            
            // Filter by store
            if ($request->has('store_id')) {
                $query->where('store_id', $request->store_id);
            }
            
            // Search by name or description
            if ($request->has('search')) {
                $search = $request->search;
                $query->where(function($q) use ($search) {
                    $q->where('name', 'like', "%{$search}%")
                      ->orWhere('description', 'like', "%{$search}%");
                });
            }
            
            // Filter by price range
            if ($request->has('min_price')) {
                $query->where('price', '>=', $request->min_price);
            }
            if ($request->has('max_price')) {
                $query->where('price', '<=', $request->max_price);
            }
            
            // Only active products
            $query->where('status', 'active');
            
            $products = $query->paginate($request->get('per_page', 15));
            
            return response()->json([
                'success' => true,
                'data' => $products
            ]);
            
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Store a newly created product
     */
    public function store(Request $request): JsonResponse
    {
        try {
            $request->validate([
                'name' => 'required|string|max:255',
                'description' => 'required|string',
                'price' => 'required|numeric|min:0',
                'category_id' => 'required|exists:categories,id',
                'store_id' => 'required|exists:stores,id',
                'stock_quantity' => 'required|integer|min:0',
                'sku' => 'nullable|string|unique:products,sku',
                'weight' => 'nullable|numeric|min:0',
                'dimensions' => 'nullable|string',
                'images' => 'nullable|array',
                'images.*' => 'image|mimes:jpeg,png,jpg,gif|max:2048'
            ]);
            
            // Check if user owns the store
            /** @var User $user */
            $user = Auth::user();
            $store = Stores::findOrFail($request->store_id);
            
            if ($store->user_id !== $user->id) {
                return response()->json([
                    'success' => false,
                    'message' => 'Unauthorized to add products to this store'
                ], 403);
            }
            
            $product = Product::create([
                'name' => $request->name,
                'description' => $request->description,
                'price' => $request->price,
                'category_id' => $request->category_id,
                'store_id' => $request->store_id,
                'stock_quantity' => $request->stock_quantity,
                'sku' => $request->sku ?? $this->generateSKU(),
                'weight' => $request->weight,
                'dimensions' => $request->dimensions,
                'is_active' => true
            ]);
            
            // Handle image uploads
            if ($request->hasFile('images')) {
                $this->uploadProductImages($product, $request->file('images'));
            }
            
            return response()->json([
                'success' => true,
                'message' => 'Product created successfully',
                'data' => $product->load(['store', 'category', 'images'])
            ], 201);
            
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
     * Display the specified product
     */
    public function show(Product $product): JsonResponse
    {
        try {
            $product->load(['store', 'category', 'images', 'reviews.user']);
            
            return response()->json([
                'success' => true,
                'data' => $product
            ]);
            
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Update the specified product
     */
    public function update(Request $request, Product $product): JsonResponse
    {
        try {
            $request->validate([
                'name' => 'sometimes|string|max:255',
                'description' => 'sometimes|string',
                'price' => 'sometimes|numeric|min:0',
                'category_id' => 'sometimes|exists:categories,id',
                'stock_quantity' => 'sometimes|integer|min:0',
                'sku' => 'sometimes|string|unique:products,sku,' . $product->id,
                'weight' => 'nullable|numeric|min:0',
                'dimensions' => 'nullable|string',
                'is_active' => 'sometimes|boolean',
                'images' => 'nullable|array',
                'images.*' => 'image|mimes:jpeg,png,jpg,gif|max:2048'
            ]);
            
            // Check if user owns the store
            /** @var User $user */
            $user = Auth::user();
            if ($product->store->user_id !== $user->id) {
                return response()->json([
                    'success' => false,
                    'message' => 'Unauthorized to update this product'
                ], 403);
            }
            
            $product->update($request->only([
                'name', 'description', 'price', 'category_id', 
                'stock_quantity', 'sku', 'weight', 'dimensions', 'is_active'
            ]));
            
            // Handle new image uploads
            if ($request->hasFile('images')) {
                $this->uploadProductImages($product, $request->file('images'));
            }
            
            return response()->json([
                'success' => true,
                'message' => 'Product updated successfully',
                'data' => $product->load(['store', 'category', 'images'])
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
     * Remove the specified product
     */
    public function destroy(Product $product): JsonResponse
    {
        try {
            // Check if user owns the store
            /** @var User $user */
            $user = Auth::user();
            if ($product->store->user_id !== $user->id) {
                return response()->json([
                    'success' => false,
                    'message' => 'Unauthorized to delete this product'
                ], 403);
            }
            
            // Delete product images from storage
            foreach ($product->images as $image) {
                Storage::delete($image->path);
                $image->delete();
            }
            
            $product->delete();
            
            return response()->json([
                'success' => true,
                'message' => 'Product deleted successfully'
            ]);
            
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Generate unique SKU
     */
    private function generateSKU(): string
    {
        do {
            $sku = 'PRD-' . strtoupper(uniqid());
        } while (Product::where('sku', $sku)->exists());
        
        return $sku;
    }

    /**
     * Upload product images
     */
    private function uploadProductImages(Product $product, array $images): void
    {
        foreach ($images as $image) {
            $path = $image->store('products', 'public');
            
            $product->images()->create([
                'path' => $path,
                'url' => Storage::url($path),
                'type' => 'product_image'
            ]);
        }
    }
}
