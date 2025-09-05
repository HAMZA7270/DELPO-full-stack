<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Payment extends Model
{
	use HasFactory;

	/**
	 * The attributes that are mass assignable.
	 *
	 * @var array<int, string>
	 */
	protected $fillable = [
		'order_id',	// معرف الطلب
		'booking_id', // معرف الحجز للخدمات
		'user_id',   // معرف المستخدم
		'amount',    // المبلغ الإجمالي
		'currency',  // العملة
		'payment_method', // طريقة الدفع
		'payment_status', // حالة الدفع
		'transaction_id', // معرف المعاملة
		'gateway_response', // استجابة بوابة الدفع
		'fee_amount', // رسوم المعاملة
		'net_amount', // المبلغ الصافي بعد الرسوم
		'processed_at', // تاريخ ووقت المعالجة
		'refunded_at',  // تاريخ ووقت الاسترداد (إذا كان هناك)
		'refund_amount', // مبلغ الاسترداد (إذا كان هناك)
		'notes',        // ملاحظات إضافية
	];

	protected $casts = [
		'booking_id' => 'integer',
		'user_id' => 'integer',
		'amount' => 'decimal:2',
		'currency' => 'string',
		'payment_method' => 'string',
		'payment_status' => 'string',
		'transaction_id' => 'string',
		'gateway_response' => 'array',
		'fee_amount' => 'decimal:2',
		'net_amount' => 'decimal:2',
		'processed_at' => 'datetime',
		'refunded_at' => 'datetime',
		'refund_amount' => 'decimal:2',
		'notes' => 'string',
	];

	/**
	 * The attributes that should be cast.
	 *
	 * @return array<string, string>
	 */
	protected function casts(): array
	{
		return [
			'amount' => 'decimal:2',
			'fee_amount' => 'decimal:2',
			'net_amount' => 'decimal:2',
			'refund_amount' => 'decimal:2',
			'gateway_response' => 'array',
			'processed_at' => 'datetime',
			'refunded_at' => 'datetime',
		];
	}

	/**
	 * Get the user who made the payment.
	 */
	public function user()
	{
		return $this->belongsTo(User::class);
	}

	/**
	 * Get the order (if this is an order payment).
	 */
	public function order()
	{
		return $this->belongsTo(Order::class);
	}

	/**
	 * Get the service booking (if this is a service payment).
	 */
	public function serviceBooking()
	{
		return $this->belongsTo(ServiceBooking::class, 'booking_id');
	}

	/**
	 * Scope for successful payments.
	 */
	public function scopeSuccessful($query)
	{
		return $query->where('payment_status', 'completed');
	}

	/**
	 * Scope for pending payments.
	 */
	public function scopePending($query)
	{
		return $query->where('payment_status', 'pending');
	}

	/**
	 * Scope for failed payments.
	 */
	public function scopeFailed($query)
	{
		return $query->where('payment_status', 'failed');
	}

	/**
	 * Check if payment is successful.
	 */
	public function isSuccessful()
	{
		return $this->payment_status === 'completed';
	}

	/**
	 * Check if payment is pending.
	 */
	public function isPending()
	{
		return $this->payment_status === 'pending';
	}

	/**
	 * Check if payment failed.
	 */
	public function isFailed()
	{
		return $this->payment_status === 'failed';
	}
}
