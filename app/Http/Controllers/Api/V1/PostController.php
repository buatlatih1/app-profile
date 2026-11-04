<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Resources\Api\V1\PostResource;
use App\Models\Post;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;

class PostController extends Controller
{
    /**
     * Display a listing of published posts.
     */
    public function index(Request $request): AnonymousResourceCollection
    {
        $query = Post::published()
            ->with(['category', 'user']);

        // Filter by category slug
        if ($request->filled('category')) {
            $categorySlug = $request->input('category');
            $query->whereHas('category', function ($q) use ($categorySlug) {
                $q->where('slug', $categorySlug);
            });
        }

        // Search query
        if ($request->filled('q')) {
            $search = $request->input('q');
            $query->where(function ($q) use ($search) {
                $q->where('title', 'like', "%{$search}%")
                    ->orWhere('summary', 'like', "%{$search}%")
                    ->orWhere('content', 'like', "%{$search}%");
            });
        }

        // Filter featured
        if ($request->boolean('featured')) {
            $query->featured();
        }

        $perPage = min(max((int) $request->input('per_page', 10), 1), 50);
        $posts = $query->paginate($perPage);

        return PostResource::collection($posts);
    }

    /**
     * Display the specified post by slug.
     */
    public function show(string $slug): JsonResponse
    {
        $post = Post::published()
            ->with(['category', 'user'])
            ->where('slug', $slug)
            ->firstOrFail();

        // Increment view count asynchronously / simply
        $post->increment('view_count');

        return response()->json([
            'data' => new PostResource($post),
        ]);
    }
}
