<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ParkingZoneReport extends Model
{
    protected $fillable = [
        'zone_id',
        'user_id',
        'report_type',
        'description',
        'status',
    ];

    public function zone()
    {
        return $this->belongsTo(ParkingZone::class, 'zone_id');
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
