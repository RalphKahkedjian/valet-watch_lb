<?php

namespace App\Services;

use App\Models\Vehicle;
use App\Repositories\VehicleRepository;

class VehicleService
{
    public function __construct(
        protected VehicleRepository $vehicleRepository
    ) {}

    public function getUserVehicles(int $userId)
    {
        return $this->vehicleRepository->getUserVehicles($userId);
    }

    public function createVehicle(array $data): Vehicle
    {
        return $this->vehicleRepository->create($data);
    }

    public function findUserVehicle(int $vehicleId, int $userId): ?Vehicle
    {
        return $this->vehicleRepository->findUserVehicle($vehicleId, $userId);
    }

    public function updateVehicle(Vehicle $vehicle, array $data): bool
    {
        return $this->vehicleRepository->update($vehicle, $data);
    }

    public function deleteVehicle(Vehicle $vehicle): bool
    {
        return $this->vehicleRepository->delete($vehicle);
    }
}