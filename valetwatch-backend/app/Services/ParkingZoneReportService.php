<?php

namespace App\Services;

use App\Models\ParkingZone;
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
        if (empty($data['zone_id'])) {
            $data['zone_id'] = $this->findNearestZone(
                $data['latitude'] ?? null,
                $data['longitude'] ?? null
            );
        }

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

    private function findNearestZone(?float $latitude, ?float $longitude): ?int
    {
        if (! $latitude || ! $longitude) {
            return null;
        }

        $zones = ParkingZone::all();

        foreach ($zones as $zone) {
            $distance = $this->calculateDistance(
                $latitude,
                $longitude,
                (float) $zone->latitude,
                (float) $zone->longitude
            );

            if ($distance <= $zone->radius) {
                return $zone->id;
            }
        }

        return null;
    }

    private function calculateDistance(
        float $lat1,
        float $lon1,
        float $lat2,
        float $lon2
    ): float {
        $earthRadius = 6371000;

        $dLat = deg2rad($lat2 - $lat1);
        $dLon = deg2rad($lon2 - $lon1);

        $a =
            sin($dLat / 2) * sin($dLat / 2) +
            cos(deg2rad($lat1)) *
            cos(deg2rad($lat2)) *
            sin($dLon / 2) *
            sin($dLon / 2);

        $c = 2 * atan2(sqrt($a), sqrt(1 - $a));

        return $earthRadius * $c;
    }
}