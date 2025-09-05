<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Delivery extends Model
{
    use HasFactory;

    protected $fillable = [
        'order_id',         // رقم الطلب
        'delivery_address', // عنوان التسليم
        'delivery_method',  // طريقة التسليم
        'tracking_number',  // رقم التتبع
        'estimated_delivery_date', // تاريخ التسليم المقدر
        'actual_delivery_date',    // تاريخ التسليم الفعلي
        'delivery_status',      // حالة التسليم
        'delivery_notes',           // ملاحظات التسليم
        'driver_name',               // اسم السائق
        'driver_phone'              // هاتف السائق
    ];

    protected $casts = [
        'delivery_address' => 'json',
        'estimated_delivery_date' => 'datetime',
        'actual_delivery_date' => 'datetime'
    ];

    const STATUS_PENDING = 'pending';
    const STATUS_ASSIGNED = 'assigned';
    const STATUS_IN_TRANSIT = 'in_transit';
    const STATUS_OUT_FOR_DELIVERY = 'out_for_delivery';
    const STATUS_DELIVERED = 'delivered';
    const STATUS_FAILED = 'failed';
    const STATUS_RETURNED = 'returned';

    const METHOD_STANDARD = 'standard';
    const METHOD_EXPRESS = 'express';
    const METHOD_SAME_DAY = 'same_day';
    const METHOD_PICKUP = 'pickup';

    /**
     * Get the order that owns the delivery
     */
    public function order(): BelongsTo
    {
        return $this->belongsTo(Order::class);
    }

    /**
     * Check if delivery is completed
     */
    public function isDelivered(): bool
    {
        return $this->delivery_status === self::STATUS_DELIVERED;
    }

    /**
     * Check if delivery is in transit
     */
    public function isInTransit(): bool
    {
        return in_array($this->delivery_status, [
            self::STATUS_IN_TRANSIT,
            self::STATUS_OUT_FOR_DELIVERY
        ]);
    }

    /**
     * Check if delivery failed
     */
    public function isFailed(): bool
    {
        return $this->delivery_status === self::STATUS_FAILED;
    }
}
