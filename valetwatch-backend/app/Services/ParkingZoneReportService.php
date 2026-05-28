<?php

namespace App\Services;

use App\Models\ParkingZoneReport;
use App\Repositories\ParkingZoneReportRepository;

class ParkingZoneReportService
{
    public function __construct(
        protected ParkingZoneReportRepository $parkingZoneReportRepository
    ) {}

    public function getAllReports()
    {
        return $this->parkingZoneReportRepository->getAll();
    }

    public function createReport(array $data): ParkingZoneReport
    {
        return $this->parkingZoneReportRepository->create($data);
    }

    public function findReport(int $reportId): ?ParkingZoneReport
    {
        return $this->parkingZoneReportRepository->find($reportId);
    }

    public function updateReport(ParkingZoneReport $report, array $data): bool
    {
        return $this->parkingZoneReportRepository->update($report, $data);
    }
}