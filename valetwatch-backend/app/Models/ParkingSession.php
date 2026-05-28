<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ParkingSession extends Model
{
    protected $fillable = [
        'customer_id',
        'attendant_id',
        'zone_id',
        'vehicle_id',
        'start_time',
        'end_time',
        'official_price',
        'paid_price',
        'status',
    ];

    public function customer()
    {
        return $this->belongsTo(User::class, 'customer_id');
    }

    public function attendant()
    {
        return $this->belongsTo(ValetAttendant::class, 'attendant_id');
    }

    public function zone()
    {
        return $this->belongsTo(ParkingZone::class, 'zone_id');
    }

    public function vehicle()
    {
        return $this->belongsTo(Vehicle::class);
    }

    public function carScans()
    {
        return $this->hasMany(CarScan::class, 'session_id');
    }

    public function complaints()
    {
        return $this->hasMany(Complaint::class, 'session_id');
    }

    public function payments()
    {
        return $this->hasMany(Payment::class, 'session_id');
    }
}
