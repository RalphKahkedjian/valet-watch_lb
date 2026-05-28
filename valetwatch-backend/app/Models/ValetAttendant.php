<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ValetAttendant extends Model
{
    protected $fillable = [
        'user_id',
        'company_id',
        'national_id',
        'qr_code',
        'status',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function company()
    {
        return $this->belongsTo(ValetCompany::class, 'company_id');
    }

    public function parkingSessions()
    {
        return $this->hasMany(ParkingSession::class, 'attendant_id');
    }
}
