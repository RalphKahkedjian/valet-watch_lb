<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\CarScanController;
use App\Http\Controllers\Api\DashboardController;
use App\Http\Controllers\Api\ParkingSessionController;
use App\Http\Controllers\Api\ParkingZoneController;
use App\Http\Controllers\Api\ParkingZoneReportController;
use App\Http\Controllers\Api\VehicleController;

Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);



Route::middleware('auth:sanctum')->group(function () {

    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/me', [AuthController::class, 'me']);

    Route::get('/admin-test', function () {
        return response()->json([
            'message' => 'Welcome admin'
        ]);
    })->middleware('role:admin');

    Route::apiResource('vehicles', VehicleController::class);
    Route::apiResource('parking-sessions', ParkingSessionController::class);
    Route::apiResource('parking-zones', ParkingZoneController::class);

    Route::apiResource('parking-zone-reports', ParkingZoneReportController::class)
        ->only(['index', 'store', 'show']);

    Route::post('/car-scans', [CarScanController::class, 'store']);
    Route::get('/car-scans/{carScan}', [CarScanController::class, 'show']);
    Route::get('/parking-sessions/{sessionId}/car-scans', [CarScanController::class, 'index']);
    Route::get('/dashboard/stats', [DashboardController::class, 'stats'])
    ->middleware('role:admin,government_admin,valet_company');
});