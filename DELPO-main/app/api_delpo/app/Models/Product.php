<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

/**
 * @property int $id
 * @property string $name
 * @property string $description
 * @property float $price
 * @property int $stock_quantity
 * @property string $sku
 * @property float|null $weight
 * @property string|null $dimensions
 * @property bool $is_active
 * @property int $category_id
 * @property int $store_id
 * @property \Illuminate\Support\Carbon|null $created_at
 * @property \Illuminate\Support\Carbon|null $updated_at
 */
class Product extends Model
{
    /** @use HasFactory<\Database\Factories\ProductFactory> */
    use HasFactory;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'name',     // اسم المنتج
        'description', // وصف المنتج
        'price',      // سعر المنتج
        'store_id',   // معرف المتجر
        'category_id',// معرف الفئة
        'stock_quantity', // كمية المخزون
        'sku',       // وحدة التخزين
        'weight',    // الوزن
        'dimensions', // الأبعاد
        'is_active', // الحالة
        'featured',  // مميز
        'meta_title',// عنوان الميتا
        'meta_description' // وصف الميتا
    ];

    /**
     * The attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'price' => 'decimal:2',
            'weight' => 'decimal:2',
            'is_active' => 'boolean',
            'featured' => 'boolean',
        ];
    }

    /**
     * Get the store that owns the product.
     */
    public function store()
    {
        return $this->belongsTo(Stores::class, 'store_id');
    }

    /**
     * Get the category that belongs to the product.
     */
    public function category()
    {
        return $this->belongsTo(Category::class);
    }

    /**
     * Get the product images
     */
    public function images()
    {
        return $this->hasMany(ProductImage::class);
    }

    /**
     * Get the product reviews
     */
    public function reviews()
    {
        return $this->hasMany(ProductReview::class);
    }

    // Scopes

    /**
     * Scope for active products
     */
    public function scopeActive($query)
    {
        return $query->where('is_active', true);
    }

    /**
     * Scope for featured products
     */
    public function scopeFeatured($query)
    {
        return $query->where('featured', true);
    }

    /**
     * Scope for products in stock
     */
    public function scopeInStock($query)
    {
        return $query->where('stock_quantity', '>', 0);
    }

    // Helper methods

    /**
     * Check if product is in stock
     */
    public function isInStock(): bool
    {
        return $this->stock_quantity > 0;
    }

    /**
     * Get average rating
     */
    public function getAverageRating(): float
    {
        return $this->reviews()->avg('rating') ?? 0;
    }

    /**
     * Get total reviews count
     */
    public function getReviewsCount(): int
    {
        return $this->reviews()->count();
    }

    /**
     * Decrease stock quantity
     */
    public function decreaseStock(int $quantity): bool
    {
        if ($this->stock_quantity >= $quantity) {
            $this->stock_quantity -= $quantity;
            return $this->save();
        }
        return false;
    }
}
