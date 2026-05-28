<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\ParkingSession\StoreParkingSessionRequest;
use App\Http\Requests\ParkingSession\UpdateParkingSessionRequest;
use App\Services\ParkingSessionService;
use Illuminate\Http\Request;
use Exception;

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
        try {

            $session = $this->parkingSessionService->createSession([
                'customer_id' => $request->user()->id,
                'vehicle_id' => $request->vehicle_id,
                'attendant_id' => $request->attendant_id,
                'zone_id' => $request->zone_id,
                'official_price' => $request->official_price ?? 400000,
                'start_time' => now(),
                'status' => 'active',
            ]);

            return response()->json([
                'message' => 'Parking session created successfully',
                'data' => $session
            ], 201);

        } catch (Exception $e) {

            return response()->json([
                'message' => $e->getMessage()
            ], 422);

        }
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