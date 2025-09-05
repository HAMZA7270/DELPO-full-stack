<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('service_providers', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            
            // Business Information
            $table->string('business_name');
            $table->foreignId('service_category_id')->nullable()->constrained('categories')->onDelete('set null');
            $table->json('skills')->nullable(); // Array of skills
            $table->integer('experience_years')->default(0);
            $table->decimal('hourly_rate', 8, 2)->nullable();
            $table->text('description')->nullable();
            
            // Portfolio & Credentials
            $table->json('portfolio_images')->nullable(); // Array of image URLs
            $table->json('certifications')->nullable(); // Array of certification details
            $table->json('availability_schedule')->nullable(); // Weekly schedule
            
            // Location & Service Area
            $table->decimal('service_radius', 8, 2)->default(10.00); // km
            $table->decimal('latitude', 10, 8)->nullable();
            $table->decimal('longitude', 11, 8)->nullable();
            $table->text('address')->nullable();
            
            // Contact Information
            $table->string('phone')->nullable();
            $table->string('email')->nullable();
            $table->string('website')->nullable();
            $table->json('social_media_links')->nullable();
            
            // Performance Metrics
            $table->decimal('rating', 3, 2)->default(0.00);
            $table->integer('total_reviews')->default(0);
            $table->integer('total_jobs_completed')->default(0);
            
            // Status & Verification
            $table->boolean('is_verified')->default(false);
            $table->boolean('is_active')->default(true);
            $table->boolean('is_available')->default(true);
            $table->json('verification_documents')->nullable();
            
            $table->timestamps();
            
            // Indexes
            $table->index('user_id');
            $table->index('service_category_id');
            $table->index(['is_verified', 'is_active']);
            $table->index(['latitude', 'longitude']);
            $table->index('rating');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('service_providers');
    }
};
