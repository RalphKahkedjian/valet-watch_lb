<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\Valet\VerifyQrRequest;
use App\Models\ParkingZone;
use App\Models\ValetAttendant;

class ValetVerificationController extends Controller
{
    public function verifyQr(VerifyQrRequest $request)
    {
        $attendant = ValetAttendant::with('user')->find($request->attendant_id);
        $zone = ParkingZone::find($request->zone_id);

        if (! $attendant || ! $zone) {
            return response()->json([
                'verified' => false,
                'message' => 'Invalid valet QR code',
            ], 404);
        }

        if ($zone->status !== 'approved') {
            return response()->json([
                'verified' => false,
                'message' => 'This valet zone is not approved',
                'zone' => $zone,
            ], 403);
        }

        return response()->json([
            'verified' => true,
            'message' => 'Valet verified successfully',
            'attendant' => $attendant,
            'zone' => $zone,
        ]);
    }
}