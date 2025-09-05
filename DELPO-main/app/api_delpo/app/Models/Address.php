<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

/**
 * نموذج العنوان - يمثل عناوين المستخدمين في النظام
 * 
 * @property int $id - المعرف الفريد للعنوان
 * @property int $user_id - معرف المستخدم صاحب العنوان
 * @property string $type - نوع العنوان (home, work, billing, shipping)
 * @property string $label - تسمية العنوان (مثل: المنزل، العمل)
 * @property string $address_line_1 - السطر الأول من العنوان
 * @property string|null $address_line_2 - السطر الثاني من العنوان (اختياري)
 * @property string $city - المدينة
 * @property string|null $state - الولاية أو المنطقة (اختياري)
 * @property string|null $postal_code - الرمز البريدي (اختياري)
 * @property string $country - البلد
 * @property float|null $latitude - خط العرض للموقع الجغرافي (اختياري)
 * @property float|null $longitude - خط الطول للموقع الجغرافي (اختياري)
 * @property bool $is_default - هل هذا العنوان الافتراضي
 * @property bool $is_active - حالة نشاط العنوان
 * @property \Illuminate\Support\Carbon|null $created_at - تاريخ إنشاء العنوان
 * @property \Illuminate\Support\Carbon|null $updated_at - تاريخ آخر تحديث
 */
class Address extends Model
{
    /** @use HasFactory<\Database\Factories\AddressesFactory> */
    use HasFactory;

    protected $table = 'addresses';

    /**
     * الحقول القابلة للتعبئة الجماعية
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'user_id',        // معرف المستخدم
        'type',           // نوع العنوان
        'label',          // تسمية العنوان
        'address_line_1', // السطر الأول من العنوان
        'address_line_2', // السطر الثاني من العنوان
        'city',           // المدينة
        'state',          // الولاية/المنطقة
        'postal_code',    // الرمز البريدي
        'country',        // البلد
        'latitude',       // خط العرض
        'longitude',      // خط الطول
        'is_default',     // العنوان الافتراضي
        'is_active',      // حالة النشاط
    ];

    /**
     * تحويل أنواع البيانات
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'latitude' => 'decimal:8',   // تحويل خط العرض لرقم عشري بـ 8 منازل
            'longitude' => 'decimal:8',  // تحويل خط الطول لرقم عشري بـ 8 منازل
            'is_default' => 'boolean',   // تحويل الافتراضي لقيمة منطقية
            'is_active' => 'boolean',    // تحويل حالة النشاط لقيمة منطقية
        ];
    }

    // العلاقات

    /**
     * الحصول على المستخدم صاحب العنوان
     */
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    /**
     * الحصول على الطلبات التي تستخدم هذا العنوان للتوصيل
     */
    public function orders()
    {
        return $this->hasMany(Order::class, 'delivery_address_id');
    }

    // الخصائص المحسوبة (Accessors)

    /**
     * الحصول على العنوان الكامل مُنسق
     */
    public function getFullAddressAttribute()
    {
        $address = $this->address_line_1;
        if ($this->address_line_2) {
            $address .= ', ' . $this->address_line_2;
        }
        $address .= ', ' . $this->city;
        if ($this->state) {
            $address .= ', ' . $this->state;
        }
        if ($this->postal_code) {
            $address .= ' ' . $this->postal_code;
        }
        if ($this->country) {
            $address .= ', ' . $this->country;
        }
        return $address;
    }

    // النطاقات (Scopes)

    /**
     * نطاق للعناوين الافتراضية
     */
    public function scopeDefault($query)
    {
        return $query->where('is_default', true);
    }

    /**
     * نطاق للعناوين النشطة
     */
    public function scopeActive($query)
    {
        return $query->where('is_active', true);
    }

    /**
     * نطاق للعناوين حسب النوع
     */
    public function scopeByType($query, $type)
    {
        return $query->where('type', $type);
    }
}
