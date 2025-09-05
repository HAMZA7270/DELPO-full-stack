<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class ProductImage extends Model
{
    use HasFactory;

    protected $fillable = [
        'product_id',   // معرف المنتج
        'path',         // مسار الصورة
        'url',          // رابط الصورة
        'alt_text',    // نص بديل
        'type',        // نوع الصورة
        'sort_order'   // ترتيب الفرز
    ];

    protected $casts = [
        'sort_order' => 'integer'
    ];

    /**
     * Get the product that owns the image
     */
    public function product(): BelongsTo
    {
        return $this->belongsTo(Product::class);
    }
}
