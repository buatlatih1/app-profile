<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Resources\Api\V1\MenuResource;
use App\Models\Menu;
use Illuminate\Http\JsonResponse;

class MenuController extends Controller
{
    /**
     * Display the specified menu by location (header, footer, sidebar).
     */
    public function show(string $location): JsonResponse
    {
        $menu = Menu::active()
            ->with(['rootItems.children' => fn ($q) => $q->where('is_active', true)])
            ->where('location', $location)
            ->firstOrFail();

        return response()->json([
            'data' => new MenuResource($menu),
        ]);
    }
}
