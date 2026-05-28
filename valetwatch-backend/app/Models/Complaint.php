<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Complaint extends Model
{
    protected $fillable = [
        'session_id',
        'user_id',
        'type',
        'description',
        'severity',
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
