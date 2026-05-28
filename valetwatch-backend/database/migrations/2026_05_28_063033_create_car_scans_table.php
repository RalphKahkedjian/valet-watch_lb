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
        Schema::create('car_scans', function (Blueprint $table) {
            $table->id();
            $table->foreignId('session_id')->constrained('parking_sessions')->cascadeOnDelete();
            $table->string('image_path');
            $table->enum('scan_type', ['before', 'after']);
            $table->json('ai_damage_result')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('car_scans');
    }
};
