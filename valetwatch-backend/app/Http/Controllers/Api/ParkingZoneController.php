<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\ParkingZone\StoreParkingZoneRequest;
use App\Http\Requests\ParkingZone\UpdateParkingZoneRequest;
use App\Http\Requests\ParkingZone\UpdateParkingZoneStatusRequest;
use App\Services\ParkingZoneService;

class ParkingZoneController extends Controller
{
    public function __construct(
        protected ParkingZoneService $parkingZoneService
    ) {}

    public function index()
    {
        return response()->json([
            'message' => 'Parking zones fetched successfully',
            'data' => $this->parkingZoneService->getAllZones()
        ]);
    }

    public function store(StoreParkingZoneRequest $request)
    {
        $zone = $this->parkingZoneService->createZone([
            'company_id' => $request->company_id,
            'name' => $request->name,
            'latitude' => $request->latitude,
            'longitude' => $request->longitude,
            'radius' => $request->radius ?? 50,
            'official_price' => $request->official_price ?? 400000,
            'is_public' => $request->is_public ?? false,
            'status' => $request->status ?? 'pending',
        ]);

        return response()->json([
            'message' => 'Parking zone created successfully',
            'data' => $zone
        ], 201);
    }

    public function show(int $parkingZone)
    {
        $zone = $this->parkingZoneService->findZone($parkingZone);

        if (! $zone) {
            return response()->json([
                'message' => 'Parking zone not found'
            ], 404);
        }

        return response()->json([
            'message' => 'Parking zone fetched successfully',
            'data' => $zone
        ]);
    }

    public function update(UpdateParkingZoneRequest $request, int $parkingZone)
    {
        $zone = $this->parkingZoneService->findZone($parkingZone);

        if (! $zone) {
            return response()->json([
                'message' => 'Parking zone not found'
            ], 404);
        }

        $this->parkingZoneService->updateZone($zone, [
            'company_id' => $request->company_id,
            'name' => $request->name,
            'latitude' => $request->latitude,
            'longitude' => $request->longitude,
            'radius' => $request->radius ?? $zone->radius,
            'official_price' => $request->official_price ?? $zone->official_price,
            'is_public' => $request->is_public ?? $zone->is_public,
            'status' => $request->status ?? $zone->status,
        ]);

        return response()->json([
            'message' => 'Parking zone updated successfully',
            'data' => $zone->fresh()
        ]);
    }

    public function destroy(int $parkingZone)
    {
        $zone = $this->parkingZoneService->findZone($parkingZone);

        if (! $zone) {
            return response()->json([
                'message' => 'Parking zone not found'
            ], 404);
        }

        $this->parkingZoneService->deleteZone($zone);

        return response()->json([
            'message' => 'Parking zone deleted successfully'
        ]);
    }

    public function updateStatus(
    UpdateParkingZoneStatusRequest $request,
    int $parkingZone
) {
    $zone = $this->parkingZoneService->findZone($parkingZone);

    if (! $zone) {
        return response()->json([
            'message' => 'Parking zone not found'
        ], 404);
    }

    $this->parkingZoneService->updateZone($zone, [
        'status' => $request->status,
    ]);

    return response()->json([
        'message' => 'Parking zone status updated successfully',
        'data' => $zone->fresh()
    ]);
}
}