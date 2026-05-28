<?php

namespace App\Http\Requests\ParkingSession;

use Illuminate\Foundation\Http\FormRequest;

class StoreParkingSessionRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'vehicle_id' => ['required', 'exists:vehicles,id'],
            'attendant_id' => ['nullable', 'exists:valet_attendants,id'],
            'zone_id' => ['nullable', 'exists:parking_zones,id'],
            'official_price' => ['nullable', 'numeric', 'min:0'],
        ];
    }
}