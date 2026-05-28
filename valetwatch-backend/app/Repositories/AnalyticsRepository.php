<?php

namespace App\Repositories;

use App\Models\ParkingSession;
use App\Models\ParkingZoneReport;
use Illuminate\Support\Facades\DB;

class AnalyticsRepository
{
    public function reportsByType()
    {
        return ParkingZoneReport::select(
                'report_type as name',
                DB::raw('COUNT(*) as value')
            )
            ->groupBy('report_type')
            ->get();
    }

    public function sessionsByStatus()
    {
        return ParkingSession::select(
                'status as name',
                DB::raw('COUNT(*) as value')
            )
            ->groupBy('status')
            ->get();
    }
}