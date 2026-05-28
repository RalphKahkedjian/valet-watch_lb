<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\Vehicle\StoreVehicleRequest;
use App\Http\Requests\Vehicle\UpdateVehicleRequest;
use App\Services\VehicleService;
use Illuminate\Http\Request;

class VehicleController extends Controller
{
    public function __construct(
        protected VehicleService $vehicleService
    ) {}

    // List user vehicles
    public function index(Request $request)
    {
        $vehicles = $this->vehicleService
            ->getUserVehicles($request->user()->id);

        return response()->json([
            'message' => 'Vehicles fetched successfully',
            'data' => $vehicles
        ]);
    }

    // Store vehicle
    public function store(StoreVehicleRequest $request)
    {
        $vehicle = $this->vehicleService->createVehicle([
            'user_id' => $request->user()->id,
            'plate_number' => $request->plate_number,
            'brand' => $request->brand,
            'model' => $request->model,
            'color' => $request->color,
        ]);

        return response()->json([
            'message' => 'Vehicle created successfully',
            'data' => $vehicle
        ], 201);
    }

    // Show single vehicle
    public function show(Request $request, int $vehicle)
    {
        $vehicle = $this->vehicleService
            ->findUserVehicle($vehicle, $request->user()->id);

        if (! $vehicle) {
            return response()->json([
                'message' => 'Vehicle not found'
            ], 404);
        }

        return response()->json([
            'message' => 'Vehicle fetched successfully',
            'data' => $vehicle
        ]);
    }

    // Update vehicle
    public function update(UpdateVehicleRequest $request, int $vehicle)
    {
        $vehicleModel = $this->vehicleService
            ->findUserVehicle($vehicle, $request->user()->id);

        if (! $vehicleModel) {
            return response()->json([
                'message' => 'Vehicle not found'
            ], 404);
        }

        $this->vehicleService->updateVehicle($vehicleModel, [
            'plate_number' => $request->plate_number,
            'brand' => $request->brand,
            'model' => $request->model,
            'color' => $request->color,
        ]);

        return response()->json([
            'message' => 'Vehicle updated successfully',
            'data' => $vehicleModel->fresh()
        ]);
    }

    // Delete vehicle
    public function destroy(Request $request, int $vehicle)
    {
        $vehicleModel = $this->vehicleService
            ->findUserVehicle($vehicle, $request->user()->id);

        if (! $vehicleModel) {
            return response()->json([
                'message' => 'Vehicle not found'
            ], 404);
        }

        $this->vehicleService->deleteVehicle($vehicleModel);

        return response()->json([
            'message' => 'Vehicle deleted successfully'
        ]);
    }
}