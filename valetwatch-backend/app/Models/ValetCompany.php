<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ValetCompany extends Model
{
    protected $fillable = [
        'name',
        'owner_name',
        'phone',
        'license_number',
        'status',
    ];

    public function attendants()
    {
        return $this->hasMany(ValetAttendant::class, 'company_id');
    }

    public function parkingZones()
    {
        return $this->hasMany(ParkingZone::class, 'company_id');
    }
}
