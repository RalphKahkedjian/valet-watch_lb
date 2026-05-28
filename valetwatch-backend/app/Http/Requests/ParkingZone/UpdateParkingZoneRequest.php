<?php

namespace App\Http\Requests\ParkingZone;

use Illuminate\Foundation\Http\FormRequest;

class UpdateParkingZoneRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'company_id' => ['nullable', 'exists:valet_companies,id'],
            'name' => ['required', 'string', 'max:255'],
            'latitude' => ['required', 'numeric'],
            'longitude' => ['required', 'numeric'],
            'radius' => ['nullable', 'integer', 'min:1'],
            'official_price' => ['nullable', 'numeric', 'min:0'],
            'is_public' => ['nullable', 'boolean'],
            'status' => ['nullable', 'in:pending,approved,rejected,suspended'],
        ];
    }
}