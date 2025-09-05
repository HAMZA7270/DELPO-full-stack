<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

/**
 * نموذج المستخدم - يمثل بيانات المستخدمين في النظام
 * 
 * @property int $id - المعرف الفريد للمستخدم
 * @property string $name - اسم المستخدم الكامل
 * @property string $email - البريد الإلكتروني للمستخدم (فريد)
 * @property string $role_type - نوع دور المستخدم (client, store_owner, service_provider, admin)
 * @property bool $is_active - حالة نشاط المستخدم
 * @property \Illuminate\Support\Carbon|null $email_verified_at - تاريخ تأكيد البريد الإلكتروني
 * @property string $password - كلمة المرور المشفرة
 * @property string|null $remember_token - رمز تذكر تسجيل الدخول
 * @property \Illuminate\Support\Carbon|null $created_at - تاريخ إنشاء الحساب
 * @property \Illuminate\Support\Carbon|null $updated_at - تاريخ آخر تحديث
 */
class User extends Authenticatable
{
    /** @use HasFactory<\Database\Factories\UserFactory> */
    use HasFactory, Notifiable, HasApiTokens;

    /**
     * الحقول القابلة للتعبئة الجماعية
     *
     * @var list<string>
     */
    protected $fillable = [
        'name',              // اسم المستخدم
        'email',             // البريد الإلكتروني
        'password',          // كلمة المرور
        'role_type',         // نوع الدور
        'is_active',         // حالة النشاط
        'email_verified_at', // تاريخ تأكيد البريد
    ];

    /**
     * الحقول المخفية من التسلسل
     *
     * @var list<string>
     */
    protected $hidden = [
        'password',        // كلمة المرور
        'remember_token',  // رمز التذكر
    ];

    /**
     * تحويل أنواع البيانات
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime', // تحويل إلى تاريخ ووقت
            'password' => 'hashed',            // تشفير كلمة المرور
            'is_active' => 'boolean',          // تحويل إلى قيمة منطقية
        ];
    }

    // العلاقات
    
    /**
     * الحصول على ملف المستخدم الشخصي
     */
    public function profile()
    {
        return $this->hasOne(UserProfile::class);
    }

    /**
     * الحصول على عناوين المستخدم
     */
    public function addresses()
    {
        return $this->hasMany(Address::class);
    }

    /**
     * الحصول على متاجر المستخدم (إذا كان صاحب متجر)
     */
    public function stores()
    {
        return $this->hasMany(Stores::class);
    }

    /**
     * الحصول على المتجر الأساسي للمستخدم (لأصحاب المتاجر)
     */
    public function store()
    {
        return $this->hasOne(Stores::class);
    }

    /**
     * الحصول على ملف مزود الخدمة للمستخدم
     */
    public function serviceProvider()
    {
        return $this->hasOne(ServiceProvider::class);
    }

    /**
     * الحصول على طلبات المستخدم كعميل
     */
    public function orders()
    {
        return $this->hasMany(Order::class);
    }

    /**
     * الحصول على حجوزات الخدمات كعميل
     */
    public function serviceBookings()
    {
        return $this->hasMany(ServiceBooking::class, 'client_id');
    }

    // النطاقات (Scopes)

    /**
     * نطاق للمستخدمين النشطين
     */
    public function scopeActive($query)
    {
        return $query->where('is_active', true);
    }

    /**
     * نطاق للمستخدمين حسب الدور
     */
    public function scopeByRole($query, $role)
    {
        return $query->where('role_type', $role);
    }

    // الدوال المساعدة

    /**
     * فحص إذا كان المستخدم عميلاً
     */
    public function isClient()
    {
        return $this->role_type === 'client';
    }

    /**
     * فحص إذا كان المستخدم صاحب متجر
     */
    public function isStoreOwner()
    {
        return $this->role_type === 'store_owner';
    }

    /**
     * فحص إذا كان المستخدم مزود خدمة
     */
    public function isServiceProvider()
    {
        return $this->role_type === 'service_provider';
    }

    /**
     * فحص إذا كان المستخدم مديراً
     */
    public function isAdmin()
    {
        return $this->role_type === 'admin';
    }
}
