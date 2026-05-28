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
        Schema::create('parking_sessions', function (Blueprint $table) {
            $table->id();
            $table->foreignId('customer_id')->constrained('users')->cascadeOnDelete();
            $table->foreignId('attendant_id')->nullable()->constrained('valet_attendants')->nullOnDelete();
            $table->foreignId('zone_id')->nullable()->constrained('parking_zones')->nullOnDelete();
            $table->foreignId('vehicle_id')->constrained('vehicles')->cascadeOnDelete();

            $table->dateTime('start_time')->nullable();
            $table->dateTime('end_time')->nullable();

            $table->decimal('official_price', 10, 2)->default(400000);
            $table->decimal('paid_price', 10, 2)->nullable();

            $table->enum('status', [
                'pending',
                'active',
                'completed',
                'cancelled',
                'disputed'
            ])->default('pending');
            $table->timestamps();
            });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('parking_sessions');
    }
};
