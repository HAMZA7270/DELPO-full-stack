<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

/**
 * نموذج مزود الخدمة - يمثل الأشخاص أو الشركات التي تقدم الخدمات
 * 
 * @property int $id - المعرف الفريد لمزود الخدمة
 * @property int $user_id - معرف المستخدم المرتبط بمزود الخدمة
 * @property string $business_name - اسم العمل أو الشركة
 * @property int $service_category_id - معرف فئة الخدمة الرئيسية
 * @property array|null $skills - المهارات والخبرات
 * @property int $experience_years - سنوات الخبرة في المجال
 * @property float $hourly_rate - السعر بالساعة
 * @property string|null $description - وصف تفصيلي عن مزود الخدمة
 * @property array|null $portfolio_images - صور أعمال سابقة ومعرض الأعمال
 * @property array|null $certifications - الشهادات والمؤهلات المهنية
 * @property array|null $availability_schedule - جدول أوقات التوفر والعمل
 * @property float $service_radius - نطاق تقديم الخدمة (بالكيلومتر)
 * @property float|null $latitude - خط العرض لموقع مزود الخدمة
 * @property float|null $longitude - خط الطول لموقع مزود الخدمة
 * @property string|null $address - عنوان مزود الخدمة
 * @property string|null $phone - رقم الهاتف للتواصل
 * @property string|null $email - البريد الإلكتروني للتواصل
 * @property string|null $website - الموقع الإلكتروني الشخصي
 * @property array|null $social_media_links - روابط وسائل التواصل الاجتماعي
 * @property float $rating - متوسط التقييم العام
 * @property int $total_reviews - إجمالي عدد التقييمات
 * @property int $total_jobs_completed - إجمالي عدد الأعمال المكتملة
 * @property bool $is_verified - هل تم التحقق من هوية مزود الخدمة
 * @property bool $is_active - حالة نشاط الحساب
 * @property bool $is_available - توفر مزود الخدمة لقبول حجوزات جديدة
 * @property array|null $verification_documents - وثائق التحقق من الهوية
 * @property \Illuminate\Support\Carbon|null $created_at - تاريخ إنشاء الملف الشخصي
 * @property \Illuminate\Support\Carbon|null $updated_at - تاريخ آخر تحديث للملف الشخصي
 */
class ServiceProvider extends Model
{
    /** @use HasFactory<\Database\Factories\ServiceProvidersFactory> */
    use HasFactory;

    protected $table = 'service_providers';

    /**
     * الحقول القابلة للتعبئة الجماعية
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'user_id',                // معرف المستخدم
        'business_name',          // اسم العمل
        'service_category_id',    // معرف فئة الخدمة
        'skills',                 // المهارات
        'experience_years',       // سنوات الخبرة
        'hourly_rate',           // السعر بالساعة
        'description',           // الوصف
        'portfolio_images',      // صور الأعمال
        'certifications',        // الشهادات
        'availability_schedule', // جدول التوفر
        'service_radius',        // نطاق الخدمة
        'latitude',              // خط العرض
        'longitude',             // خط الطول
        'address',               // العنوان
        'phone',                 // رقم الهاتف
        'email',                 // البريد الإلكتروني
        'website',               // الموقع الإلكتروني
        'social_media_links',    // روابط التواصل
        'rating',                // التقييم
        'total_reviews',         // عدد التقييمات
        'total_jobs_completed',  // الأعمال المكتملة
        'is_verified',           // حالة التحقق
        'is_active',             // حالة النشاط
        'is_available',          // حالة التوفر
        'verification_documents', // وثائق التحقق
    ];

    /**
     * تحويل أنواع البيانات
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'skills' => 'array',                // المهارات
            'portfolio_images' => 'array',      // صور الأعمال
            'certifications' => 'array',        // الشهادات
            'availability_schedule' => 'array', // جدول التوفر
            'social_media_links' => 'array',    // روابط التواصل
            'verification_documents' => 'array', // وثائق التحقق
            'hourly_rate' => 'decimal:2',       // السعر بالساعة
            'service_radius' => 'decimal:2',    // نطاق الخدمة
            'latitude' => 'decimal:8',          // خط العرض
            'longitude' => 'decimal:8',         // خط الطول
            'rating' => 'decimal:2',            // التقييم
            'experience_years' => 'integer',    // سنوات الخبرة
            'total_reviews' => 'integer',       // عدد التقييمات
            'total_jobs_completed' => 'integer', // الأعمال المكتملة
            'is_verified' => 'boolean',         // حالة التحقق
            'is_active' => 'boolean',           // حالة النشاط
            'is_available' => 'boolean',        // حالة التوفر
        ];
    }

    // العلاقات

    /**
     * الحصول على المستخدم المرتبط بمزود الخدمة
     */
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    /**
     * الحصول على فئة الخدمة الرئيسية
     */
    public function serviceCategory()
    {
        return $this->belongsTo(Category::class, 'service_category_id');
    }

    /**
     * الحصول على الخدمات التي يقدمها هذا المزود
     */
    public function services()
    {
        return $this->hasMany(Service::class);
    }

    /**
     * الحصول على حجوزات الخدمات لهذا المزود
     */
    public function serviceBookings()
    {
        return $this->hasMany(ServiceBooking::class);
    }

    /**
     * الحصول على التقييمات لمزود الخدمة
     */
    public function reviews()
    {
        return $this->morphMany(Review::class, 'reviewable');
    }

    // النطاقات (Scopes)

    /**
     * نطاق مزودي الخدمة المتحقق منهم
     */
    public function scopeVerified($query)
    {
        return $query->where('is_verified', true);
    }

    /**
     * نطاق مزودي الخدمة النشطين
     */
    public function scopeActive($query)
    {
        return $query->where('is_active', true);
    }

    /**
     * نطاق مزودي الخدمة المتاحين
     */
    public function scopeAvailable($query)
    {
        return $query->where('is_available', true);
    }

    /**
     * نطاق مزودي الخدمة حسب الحد الأدنى للتقييم
     */
    public function scopeByMinRating($query, $rating)
    {
        return $query->where('rating', '>=', $rating);
    }

    /**
     * نطاق مزودي الخدمة ضمن نطاق جغرافي محدد
     */
    public function scopeWithinRadius($query, $latitude, $longitude, $radius)
    {
        return $query->selectRaw("*, 
                    ( 6371 * acos( cos( radians(?) ) *
                      cos( radians( latitude ) )
                      * cos( radians( longitude ) - radians(?) )
                      + sin( radians(?) ) *
                      sin( radians( latitude ) ) ) ) AS distance", 
                    [$latitude, $longitude, $latitude])
                   ->where(function($q) use ($radius) {
                       $q->whereRaw("( 6371 * acos( cos( radians(?) ) *
                         cos( radians( latitude ) )
                         * cos( radians( longitude ) - radians(?) )
                         + sin( radians(?) ) *
                         sin( radians( latitude ) ) ) ) < ?", 
                         [request()->latitude, request()->longitude, request()->latitude, $radius]);
                   });
    }

    // الدوال المساعدة

    /**
     * فحص إذا كان مزود الخدمة متحقق منه
     */
    public function isVerified()
    {
        return $this->is_verified;
    }

    /**
     * فحص إذا كان مزود الخدمة متاحاً
     */
    public function isAvailable()
    {
        return $this->is_available && $this->is_active;
    }

    /**
     * فحص إذا كان مزود الخدمة نشطاً
     */
    public function isActive()
    {
        return $this->is_active;
    }

    // الخصائص المحسوبة (Accessors)

    /**
     * الحصول على التقييم مُنسق
     */
    public function getFormattedRatingAttribute()
    {
        return number_format((float) $this->rating, 1) . ' من 5';
    }

    /**
     * الحصول على نص سنوات الخبرة
     */
    public function getExperienceTextAttribute()
    {
        if ($this->experience_years == 1) {
            return 'سنة واحدة من الخبرة';
        } elseif ($this->experience_years == 2) {
            return 'سنتان من الخبرة';
        } elseif ($this->experience_years <= 10) {
            return $this->experience_years . ' سنوات من الخبرة';
        } else {
            return $this->experience_years . ' سنة من الخبرة';
        }
    }

    /**
     * الحصول على السعر بالساعة مُنسق
     */
    public function getFormattedHourlyRateAttribute()
    {
        return '$' . number_format((float) $this->hourly_rate, 2) . '/ساعة';
    }
}
