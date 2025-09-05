<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\HasOne;

class Order extends Model
{
	/** @use HasFactory<\Database\Factories\OrderFactory> */
	use HasFactory;

	/**
	 * The attributes that are mass assignable.
	 *
	 * @var array<int, string>
	 */
	protected $fillable = [
		'user_id',                   // معرف المستخدم    
		'store_id',                 // معرف المتجر  
		'order_number',             // رقم الطلب    
		'total_amount',             // المبلغ الإجمالي
		'status',                   // حالة الطلب
		'order_date',               // تاريخ الطلب
		'shipping_address',         // عنوان الشحن
		'billing_address',          // عنوان الفواتير
		'notes'                     // ملاحظات
	];

	/**
	 * The attributes that should be cast.
	 *
	 * @return array<string, string>
	 */
	protected function casts(): array
	{
		return [
			'total_amount' => 'decimal:2',
			'order_date' => 'datetime',
			'shipping_address' => 'json',
			'billing_address' => 'json'
		];
	}

	const STATUS_PENDING = 'pending';
	const STATUS_CONFIRMED = 'confirmed';
	const STATUS_PROCESSING = 'processing';
	const STATUS_SHIPPED = 'shipped';
	const STATUS_DELIVERED = 'delivered';
	const STATUS_CANCELLED = 'cancelled';
	const STATUS_REFUNDED = 'refunded';

	/**
	 * Get the user that owns the order.
	 */
	public function user(): BelongsTo
	{
		return $this->belongsTo(User::class);
	}

	/**
	 * Get the store that owns the order.
	 */
	public function store(): BelongsTo
	{
		return $this->belongsTo(Stores::class);
	}

	/**
	 * Get the order items
	 */
	public function items(): HasMany
	{
		return $this->hasMany(OrderItem::class);
	}

	/**
	 * Get the payment for this order
	 */
	public function payment(): HasOne
	{
		return $this->hasOne(Payment::class);
	}

	/**
	 * Get the delivery for this order
	 */
	public function delivery(): HasOne
	{
		return $this->hasOne(Delivery::class);
	}

	/**
	 * Generate unique order number
	 */
	public static function generateOrderNumber(): string
	{
		return 'ORD-' . date('Y') . '-' . str_pad(mt_rand(1, 999999), 6, '0', STR_PAD_LEFT);
	}

	/**
	 * Calculate total amount from order items
	 */
	public function calculateTotal(): float
	{
		return $this->items->sum(function ($item) {
			return $item->quantity * $item->price;
		});
	}

	/**
	 * Check if order can be cancelled
	 */
	public function canBeCancelled(): bool
	{
		return in_array($this->status, [self::STATUS_PENDING, self::STATUS_CONFIRMED]);
	}

	/**
	 * Check if order is completed
	 */
	public function isCompleted(): bool
	{
		return $this->status === self::STATUS_DELIVERED;
	}
}
