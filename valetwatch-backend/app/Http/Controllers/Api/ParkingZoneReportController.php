<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\ParkingZoneReport\StoreParkingZoneReportRequest;
use App\Http\Requests\ParkingZoneReport\UpdateParkingZoneReportStatusRequest;
use App\Services\ParkingZoneReportService;
use Symfony\Component\HttpFoundation\StreamedResponse;

class ParkingZoneReportController extends Controller
{
    public function __construct(
        protected ParkingZoneReportService $parkingZoneReportService
    ) {}

    public function index()
    {
        $reports = $this->parkingZoneReportService->getAllReports();

        return response()->json([
            'message' => 'Parking zone reports fetched successfully',
            'data' => $reports
        ]);
    }

    public function store(StoreParkingZoneReportRequest $request)
    {
        $report = $this->parkingZoneReportService->createReport([
            'zone_id' => $request->zone_id,
            'user_id' => $request->user()->id,
            'report_type' => $request->report_type,
            'description' => $request->description,
            'status' => 'open',
        ]);

        return response()->json([
            'message' => 'Parking zone report created successfully',
            'data' => $report
        ], 201);
    }

    public function show(int $parkingZoneReport)
    {
        $report = $this->parkingZoneReportService->findReport($parkingZoneReport);

        if (! $report) {
            return response()->json([
                'message' => 'Parking zone report not found'
            ], 404);
        }

        return response()->json([
            'message' => 'Parking zone report fetched successfully',
            'data' => $report
        ]);
    }

    public function updateStatus(
        UpdateParkingZoneReportStatusRequest $request,
        int $parkingZoneReport
    ) {
        $report = $this->parkingZoneReportService->findReport($parkingZoneReport);

        if (! $report) {
            return response()->json([
                'message' => 'Parking zone report not found'
            ], 404);
        }

        $this->parkingZoneReportService->updateReport($report, [
            'status' => $request->status,
        ]);

        return response()->json([
            'message' => 'Report status updated successfully',
            'data' => $report->fresh()
        ]);
    }

    public function exportCsv(): StreamedResponse
{
    $fileName = 'parking-zone-reports.csv';

    $headers = [
        'Content-Type' => 'text/csv',
        'Content-Disposition' => "attachment; filename=\"$fileName\"",
    ];

    $callback = function () {
        $file = fopen('php://output', 'w');

        fputcsv($file, [
            'ID',
            'Type',
            'Status',
            'Zone',
            'User',
            'Email',
            'Description',
            'Created At',
        ]);

        $reports = $this->parkingZoneReportService->getAllReports();

        foreach ($reports as $report) {
            fputcsv($file, [
                $report->id,
                $report->report_type,
                $report->status,
                $report->zone?->name ?? 'No zone',
                $report->user?->name ?? 'Unknown',
                $report->user?->email ?? '-',
                $report->description ?? '',
                $report->created_at,
            ]);
        }

        fclose($file);
    };

    return response()->stream($callback, 200, $headers);
}
}