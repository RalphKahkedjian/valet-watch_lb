<?php

namespace App\Http\Requests\ParkingZoneReport;

use Illuminate\Foundation\Http\FormRequest;

class StoreParkingZoneReportRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'zone_id' => ['nullable', 'exists:parking_zones,id'],
            'latitude' => ['nullable', 'numeric'],
            'longitude' => ['nullable', 'numeric'],
            'image' => ['nullable', 'image', 'mimes:jpg,jpeg,png', 'max:5120'],
            'report_type' => [
                'required',
                'in:fake_valet,overcharging,public_spot_claimed,unsafe_area,other'
            ],
            'description' => ['nullable', 'string', 'max:2000'],
        ];
    }
}