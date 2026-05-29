<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\ParkingSession\StoreParkingSessionRequest;
use App\Http\Requests\ParkingSession\UpdateParkingSessionRequest;
use App\Services\ParkingSessionService;
use Illuminate\Http\Request;
use Exception;
use App\Models\ParkingZone;

class ParkingSessionController extends Controller
{
    public function __construct(
        protected ParkingSessionService $parkingSessionService
    ) {}

    // List user parking sessions
    public function index(Request $request)
    {
        $sessions = $this->parkingSessionService
            ->getUserSessions($request->user()->id);

        return response()->json([
            'message' => 'Parking sessions fetched successfully',
            'data' => $sessions
        ]);
    }

    // Create parking session
   public function store(StoreParkingSessionRequest $request)
{
    $latitude = $request->latitude;
    $longitude = $request->longitude;

    $nearestZone = ParkingZone::query()
        ->selectRaw("
            *,
            (
                6371000 * acos(
                    cos(radians(?)) *
                    cos(radians(latitude)) *
                    cos(radians(longitude) - radians(?)) +
                    sin(radians(?)) *
                    sin(radians(latitude))
                )
            ) AS distance
        ", [
            $latitude,
            $longitude,
            $latitude,
        ])
        ->orderBy('distance')
        ->first();

    // Suspended/rejected nearby
    if (
        $nearestZone &&
        in_array($nearestZone->status, [
            'suspended',
            'rejected',
        ]) &&
        $nearestZone->distance <= $nearestZone->radius
    ) {
        return response()->json([
            'message' =>
                'This valet zone is suspended or unsafe',
        ], 403);
    }

    $zoneId = null;
    $status = 'unverified';
    $officialPrice = null;

    // Approved nearby
    if (
        $nearestZone &&
        $nearestZone->status === 'approved' &&
        $nearestZone->distance <= $nearestZone->radius
    ) {
        $zoneId = $nearestZone->id;
        $status = 'active';
        $officialPrice =
            $nearestZone->official_price;
    }

    $session =
        $this->parkingSessionService->createSession([
            'customer_id' => $request->user()->id,
            'vehicle_id' => $request->vehicle_id,
            'zone_id' => $zoneId,
            'latitude' => $latitude,
            'longitude' => $longitude,
            'official_price' => $officialPrice,
            'status' => $status,
            'start_time' => now(),
        ]);

    return response()->json([
        'message' =>
            $status === 'active'
                ? 'Verified parking session started'
                : 'Unverified parking session started',
        'data' => $session,
    ], 201);
}

    // Show single parking session
    public function show(Request $request, int $parkingSession)
    {
        $session = $this->parkingSessionService
            ->findUserSession($parkingSession, $request->user()->id);

        if (! $session) {
            return response()->json([
                'message' => 'Parking session not found'
            ], 404);
        }

        return response()->json([
            'message' => 'Parking session fetched successfully',
            'data' => $session
        ]);
    }

    // Update parking session
    public function update(UpdateParkingSessionRequest $request, int $parkingSession)
    {
        $session = $this->parkingSessionService
            ->findUserSession($parkingSession, $request->user()->id);

        if (! $session) {
            return response()->json([
                'message' => 'Parking session not found'
            ], 404);
        }

        $updateData = [
            'paid_price' => $request->paid_price,
            'status' => $request->status,
        ];

        if ($request->status === 'completed') {
            $updateData['end_time'] = now();
        }

        $this->parkingSessionService
            ->updateSession($session, $updateData);

        return response()->json([
            'message' => 'Parking session updated successfully',
            'data' => $session->fresh()
        ]);
    }

    // Delete parking session
    public function destroy(Request $request, int $parkingSession)
    {
        $session = $this->parkingSessionService
            ->findUserSession($parkingSession, $request->user()->id);

        if (! $session) {
            return response()->json([
                'message' => 'Parking session not found'
            ], 404);
        }

        $this->parkingSessionService
            ->deleteSession($session);

        return response()->json([
            'message' => 'Parking session deleted successfully'
        ]);
    }

    public function complete(int $parkingSession)
{
    $session = $this->parkingSessionService
        ->findSession($parkingSession);

    if (! $session) {
        return response()->json([
            'message' => 'Parking session not found',
        ], 404);
    }

    $this->parkingSessionService->updateSession(
        $session,
        [
            'status' => 'completed',
            'end_time' => now(),
        ]
    );

    return response()->json([
        'message' => 'Parking session completed successfully',
        'data' => $session->fresh(),
    ]);
}
}