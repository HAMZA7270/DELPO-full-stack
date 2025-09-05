<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class ProductReview extends Model
{
    use HasFactory;

    protected $fillable = [
        'product_id',   // معرف المنتج
        'user_id',      // معرف المستخدم
        'rating',      // التقييم
        'comment',     // التعليق
        'is_verified_purchase' // حالة الشراء الموثوق
    ];

    protected $casts = [
        'rating' => 'integer',
        'is_verified_purchase' => 'boolean'
    ];

    /**
     * Get the product that owns the review
     */
    public function product(): BelongsTo
    {
        return $this->belongsTo(Product::class);
    }

    /**
     * Get the user that wrote the review
     */
    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    /**
     * Scope for verified purchases only
     */
    public function scopeVerifiedPurchase($query)
    {
        return $query->where('is_verified_purchase', true);
    }

    /**
     * Scope for specific rating
     */
    public function scopeRating($query, $rating)
    {
        return $query->where('rating', $rating);
    }
}
