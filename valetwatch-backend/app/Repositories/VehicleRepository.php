<?php

namespace App\Repositories;

use App\Models\Vehicle;

class VehicleRepository
{
    public function getUserVehicles(int $userId)
    {
        return Vehicle::where('user_id', $userId)->latest()->get();
    }

    public function create(array $data): Vehicle
    {
        return Vehicle::create($data);
    }

    public function findUserVehicle(int $vehicleId, int $userId): ?Vehicle
    {
        return Vehicle::where('id', $vehicleId)
            ->where('user_id', $userId)
            ->first();
    }

    public function update(Vehicle $vehicle, array $data): bool
    {
        return $vehicle->update($data);
    }

    public function delete(Vehicle $vehicle): bool
    {
        return $vehicle->delete();
    }
}