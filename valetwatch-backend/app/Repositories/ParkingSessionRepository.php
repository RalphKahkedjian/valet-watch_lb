<?php

namespace App\Repositories;

use App\Models\ParkingSession;

class ParkingSessionRepository
{
    public function getUserSessions(int $userId)
    {
        return ParkingSession::with([
            'vehicle',
            'zone',
            'attendant.user'
        ])
        ->where('customer_id', $userId)
        ->latest()
        ->get();
    }

    public function create(array $data): ParkingSession
    {
        return ParkingSession::create($data);
    }

    public function findUserSession(int $sessionId, int $userId): ?ParkingSession
    {
        return ParkingSession::with([
            'vehicle',
            'zone',
            'attendant.user',
            'payments',
            'complaints',
            'carScans'
        ])
        ->where('id', $sessionId)
        ->where('customer_id', $userId)
        ->first();
    }

    public function update(ParkingSession $session, array $data): bool
    {
        return $session->update($data);
    }

    public function delete(ParkingSession $session): bool
    {
        return $session->delete();
    }

    public function getActiveSessionForVehicle(int $vehicleId): ?ParkingSession
    {
        return ParkingSession::where('vehicle_id', $vehicleId)
            ->whereIn('status', ['pending', 'active'])
            ->first();
    }
}