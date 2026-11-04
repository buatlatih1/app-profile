<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Resources\Api\V1\CategoryResource;
use App\Models\Category;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;

class CategoryController extends Controller
{
    /**
     * Display a listing of active categories.
     */
    public function index(): AnonymousResourceCollection
    {
        $categories = Category::active()
            ->withCount(['posts' => fn ($q) => $q->published()])
            ->get();

        return CategoryResource::collection($categories);
    }

    /**
     * Display the specified category by slug.
     */
    public function show(string $slug): JsonResponse
    {
        $category = Category::active()
            ->withCount(['posts' => fn ($q) => $q->published()])
            ->where('slug', $slug)
            ->firstOrFail();

        return response()->json([
            'data' => new CategoryResource($category),
        ]);
    }
}
