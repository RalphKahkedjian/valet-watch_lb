<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Vehicle extends Model
{
    protected $fillable = [
        'user_id',
        'plate_number',
        'brand',
        'model',
        'color',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function parkingSessions()
    {
        return $this->hasMany(ParkingSession::class);
    }
}
