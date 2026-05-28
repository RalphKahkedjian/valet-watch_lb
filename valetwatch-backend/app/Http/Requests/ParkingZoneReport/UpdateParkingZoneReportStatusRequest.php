<?php

namespace App\Http\Requests\ParkingZoneReport;

use Illuminate\Foundation\Http\FormRequest;

class UpdateParkingZoneReportStatusRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'status' => ['required', 'in:open,reviewing,resolved,rejected'],
        ];
    }
}