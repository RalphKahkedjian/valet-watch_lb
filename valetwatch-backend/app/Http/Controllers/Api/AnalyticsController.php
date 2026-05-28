<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Services\AnalyticsService;

class AnalyticsController extends Controller
{
    public function __construct(
        protected AnalyticsService $analyticsService
    ) {}

    public function dashboardCharts()
    {
        return response()->json([
            'message' => 'Dashboard charts fetched successfully',
            'data' => $this->analyticsService->dashboardCharts()
        ]);
    }
}