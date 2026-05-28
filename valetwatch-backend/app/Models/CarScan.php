<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class CarScan extends Model
{
    protected $fillable = [
        'session_id',
        'image_path',
        'scan_type',
        'ai_damage_result',
    ];

    protected $casts = [
        'ai_damage_result' => 'array',
    ];

    public function session()
    {
        return $this->belongsTo(ParkingSession::class, 'session_id');
    }
}
