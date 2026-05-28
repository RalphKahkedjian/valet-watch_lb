<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Services\DashboardService;

class DashboardController extends Controller
{
    public function __construct(
        protected DashboardService $dashboardService
    ) {}

    public function stats()
    {
        return response()->json([
            'message' => 'Dashboard stats fetched successfully',
            'data' => $this->dashboardService->getStats()
        ]);
    }
}