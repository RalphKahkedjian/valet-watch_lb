<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\CarScan\StoreCarScanRequest;
use App\Services\CarScanService;

class CarScanController extends Controller
{
    public function __construct(
        protected CarScanService $carScanService
    ) {}

    public function index(int $sessionId)
    {
        $scans = $this->carScanService->getSessionScans($sessionId);

        return response()->json([
            'message' => 'Car scans fetched successfully',
            'data' => $scans
        ]);
    }

    public function store(StoreCarScanRequest $request)
    {
        $path = $request->file('image')->store('car-scans', 'public');

        $scan = $this->carScanService->createScan([
            'session_id' => $request->session_id,
            'image_path' => $path,
            'scan_type' => $request->scan_type,
            'ai_damage_result' => null,
        ]);

        return response()->json([
            'message' => 'Car scan uploaded successfully',
            'data' => $scan
        ], 201);
    }

    public function show(int $carScan)
    {
        $scan = $this->carScanService->findScan($carScan);

        if (! $scan) {
            return response()->json([
                'message' => 'Car scan not found'
            ], 404);
        }

        return response()->json([
            'message' => 'Car scan fetched successfully',
            'data' => $scan
        ]);
    }
}