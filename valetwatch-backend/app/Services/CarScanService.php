<?php

namespace App\Services;

use App\Models\CarScan;
use App\Repositories\CarScanRepository;

class CarScanService
{
    public function __construct(
        protected CarScanRepository $carScanRepository
    ) {}

    public function getSessionScans(int $sessionId)
    {
        return $this->carScanRepository
            ->getSessionScans($sessionId);
    }

    public function createScan(array $data): CarScan
    {
        return $this->carScanRepository
            ->create($data);
    }

    public function findScan(int $scanId): ?CarScan
    {
        return $this->carScanRepository
            ->find($scanId);
    }
}