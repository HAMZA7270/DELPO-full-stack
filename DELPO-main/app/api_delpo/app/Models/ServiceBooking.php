<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

/**
 * نموذج حجز الخدمة - يمثل حجوزات الخدمات من العملاء
 * 
 * @property int $id - المعرف الفريد للحجز
 * @property int $client_id - معرف العميل الذي حجز الخدمة
 * @property int $service_provider_id - معرف مزود الخدمة
 * @property int $service_id - معرف الخدمة المحجوزة
 * @property \Illuminate\Support\Carbon $booking_date - تاريخ الحجز
 * @property \Illuminate\Support\Carbon $start_time - وقت بداية تقديم الخدمة
 * @property \Illuminate\Support\Carbon $end_time - وقت انتهاء تقديم الخدمة
 * @property string $status - حالة الحجز (pending, confirmed, in_progress, completed, cancelled)
 * @property float $total_price - السعر الإجمالي للخدمة
 * @property string|null $special_requirements - المتطلبات الخاصة للعميل
 * @property string $location_type - نوع موقع تقديم الخدمة (home, office, remote)
 * @property string|null $service_address - عنوان تقديم الخدمة
 * @property float|null $latitude - خط العرض لموقع الخدمة
 * @property float|null $longitude - خط الطول لموقع الخدمة
 * @property int|null $estimated_duration - المدة المقدرة للخدمة (بالدقائق)
 * @property int|null $actual_duration - المدة الفعلية للخدمة (بالدقائق)
 * @property string|null $cancellation_reason - سبب إلغاء الحجز
 * @property string|null $notes - ملاحظات إضافية على الحجز
 * @property string $payment_status - حالة الدفع (pending, paid, failed, refunded)
 * @property string $payment_method - طريقة الدفع المستخدمة
 * @property float $commission_rate - نسبة العمولة للمنصة
 * @property float $commission_amount - مبلغ العمولة للمنصة
 * @property float $provider_earnings - أرباح مزود الخدمة
 * @property string $booking_reference - رقم مرجعي للحجز
 * @property \Illuminate\Support\Carbon|null $completed_at - تاريخ إكمال الخدمة
 * @property \Illuminate\Support\Carbon|null $cancelled_at - تاريخ إلغاء الحجز
 * @property \Illuminate\Support\Carbon|null $created_at - تاريخ إنشاء الحجز
 * @property \Illuminate\Support\Carbon|null $updated_at - تاريخ آخر تحديث للحجز
 */
class ServiceBooking extends Model
{
    /** @use HasFactory<\Database\Factories\ServiceBookingsFactory> */
    use HasFactory;

    protected $table = 'service_bookings';

    /**
     * الحقول القابلة للتعبئة الجماعية
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'client_id',             // معرف العميل
        'service_provider_id',   // معرف مزود الخدمة
        'service_id',           // معرف الخدمة
        'booking_date',         // تاريخ الحجز
        'start_time',           // وقت البداية
        'end_time',             // وقت النهاية
        'status',               // حالة الحجز
        'total_price',          // السعر الإجمالي
        'special_requirements', // المتطلبات الخاصة
        'location_type',        // نوع الموقع
        'service_address',      // عنوان الخدمة
        'latitude',             // خط العرض
        'longitude',            // خط الطول
        'estimated_duration',   // المدة المقدرة
        'actual_duration',      // المدة الفعلية
        'cancellation_reason',  // سبب الإلغاء
        'notes',                // الملاحظات
        'payment_status',       // حالة الدفع
        'payment_method',       // طريقة الدفع
        'commission_rate',      // نسبة العمولة
        'commission_amount',    // مبلغ العمولة
        'provider_earnings',    // أرباح المزود
        'booking_reference',    // الرقم المرجعي
        'completed_at',         // تاريخ الإكمال
        'cancelled_at',         // تاريخ الإلغاء
    ];

    /**
     * تحويل أنواع البيانات
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'booking_date' => 'date',           // تاريخ الحجز
            'start_time' => 'datetime',         // وقت البداية
            'end_time' => 'datetime',           // وقت النهاية
            'completed_at' => 'datetime',       // تاريخ الإكمال
            'cancelled_at' => 'datetime',       // تاريخ الإلغاء
            'total_price' => 'decimal:2',       // السعر الإجمالي
            'commission_rate' => 'decimal:2',   // نسبة العمولة
            'commission_amount' => 'decimal:2', // مبلغ العمولة
            'provider_earnings' => 'decimal:2', // أرباح المزود
            'latitude' => 'decimal:8',          // خط العرض
            'longitude' => 'decimal:8',         // خط الطول
            'estimated_duration' => 'integer', // المدة المقدرة
            'actual_duration' => 'integer',    // المدة الفعلية
        ];
    }

    // العلاقات

    /**
     * الحصول على العميل الذي حجز الخدمة
     */
    public function client()
    {
        return $this->belongsTo(User::class, 'client_id');
    }

    /**
     * الحصول على مزود الخدمة
     */
    public function serviceProvider()
    {
        return $this->belongsTo(ServiceProvider::class);
    }

    /**
     * الحصول على الخدمة المحجوزة
     */
    public function service()
    {
        return $this->belongsTo(Service::class);
    }

    /**
     * الحصول على الدفعة المرتبطة بهذا الحجز
     */
    public function payment()
    {
        return $this->hasOne(Payment::class, 'booking_id');
    }

    /**
     * الحصول على تقييمات هذا الحجز
     */
    public function reviews()
    {
        return $this->morphMany(Review::class, 'reviewable');
    }

    // النطاقات (Scopes)

    /**
     * نطاق الحجوزات حسب الحالة
     */
    public function scopeByStatus($query, $status)
    {
        return $query->where('status', $status);
    }

    /**
     * نطاق الحجوزات المعلقة
     */
    public function scopePending($query)
    {
        return $query->where('status', 'pending');
    }

    /**
     * نطاق الحجوزات المؤكدة
     */
    public function scopeConfirmed($query)
    {
        return $query->where('status', 'confirmed');
    }

    /**
     * نطاق الخدمات المكتملة
     */
    public function scopeCompleted($query)
    {
        return $query->where('status', 'completed');
    }

    /**
     * نطاق الحجوزات المُلغاة
     */
    public function scopeCancelled($query)
    {
        return $query->where('status', 'cancelled');
    }

    /**
     * نطاق حجوزات اليوم
     */
    public function scopeToday($query)
    {
        return $query->whereDate('booking_date', today());
    }

    /**
     * نطاق الحجوزات المستقبلية
     */
    public function scopeUpcoming($query)
    {
        return $query->where('booking_date', '>=', today());
    }

    // الدوال المساعدة

    /**
     * فحص إذا كان الحجز معلقاً
     */
    public function isPending()
    {
        return $this->status === 'pending';
    }

    /**
     * فحص إذا كان الحجز مؤكداً
     */
    public function isConfirmed()
    {
        return $this->status === 'confirmed';
    }

    /**
     * فحص إذا كان الحجز مكتملاً
     */
    public function isCompleted()
    {
        return $this->status === 'completed';
    }

    /**
     * فحص إذا كان الحجز مُلغىً
     */
    public function isCancelled()
    {
        return $this->status === 'cancelled';
    }

    // الخصائص المحسوبة (Accessors)

    /**
     * الحصول على مدة الحجز بالساعات
     */
    public function getDurationInHoursAttribute()
    {
        if ($this->actual_duration) {
            return round($this->actual_duration / 60, 2);
        }
        
        if ($this->estimated_duration) {
            return round($this->estimated_duration / 60, 2);
        }
        
        if ($this->start_time && $this->end_time) {
            return $this->start_time->diffInHours($this->end_time);
        }
        
        return 0;
    }

    /**
     * الحصول على العنوان الكامل للخدمة
     */
    public function getFullAddressAttribute()
    {
        return $this->service_address ?? 'عن بُعد';
    }

    /**
     * الحصول على حالة الحجز مترجمة للعربية
     */
    public function getStatusInArabicAttribute()
    {
        $statuses = [
            'pending' => 'في الانتظار',
            'confirmed' => 'مؤكد',
            'in_progress' => 'قيد التنفيذ',
            'completed' => 'مكتمل',
            'cancelled' => 'ملغى'
        ];

        return $statuses[$this->status] ?? $this->status;
    }
}
