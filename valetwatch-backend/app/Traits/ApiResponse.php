<?php

namespace App\Traits;

trait ApiResponse
{
    protected function successResponse(
        string $message,
        mixed $data = null,
        int $statusCode = 200
    ) {
        return response()->json([
            'success' => true,
            'message' => $message,
            'data' => $data,
        ], $statusCode);
    }

    protected function errorResponse(
        string $message,
        int $statusCode = 400,
        mixed $errors = null
    ) {
        return response()->json([
            'success' => false,
            'message' => $message,
            'errors' => $errors,
        ], $statusCode);
    }
}