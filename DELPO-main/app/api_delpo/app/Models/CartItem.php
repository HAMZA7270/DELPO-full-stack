<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class CartItem extends Model
{
	use HasFactory;

	protected $fillable = [
		'cart_id',     // معرف السلة
		'product_id',  // معرف المنتج
		'quantity',    // الكمية
		'price',       // السعر
	];

	/**
	 * تحويل أنواع البيانات
	 */
	protected $casts = [
		'price' => 'decimal:2',      // تحويل السعر لرقم عشري
		'quantity' => 'integer',     // تحويل الكمية لرقم صحيح
	];

	/**
	 * Get the cart that owns the cart item
	 */
	public function cart(): BelongsTo
	{
		return $this->belongsTo(Cart::class);
	}

	/**
	 * Get the product for this cart item
	 */
	public function product(): BelongsTo
	{
		return $this->belongsTo(Product::class);
	}

	/**
	 * Get the total price for this item (quantity * price)
	 */
	public function getTotalPrice(): float
	{
		return $this->quantity * $this->price;
	}

	/**
	 * Update quantity and price based on current product price
	 */
	public function updateFromProduct(): void
	{
		if ($this->product) {
			$this->price = $this->product->price;
			$this->save();
		}
	}
}
