
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * إنشاء جدول الفئات
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('categories', function (Blueprint $table) {
            $table->id();
            
            // معلومات الفئة الأساسية - Basic category information
            $table->string('name');                                    // اسم الفئة للعرض
            $table->string('slug')->unique();                          // الرابط المختصر للفئة
            $table->text('description')->nullable();                   // وصف تفصيلي للفئة
            
            // التخصيص المرئي - Visual customization
            $table->string('icon_url')->nullable();                    // رابط أيقونة الفئة
            $table->string('color_code', 7)->nullable();               // كود اللون بصيغة #FFFFFF
            
            // الترتيب والتسلسل الهرمي - Ordering and hierarchy
            $table->integer('sort_order')->default(0);                 // ترتيب العرض
            $table->foreignId('parent_id')->nullable()                 // معرف الفئة الأب (للفئات الفرعية)
                ->constrained('categories')
                ->onDelete('cascade');
            
            // الحالة - Status
            $table->boolean('is_active')->default(true);               // هل الفئة نشطة أم لا
            
            $table->timestamps();
            
            // الفهارس - Indexes
            $table->index(['is_active', 'sort_order']);                // فهرس للحالة والترتيب
            $table->index('parent_id');                                // فهرس للفئات الفرعية
            $table->index('slug');                                     // فهرس للرابط المختصر
        });
    }

    /**
     * حذف جدول الفئات
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('categories');
    }
};