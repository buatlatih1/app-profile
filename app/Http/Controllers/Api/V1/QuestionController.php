<?php

namespace App\Http\Controllers\Api\V1;

use App\Enums\QuestionStatus;
use App\Http\Controllers\Controller;
use App\Http\Resources\Api\V1\QuestionResource;
use App\Models\Question;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;

class QuestionController extends Controller
{
    /**
     * Display a listing of publicly answered questions.
     */
    public function index(Request $request): AnonymousResourceCollection
    {
        $query = Question::public()
            ->with(['topic', 'publishedAnswer.user']);

        if ($request->filled('topic')) {
            $topicSlug = $request->input('topic');
            $query->whereHas('topic', function ($q) use ($topicSlug) {
                $q->where('slug', $topicSlug);
            });
        }

        if ($request->filled('q')) {
            $search = $request->input('q');
            $query->where(function ($q) use ($search) {
                $q->where('subject', 'like', "%{$search}%")
                    ->orWhere('body', 'like', "%{$search}%");
            });
        }

        $perPage = min(max((int) $request->input('per_page', 10), 1), 50);
        $questions = $query->paginate($perPage);

        return QuestionResource::collection($questions);
    }

    /**
     * Submit a new citizen question / inquiry.
     */
    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'topic_id' => ['required', 'exists:question_topics,id'],
            'name' => ['required', 'string', 'max:255'],
            'email' => ['required', 'email', 'max:255'],
            'phone' => ['nullable', 'string', 'max:50'],
            'subject' => ['required', 'string', 'max:255'],
            'body' => ['required', 'string', 'min:10', 'max:5000'],
        ]);

        $question = Question::create([
            ...$validated,
            'status' => QuestionStatus::Pending,
            'ip_address' => $request->ip(),
        ]);

        return response()->json([
            'message' => 'Pertanyaan Anda berhasil dikirim. Tim kami akan menelaah dan memberikan tanggapan melalui email.',
            'data' => [
                'id' => $question->id,
                'subject' => $question->subject,
                'status' => $question->status->value,
                'created_at' => $question->created_at->toIso8601String(),
            ],
        ], 201);
    }
}
