<?php

namespace App\Repositories;

use App\Models\ParkingSession;
use App\Models\ParkingZone;
use App\Models\ParkingZoneReport;

class DashboardRepository
{
    public function totalReports(): int
    {
        return ParkingZoneReport::count();
    }

    public function activeSessions(): int
    {
        return ParkingSession::where('status', 'active')->count();
    }

    public function parkingZones(): int
    {
        return ParkingZone::count();
    }

    public function overchargeCases(): int
    {
        return ParkingZoneReport::where(
            'report_type',
            'overcharging'
        )->count();
    }
}