<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Models\Setting;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class SettingController extends Controller
{
    /**
     * Display all public settings grouped or filtered.
     */
    public function index(Request $request): JsonResponse
    {
        if ($request->filled('group')) {
            $settings = Setting::where('group', $request->input('group'))
                ->pluck('value', 'key');

            return response()->json([
                'data' => $settings,
            ]);
        }

        return response()->json([
            'data' => Setting::getGrouped(),
        ]);
    }
}
