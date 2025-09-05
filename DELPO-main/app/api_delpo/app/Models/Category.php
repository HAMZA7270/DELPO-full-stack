<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;

class Category extends Model
{
    /** @use HasFactory<\Database\Factories\CategoryFactory> */
    use HasFactory;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'name',                // Display name: "Restaurants & Food" // اسم الفئة
        'slug',                // URL slug: "restaurants-and-food"  // رابط الفئة
        'description',         // Detailed description              // وصف الفئة
        'icon_url',            // URL to category icon       // رابط أيقونة الفئة
        'color_code',          // Hex color for UI: "#FF5722"   // لون الفئة    
        'sort_order',          // Display order: 1, 2, 3...     // ترتيب العرض
        'parent_id',           // For subcategories         // معرف الفئة الأم
        'is_active'            // Enable/disable category   // تفعيل/تعطيل الفئة
    ];

    /**
     * The attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'is_active' => 'boolean',
            'sort_order' => 'integer',
        ];
    }

    /**
     * Boot method to auto-generate slug
     */
    protected static function boot()
    {
        parent::boot();
        
        static::creating(function ($category) {
            if (empty($category->slug)) {
                $category->slug = Str::slug($category->name);
            }
        });

        static::updating(function ($category) {
            if ($category->isDirty('name') && empty($category->slug)) {
                $category->slug = Str::slug($category->name);
            }
        });
    }

    /**
     * Get the stores for the category.
     */
    public function stores()
    {
        return $this->hasMany(Stores::class);
    }

    /**
     * Get the products for the category.
     */
    public function products()
    {
        return $this->hasMany(Product::class);
    }

    /**
     * Get child categories (subcategories).
     */
    public function children()
    {
        return $this->hasMany(Category::class, 'parent_id')->orderBy('sort_order');
    }

    /**
     * Get parent category.
     */
    public function parent()
    {
        return $this->belongsTo(Category::class, 'parent_id');
    }

    /**
     * Scope for active categories.
     */
    public function scopeActive($query)
    {
        return $query->where('is_active', true);
    }

    /**
     * Scope for main categories (no parent).
     */
    public function scopeMainCategories($query)
    {
        return $query->whereNull('parent_id');
    }

    /**
     * Scope for ordered categories.
     */
    public function scopeOrdered($query)
    {
        return $query->orderBy('sort_order')->orderBy('name');
    }

    /**
     * Get route key name for URL binding.
     */
    public function getRouteKeyName()
    {
        return 'slug';
    }
}
