<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Payment extends Model
{
    protected $fillable = [
        'session_id',
        'user_id',
        'amount',
        'method',
        'status',
    ];

    public function session()
    {
        return $this->belongsTo(ParkingSession::class, 'session_id');
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
