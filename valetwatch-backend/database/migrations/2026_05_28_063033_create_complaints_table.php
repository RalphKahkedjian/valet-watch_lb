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
        Schema::create('complaints', function (Blueprint $table) {
            $table->id();
            $table->foreignId('session_id')->nullable()->constrained('parking_sessions')->nullOnDelete();
            $table->foreignId('user_id')->constrained('users')->cascadeOnDelete();

            $table->enum('type', [
                'overcharge',
                'theft',
                'fake_valet',
                'damage',
                'rude_behavior',
                'other'
            ]);

            $table->text('description')->nullable();
            $table->enum('severity', ['low', 'medium', 'high'])->default('medium');
            $table->enum('status', ['open', 'reviewing', 'resolved', 'rejected'])->default('open');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('complaints');
    }
};
