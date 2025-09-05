<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\StoresController;
use App\Http\Controllers\UserProfilesController;
use App\Http\Controllers\ServiceProvidersController;
use App\Http\Controllers\ServicesController;
use App\Http\Controllers\ServiceBookingsController;
use App\Http\Controllers\AddressesController;
use App\Http\Controllers\ProductController;
use App\Http\Controllers\CategoryController;
use App\Http\Controllers\CartController;
use App\Http\Controllers\OrderController;
use App\Http\Controllers\WishlistController;
use App\Http\Controllers\StoreController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

// Authentication routes (public)
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

// Public marketplace routes
Route::get('/products', [ProductController::class, 'index']);
Route::get('/products/{product}', [ProductController::class, 'show']);
Route::get('/categories', [CategoryController::class, 'index']);
Route::get('/categories/{category}', [CategoryController::class, 'show']);
Route::get('/stores', [StoreController::class, 'index']);
Route::get('/stores/{store}', [StoreController::class, 'show']);
Route::get('/stores/{store}/products', [StoreController::class, 'products']);

// Debug route to test request data
Route::post('/debug', function (Request $request) {
    return response()->json([
        'all_data' => $request->all(),
        'content_type' => $request->header('Content-Type'),
        'method' => $request->method(),
        'has_name' => $request->has('name'),
        'name_value' => $request->input('name'),
    ]);
});

// Simple test route for Flutter
Route::post('/test-register', function (Request $request) {
    \Log::info('Test register called with data:', $request->all());
    \Log::info('Test register headers:', $request->headers->all());
    \Log::info('Test register method:', [$request->method()]);
    return response()->json([
        'success' => true,
        'message' => 'Test registration successful',
        'received_data' => $request->all()
    ]);
});

// Protected routes requiring authentication
Route::middleware('auth:sanctum')->group(function () {
    // User management
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::post('/refresh', [AuthController::class, 'refresh']);
    Route::get('/user', function (Request $request) {
        return $request->user()->load('profile');
    });
    
    // User profiles
    Route::apiResource('user-profiles', UserProfilesController::class);
    
    // Addresses
    Route::apiResource('addresses', AddressesController::class);
    
    // Service providers
    Route::apiResource('service-providers', ServiceProvidersController::class);
    
    // Services
    Route::apiResource('services', ServicesController::class);
    
    // Service bookings
    Route::apiResource('service-bookings', ServiceBookingsController::class);
    
    // Store management (for store owners)
    Route::post('/stores', [StoreController::class, 'store']);
    Route::put('/stores/{store}', [StoreController::class, 'update']);
    Route::get('/stores/statistics', [StoreController::class, 'statistics']);
    Route::patch('/stores/{store}/status', [StoreController::class, 'updateStatus']); // Admin only
    
    // Product management (for store owners)
    Route::post('/products', [ProductController::class, 'store']);
    Route::put('/products/{product}', [ProductController::class, 'update']);
    Route::delete('/products/{product}', [ProductController::class, 'destroy']);
    Route::post('/products/{product}/images', [ProductController::class, 'uploadImages']);
    Route::delete('/products/{product}/images/{image}', [ProductController::class, 'deleteImage']);
    
    // Category management (admin only)
    Route::post('/categories', [CategoryController::class, 'store']);
    Route::put('/categories/{category}', [CategoryController::class, 'update']);
    Route::delete('/categories/{category}', [CategoryController::class, 'destroy']);
    
    // Cart management
    Route::get('/cart', [CartController::class, 'index']);
    Route::post('/cart/add', [CartController::class, 'addItem']);
    Route::put('/cart/update/{cartItem}', [CartController::class, 'updateItem']);
    Route::delete('/cart/remove/{cartItem}', [CartController::class, 'removeItem']);
    Route::delete('/cart/clear', [CartController::class, 'clearCart']);
    
    // Order management
    Route::get('/orders', [OrderController::class, 'index']);
    Route::get('/orders/{order}', [OrderController::class, 'show']);
    Route::post('/orders/create-from-cart', [OrderController::class, 'createFromCart']);
    Route::patch('/orders/{order}/cancel', [OrderController::class, 'cancel']);
    Route::patch('/orders/{order}/status', [OrderController::class, 'updateStatus']); // Store owners
    Route::get('/orders/statistics', [OrderController::class, 'statistics']); // Store owners
    
    // Wishlist management
    Route::get('/wishlist', [WishlistController::class, 'index']);
    Route::post('/wishlist', [WishlistController::class, 'store']);
    Route::delete('/wishlist/{wishlist}', [WishlistController::class, 'destroy']);
    Route::delete('/wishlist/product', [WishlistController::class, 'removeProduct']);
    Route::post('/wishlist/check', [WishlistController::class, 'checkProduct']);
    Route::delete('/wishlist/clear', [WishlistController::class, 'clear']);
    
    // Stores (legacy)
    Route::apiResource('stores', StoresController::class);
});
