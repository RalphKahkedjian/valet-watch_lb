<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ParkingZone extends Model
{
    protected $fillable = [
        'company_id',
        'name',
        'latitude',
        'longitude',
        'radius',
        'official_price',
        'is_public',
        'status',
    ];

    public function company()
    {
        return $this->belongsTo(ValetCompany::class, 'company_id');
    }

    public function parkingSessions()
    {
        return $this->hasMany(ParkingSession::class, 'zone_id');
    }

    public function reports()
    {
        return $this->hasMany(ParkingZoneReport::class, 'zone_id');
    }
}
