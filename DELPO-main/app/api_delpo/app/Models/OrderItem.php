<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class OrderItem extends Model
{
	use HasFactory;

	protected $fillable = [
		'order_id',		// معرف الطلب
		'product_id',	// معرف المنتج
		'quantity',		// الكمية
		'price'			// السعر
	];

	protected $casts = [
		'price' => 'decimal:2',
		'quantity' => 'integer'
	];

	/**
	 * Get the order that owns the order item
	 */
	public function order(): BelongsTo
	{
		return $this->belongsTo(Order::class);
	}

	/**
	 * Get the product for this order item
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
}
