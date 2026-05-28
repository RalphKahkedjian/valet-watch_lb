<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\ParkingSessionController;
use App\Http\Controllers\Api\ParkingZoneController;
use App\Http\Controllers\Api\VehicleController;

Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);



Route::middleware('auth:sanctum')->group(function () {

    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/me', [AuthController::class, 'me']);

        // Vehicles
    Route::apiResource('vehicles', VehicleController::class);
    
    Route::apiResource('parking-sessions', ParkingSessionController::class);

    Route::apiResource('parking-zones', ParkingZoneController::class);
});