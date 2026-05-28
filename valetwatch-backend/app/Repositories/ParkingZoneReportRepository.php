<?php

namespace App\Repositories;

use App\Models\ParkingZoneReport;

class ParkingZoneReportRepository
{
    public function getAll()
    {
        return ParkingZoneReport::with([
            'user',
            'zone'
        ])
        ->latest()
        ->get();
    }

    public function create(array $data): ParkingZoneReport
    {
        return ParkingZoneReport::create($data);
    }

    public function find(int $reportId): ?ParkingZoneReport
    {
        return ParkingZoneReport::with([
            'user',
            'zone'
        ])->find($reportId);
    }
}