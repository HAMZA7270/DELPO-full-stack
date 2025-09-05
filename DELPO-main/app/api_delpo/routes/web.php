<?php

use Illuminate\Support\Facades\Route;

// Simple login route to prevent errors (for API, we use JSON responses)
Route::get('/login', function () {
    return response()->json([
        'message' => 'This is an API endpoint. Please use /api/login with POST method.'
    ], 401);
})->name('login');

