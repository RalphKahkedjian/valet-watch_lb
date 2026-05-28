<?php

namespace App\Services;

use App\Models\ParkingSession;
use App\Repositories\ParkingSessionRepository;
use Exception;

class ParkingSessionService
{
    public function __construct(
        protected ParkingSessionRepository $parkingSessionRepository
    ) {}

    public function getUserSessions(int $userId)
    {
        return $this->parkingSessionRepository
            ->getUserSessions($userId);
    }

    public function createSession(array $data): ParkingSession
    {
        $existingSession = $this->parkingSessionRepository
            ->getActiveSessionForVehicle($data['vehicle_id']);

        if ($existingSession) {
            throw new Exception('Vehicle already has an active parking session.');
        }

        return $this->parkingSessionRepository->create($data);
    }

    public function findUserSession(int $sessionId, int $userId): ?ParkingSession
    {
        return $this->parkingSessionRepository
            ->findUserSession($sessionId, $userId);
    }

    public function updateSession(ParkingSession $session, array $data): bool
    {
        return $this->parkingSessionRepository
            ->update($session, $data);
    }

    public function deleteSession(ParkingSession $session): bool
    {
        return $this->parkingSessionRepository
            ->delete($session);
    }
}