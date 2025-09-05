<?php

namespace App\Http\Controllers;

use App\Models\UserProfile;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class UserProfilesController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(): JsonResponse
    {
        $profiles = UserProfile::with('user')->paginate(15);
        
        return response()->json([
            'success' => true,
            'data' => $profiles->items(),
            'meta' => [
                'current_page' => $profiles->currentPage(),
                'total' => $profiles->total(),
                'per_page' => $profiles->perPage(),
            ]
        ]);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request): JsonResponse
    {
        // Simple validation
        $request->validate([
            'user_id' => 'required|exists:users,id|unique:user_profiles,user_id',
            'first_name' => 'required|string|max:255',
            'last_name' => 'required|string|max:255',
            'phone' => 'nullable|string|max:20',
            'email' => 'nullable|email',
        ]);

        $profile = UserProfile::create($request->all());
        
        return response()->json([
            'success' => true,
            'message' => 'Profile created successfully',
            'data' => $profile->load('user')
        ], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(UserProfile $userProfile): JsonResponse
    {
        return response()->json([
            'success' => true,
            'data' => $userProfile->load('user')
        ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, UserProfile $userProfile): JsonResponse
    {
        // Simple validation
        $request->validate([
            'first_name' => 'sometimes|required|string|max:255',
            'last_name' => 'sometimes|required|string|max:255',
            'phone' => 'nullable|string|max:20',
            'email' => 'nullable|email',
        ]);

        $userProfile->update($request->all());
        
        return response()->json([
            'success' => true,
            'message' => 'Profile updated successfully',
            'data' => $userProfile->load('user')
        ]);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(UserProfile $userProfile): JsonResponse
    {
        $userProfile->delete();
        
        return response()->json([
            'success' => true,
            'message' => 'Profile deleted successfully'
        ]);
    }

    /**
     * Get profile by user ID.
     */
    public function getByUser(Request $request, $userId): JsonResponse
    {
        $profile = UserProfile::where('user_id', $userId)->with('user')->first();
        
        if (!$profile) {
            return response()->json([
                'success' => false,
                'message' => 'Profile not found'
            ], 404);
        }
        
        return response()->json([
            'success' => true,
            'data' => $profile
        ]);
    }

    /**
     * Get current user's profile.
     */
    public function me(Request $request): JsonResponse
    {
        $user = $request->user();
        $profile = $user->profile;
        
        if (!$profile) {
            return response()->json([
                'success' => false,
                'message' => 'Profile not found'
            ], 404);
        }
        
        return response()->json([
            'success' => true,
            'data' => $profile
        ]);
    }
}
