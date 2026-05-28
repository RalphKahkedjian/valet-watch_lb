<?php

namespace App\Services;

use App\Repositories\AnalyticsRepository;

class AnalyticsService
{
    public function __construct(
        protected AnalyticsRepository $analyticsRepository
    ) {}

    public function dashboardCharts(): array
    {
        return [
            'reports_by_type' => $this->analyticsRepository->reportsByType(),
            'sessions_by_status' => $this->analyticsRepository->sessionsByStatus(),
        ];
    }
}