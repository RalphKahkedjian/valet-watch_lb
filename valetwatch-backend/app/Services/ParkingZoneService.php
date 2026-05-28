<?php

namespace App\Services;

use App\Models\ParkingZone;
use App\Repositories\ParkingZoneRepository;

class ParkingZoneService
{
    public function __construct(
        protected ParkingZoneRepository $parkingZoneRepository
    ) {}

    public function getAllZones()
    {
        return $this->parkingZoneRepository->getAll();
    }

    public function createZone(array $data): ParkingZone
    {
        return $this->parkingZoneRepository->create($data);
    }

    public function findZone(int $zoneId): ?ParkingZone
    {
        return $this->parkingZoneRepository->find($zoneId);
    }

    public function updateZone(ParkingZone $zone, array $data): bool
    {
        return $this->parkingZoneRepository
            ->update($zone, $data);
    }

    public function deleteZone(ParkingZone $zone): bool
    {
        return $this->parkingZoneRepository
            ->delete($zone);
    }
}