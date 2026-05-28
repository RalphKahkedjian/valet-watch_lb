<?php

namespace App\Http\Requests\CarScan;

use Illuminate\Foundation\Http\FormRequest;

class StoreCarScanRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'session_id' => ['required', 'exists:parking_sessions,id'],
            'image' => ['required', 'image', 'mimes:jpg,jpeg,png', 'max:5120'],
            'scan_type' => ['required', 'in:before,after'],
        ];
    }
}