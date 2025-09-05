<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * إنشاء جدول المتاجر
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('stores', function (Blueprint $table) {
            $table->id();
            
            // معلومات المتجر الأساسية - Basic store information
            $table->string('name');                                    // اسم المتجر
            $table->foreignId('user_id')->constrained()->onDelete('cascade'); // معرف صاحب المتجر
            $table->string('area_name');                               // اسم المنطقة أو الحي
            $table->string('phone_number');                            // رقم الهاتف
            $table->string('email_address');                           // البريد الإلكتروني
            $table->foreignId('category_id')->constrained()->onDelete('restrict'); // معرف فئة المتجر
            
            // الصور والوسائط - Images and media
            $table->string('logo_image_url')->nullable();              // رابط صورة الشعار
            $table->string('background_image_url')->nullable();        // رابط الصورة الخلفية للمتجر
            $table->json('store_photos_urls')->nullable();             // روابط صور المتجر (متعددة)
            $table->json('staff_photos_urls')->nullable();             // روابط صور الموظفين (متعددة)
            
            // الموقع الجغرافي - Geographic location
            $table->decimal('latitude_coordinate', 10, 8)->nullable(); // الإحداثي الجغرافي - خط العرض
            $table->decimal('longitude_coordinate', 11, 8)->nullable(); // الإحداثي الجغرافي - خط الطول
            $table->text('street_address')->nullable();                // العنوان الكامل للشارع
            
            // معلومات إضافية - Additional information
            $table->text('description')->nullable();                   // وصف المتجر
            $table->enum('operational_status', [                       // حالة المتجر التشغيلية
                'open',         // مفتوح
                'closed',       // مغلق
                'maintenance'   // تحت الصيانة
            ])->default('open');
            $table->boolean('is_active')->default(true);               // هل المتجر نشط أم لا
            
            $table->timestamps();
            
            // الفهارس - Indexes
            $table->index(['is_active', 'operational_status']);        // فهرس للحالة والنشاط
            $table->index(['category_id', 'is_active']);               // فهرس للفئة والنشاط
            $table->index(['latitude_coordinate', 'longitude_coordinate']); // فهرس للموقع الجغرافي
            $table->index('area_name');                                // فهرس للمنطقة
        });
    }

    /**
     * حذف جدول المتاجر
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('stores');
    }
};