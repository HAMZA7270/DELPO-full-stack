<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Service extends Model
{
	/** @use HasFactory<\Database\Factories\ServicesFactory> */
	use HasFactory;

	protected $table = 'services';

	/**
	 * The attributes that are mass assignable.
	 *
	 * @var array<int, string>
	 */
	protected $fillable = [
		'service_provider_id',   // معرف مزود الخدمة
		'name',                  // اسم الخدمة
		'description',           // وصف الخدمة
		'category_id',           // معرف الفئة
		'price_type',           // نوع السعر (ثابت، بالساعة، مخصص)
		'base_price',            // السعر الأساسي
		'hourly_rate',           // السعر بالساعة
		'duration_hours',       // مدة الخدمة بالساعات
		'requirements',         // المتطلبات والشروط
		'service_images',      // صور الخدمة
		'availability_schedule', // جدول التوفر والمواعيد
		'service_location_type', // نوع موقع الخدمة (منزل، مكتب، عن بُعد)
		'max_distance',         // أقصى مسافة لتقديم الخدمة (كم)
		'preparation_time',     // وقت التحضير المطلوب (دقائق)
		'cancellation_policy',  // سياسة الإلغاء والاسترداد
		'terms_conditions',     // الشروط والأحكام
		'is_active',            // حالة نشاط الخدمة
		'is_featured',          // خدمة مميزة
		'sort_order',           // ترتيب العرض
		'seo_title',            // عنوان تحسين محركات البحث
		'seo_description',      // وصف تحسين محركات البحث
		'meta_tags',            // الكلمات المفتاحية والعلامات الوصفية
	];

	/**
	 * The attributes that should be cast.
	 *
	 * @return array<string, string>
	 */
	protected function casts(): array
	{
		return [
			'base_price' => 'decimal:2',
			'hourly_rate' => 'decimal:2',
			'duration_hours' => 'decimal:2',
			'max_distance' => 'decimal:2',
			'preparation_time' => 'integer',
			'sort_order' => 'integer',
			'requirements' => 'array',
			'service_images' => 'array',
			'availability_schedule' => 'array',
			'meta_tags' => 'array',
			'is_active' => 'boolean',
			'is_featured' => 'boolean',
		];
	}

	/**
	 * Get the service provider that owns the service.
	 */
	public function serviceProvider()
	{
		return $this->belongsTo(ServiceProvider::class);
	}

	/**
	 * Get the category of the service.
	 */
	public function category()
	{
		return $this->belongsTo(Category::class);
	}

	/**
	 * Get the service bookings for this service.
	 */
	public function serviceBookings()
	{
		return $this->hasMany(ServiceBooking::class);
	}

	/**
	 * Get reviews for this service.
	 */
	public function reviews()
	{
		return $this->morphMany(Review::class, 'reviewable');
	}

	/**
	 * Scope for active services.
	 */
	public function scopeActive($query)
	{
		return $query->where('is_active', true);
	}

	/**
	 * Scope for featured services.
	 */
	public function scopeFeatured($query)
	{
		return $query->where('is_featured', true);
	}

	/**
	 * Scope for services by category.
	 */
	public function scopeByCategory($query, $categoryId)
	{
		return $query->where('category_id', $categoryId);
	}

	/**
	 * Scope for services by price range.
	 */
	public function scopeByPriceRange($query, $minPrice, $maxPrice)
	{
		return $query->whereBetween('base_price', [$minPrice, $maxPrice]);
	}

	/**
	 * Get the route key name for URL binding.
	 */
	public function getRouteKeyName()
	{
		return 'id';
	}

	/**
	 * Get the formatted price.
	 */
	public function getFormattedPriceAttribute()
	{
		if ($this->price_type === 'hourly') {
			return '$' . number_format((float) $this->hourly_rate, 2) . '/hr';
		}
		return '$' . number_format((float) $this->base_price, 2);
	}

	/**
	 * Get the average rating.
	 */
	public function getAverageRatingAttribute()
	{
		return $this->reviews()->avg('rating') ?? 0;
	}

	/**
	 * Get the total reviews count.
	 */
	public function getTotalReviewsAttribute()
	{
		return $this->reviews()->count();
	}
}
