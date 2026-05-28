<?php

namespace App\Http\Requests\ParkingSession;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class UpdateParkingSessionRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'paid_price' => ['nullable', 'numeric', 'min:0'],
            'status' => [
                'required',
                Rule::in(['pending', 'active', 'completed', 'cancelled', 'disputed']),
            ],
        ];
    }
}