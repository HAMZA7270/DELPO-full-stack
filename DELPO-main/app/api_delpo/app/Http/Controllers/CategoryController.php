<?php

namespace App\Http\Controllers;

use App\Models\Category;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Validation\ValidationException;

class CategoryController extends Controller
{
    /**
     * Display a listing of categories
     */
    public function index(): JsonResponse
    {
        try {
            $categories = Category::with(['products' => function($query) {
                $query->active()->take(5);
            }])->where('is_active', true)->get();
            
            return response()->json([
                'success' => true,
                'data' => $categories
            ]);
            
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Store a newly created category
     */
    public function store(Request $request): JsonResponse
    {
        try {
            $request->validate([
                'name' => 'required|string|max:255|unique:categories,name',
                'description' => 'nullable|string',
                'image_url' => 'nullable|url',
                'parent_id' => 'nullable|exists:categories,id',
                'sort_order' => 'nullable|integer|min:0'
            ]);
            
            $category = Category::create([
                'name' => $request->name,
                'description' => $request->description,
                'image_url' => $request->image_url,
                'parent_id' => $request->parent_id,
                'sort_order' => $request->sort_order ?? 0,
                'is_active' => true
            ]);
            
            return response()->json([
                'success' => true,
                'message' => 'Category created successfully',
                'data' => $category
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
     * Display the specified category
     */
    public function show(Category $category): JsonResponse
    {
        try {
            $category->load(['products' => function($query) {
                $query->active()->with(['images', 'store']);
            }, 'children']);
            
            return response()->json([
                'success' => true,
                'data' => $category
            ]);
            
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Update the specified category
     */
    public function update(Request $request, Category $category): JsonResponse
    {
        try {
            $request->validate([
                'name' => 'sometimes|string|max:255|unique:categories,name,' . $category->id,
                'description' => 'nullable|string',
                'image_url' => 'nullable|url',
                'parent_id' => 'nullable|exists:categories,id',
                'sort_order' => 'nullable|integer|min:0',
                'is_active' => 'sometimes|boolean'
            ]);
            
            $category->update($request->only([
                'name', 'description', 'image_url', 'parent_id', 'sort_order', 'is_active'
            ]));
            
            return response()->json([
                'success' => true,
                'message' => 'Category updated successfully',
                'data' => $category
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
     * Remove the specified category
     */
    public function destroy(Category $category): JsonResponse
    {
        try {
            // Check if category has products
            if ($category->products()->count() > 0) {
                return response()->json([
                    'success' => false,
                    'message' => 'Cannot delete category with existing products'
                ], 400);
            }
            
            $category->delete();
            
            return response()->json([
                'success' => true,
                'message' => 'Category deleted successfully'
            ]);
            
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get category tree (hierarchical structure)
     */
    public function tree(): JsonResponse
    {
        try {
            $categories = Category::with('children.children')
                ->whereNull('parent_id')
                ->where('is_active', true)
                ->orderBy('sort_order')
                ->get();
            
            return response()->json([
                'success' => true,
                'data' => $categories
            ]);
            
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }
}
