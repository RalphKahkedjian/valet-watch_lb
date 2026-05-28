<?php

namespace App\Http\Requests\Valet;

use Illuminate\Foundation\Http\FormRequest;

class VerifyQrRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'attendant_id' => ['required', 'exists:valet_attendants,id'],
            'zone_id' => ['required', 'exists:parking_zones,id'],
        ];
    }
}