<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('reviews', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('user_id');     // رقم المستخدم الذي كتب التقييم
            $table->unsignedBigInteger('product_id');  // رقم المنتج الذي تم تقييمه
            $table->tinyInteger('rating');             // التقييم من 1 إلى 5 مثلاً
            $table->text('comment')->nullable();       // تعليق المستخدم
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('reviews');
    }
};