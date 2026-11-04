<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Resources\Api\V1\FaqResource;
use App\Models\Faq;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;

class FaqController extends Controller
{
    /**
     * Display a listing of active FAQs.
     */
    public function index(Request $request): AnonymousResourceCollection
    {
        $query = Faq::active()->with('topic');

        if ($request->filled('topic')) {
            $topicSlug = $request->input('topic');
            $query->whereHas('topic', function ($q) use ($topicSlug) {
                $q->where('slug', $topicSlug);
            });
        }

        if ($request->filled('q')) {
            $search = $request->input('q');
            $query->where(function ($q) use ($search) {
                $q->where('question', 'like', "%{$search}%")
                    ->orWhere('answer', 'like', "%{$search}%");
            });
        }

        $faqs = $query->get();

        return FaqResource::collection($faqs);
    }
}
