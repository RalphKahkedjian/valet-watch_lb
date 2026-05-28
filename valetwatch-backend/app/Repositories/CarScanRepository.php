<?php

namespace App\Repositories;

use App\Models\CarScan;

class CarScanRepository
{
    public function getSessionScans(int $sessionId)
    {
        return CarScan::where('session_id', $sessionId)
            ->latest()
            ->get();
    }

    public function create(array $data): CarScan
    {
        return CarScan::create($data);
    }

    public function find(int $scanId): ?CarScan
    {
        return CarScan::find($scanId);
    }
}