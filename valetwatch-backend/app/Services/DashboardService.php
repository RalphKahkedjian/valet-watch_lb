<?php

namespace App\Services;

use App\Repositories\DashboardRepository;

class DashboardService
{
    public function __construct(
        protected DashboardRepository $dashboardRepository
    ) {}

    public function getStats(): array
    {
        return [
            'total_reports' => $this->dashboardRepository->totalReports(),
            'active_sessions' => $this->dashboardRepository->activeSessions(),
            'parking_zones' => $this->dashboardRepository->parkingZones(),
            'overcharge_cases' => $this->dashboardRepository->overchargeCases(),
        ];
    }
}