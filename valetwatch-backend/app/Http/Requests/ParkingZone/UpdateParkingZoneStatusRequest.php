<?php

namespace App\Http\Requests\ParkingZone;

use Illuminate\Foundation\Http\FormRequest;

class UpdateParkingZoneStatusRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'status' => ['required', 'in:pending,approved,rejected,suspended'],
        ];
    }
}