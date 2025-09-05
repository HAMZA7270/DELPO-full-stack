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
        Schema::create('deliveries', function (Blueprint $table) {
            $table->id();
            $table->foreignId('order_id')->constrained('orders')->onDelete('cascade');
            $table->json('delivery_address');
            $table->enum('delivery_method', ['standard', 'express', 'same_day', 'pickup'])->default('standard');
            $table->string('tracking_number')->nullable();
            $table->enum('delivery_status', ['pending', 'assigned', 'in_transit', 'out_for_delivery', 'delivered', 'failed', 'returned'])->default('pending');
            $table->timestamp('estimated_delivery_date')->nullable();
            $table->timestamp('actual_delivery_date')->nullable();
            $table->text('delivery_notes')->nullable();
            $table->string('driver_name')->nullable();
            $table->string('driver_phone')->nullable();
            $table->timestamps();
            
            $table->index(['order_id']);
            $table->index(['delivery_status']);
            $table->index(['tracking_number']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('deliveries');
    }
};
