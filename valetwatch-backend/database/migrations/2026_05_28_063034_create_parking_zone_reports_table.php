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
        Schema::create('parking_zone_reports', function (Blueprint $table) {
            $table->id();
            $table->foreignId('zone_id')->nullable()->constrained('parking_zones')->nullOnDelete();
            $table->foreignId('user_id')->constrained('users')->cascadeOnDelete();

            $table->enum('report_type', [
                'fake_valet',
                'overcharging',
                'public_spot_claimed',
                'unsafe_area',
                'other'
            ]);

            $table->text('description')->nullable();
            $table->enum('status', ['open', 'reviewing', 'resolved', 'rejected'])->default('open');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('parking_zone_reports');
    }
};
