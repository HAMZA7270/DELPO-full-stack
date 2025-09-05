<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Review extends Model
{
	use HasFactory;

	/**
	 * The attributes that are mass assignable.
	 *
	 * @var array<int, string>
	 */
	protected $fillable = [
		'user_id', // معرف المستخدم	
		'reviewable_type',	// نوع الكائن الذي يتم مراجعته (مثل المنتج أو الطلب)
		'reviewable_id',	// معرف الكائن الذي يتم مراجعته
		'rating',		// التقييم
		'title',		// العنوان
		'comment',		// التعليق
		'is_verified',	// حالة التحقق
		'is_approved',	// حالة الموافقة
		'helpful_count',	// عدد المساعدات
		'photos',		// الصور
	];

	/**
	 * The attributes that should be cast.
	 *
	 * @return array<string, string>
	 */
	protected function casts(): array
	{
		return [
			'rating' => 'decimal:1',
			'is_verified' => 'boolean',
			'is_approved' => 'boolean',
			'helpful_count' => 'integer',
			'photos' => 'array',
		];
	}

	/**
	 * Get the user who wrote the review.
	 */
	public function user()
	{
		return $this->belongsTo(User::class);
	}

	/**
	 * Get the reviewable model (polymorphic).
	 */
	public function reviewable()
	{
		return $this->morphTo();
	}

	/**
	 * Scope for approved reviews.
	 */
	public function scopeApproved($query)
	{
		return $query->where('is_approved', true);
	}

	/**
	 * Scope for verified reviews.
	 */
	public function scopeVerified($query)
	{
		return $query->where('is_verified', true);
	}

	/**
	 * Scope for reviews by rating.
	 */
	public function scopeByRating($query, $rating)
	{
		return $query->where('rating', $rating);
	}

	/**
	 * Scope for reviews with minimum rating.
	 */
	public function scopeMinRating($query, $minRating)
	{
		return $query->where('rating', '>=', $minRating);
	}
}
