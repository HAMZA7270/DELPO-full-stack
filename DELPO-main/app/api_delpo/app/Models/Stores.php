<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Stores extends Model
{
    /** @use HasFactory<\Database\Factories\StoresFactory> */
    use HasFactory;

    /**
     * الحقول القابلة للتعديل والإدخال
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'name',                 // اسم المتجر
        'user_id',              // معرف صاحب المتجر
        'area_name',            // اسم المنطقة أو الحي
        'phone_number',         // رقم الهاتف
        'email_address',        // البريد الإلكتروني
        'category_id',          // معرف فئة المتجر (مطاعم، إلكترونيات، إلخ)
        'logo_image_url',       // رابط صورة الشعار
        'background_image_url', // رابط الصورة الخلفية للمتجر
        'store_photos_urls',    // روابط صور المتجر (متعددة)
        'staff_photos_urls',    // روابط صور الموظفين (متعددة)
        'latitude_coordinate',  // الإحداثي الجغرافي - خط العرض
        'longitude_coordinate', // الإحداثي الجغرافي - خط الطول
        'street_address',       // العنوان الكامل للشارع
        'description',          // وصف المتجر
        'operational_status',   // حالة المتجر التشغيلية (مفتوح، مغلق، تحت الصيانة)
        'is_active'            // هل المتجر نشط أم لا (true/false)
    ];

    /**
     * تحويل أنواع البيانات
     * The attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'store_photos_urls' => 'array',    // تحويل إلى مصفوفة - صور المتجر
            'staff_photos_urls' => 'array',    // تحويل إلى مصفوفة - صور الموظفين
            'latitude_coordinate' => 'decimal:8',  // رقم عشري بدقة 8 خانات - خط العرض
            'longitude_coordinate' => 'decimal:8', // رقم عشري بدقة 8 خانات - خط الطول
            'is_active' => 'boolean',          // قيمة منطقية (صح/خطأ)
        ];
    }

    /**
     * العلاقة مع المستخدم (صاحب المتجر)
     * Get the user that owns the store.
     */
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    /**
     * العلاقة مع فئة المتجر
     * Get the category that belongs to the store.
     */
    public function category()
    {
        return $this->belongsTo(Category::class);
    }

    /**
     * العلاقة مع منتجات المتجر
     * Get the products for the store.
     */
    public function products()
    {
        return $this->hasMany(Product::class);
    }

    /**
     * العلاقة مع طلبات المتجر
     * Get the orders for the store.
     */
    public function orders()
    {
        return $this->hasMany(Order::class);
    }
}
