<?php

namespace App\Repositories;

use App\Models\ParkingZone;

class ParkingZoneRepository
{
    public function getAll()
    {
        return ParkingZone::latest()->get();
    }

    public function create(array $data): ParkingZone
    {
        return ParkingZone::create($data);
    }

    public function find(int $zoneId): ?ParkingZone
    {
        return ParkingZone::find($zoneId);
    }

    public function update(ParkingZone $zone, array $data): bool
    {
        return $zone->update($data);
    }

    public function delete(ParkingZone $zone): bool
    {
        return $zone->delete();
    }
}