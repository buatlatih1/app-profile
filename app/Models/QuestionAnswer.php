<?php

namespace App\Models;

use App\Enums\QuestionStatus;
use App\Notifications\QuestionAnsweredNotification;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Support\Facades\Notification;

#[Fillable([
    'question_id',
    'user_id',
    'body',
    'status',
    'is_published',
    'answered_at',
])]
class QuestionAnswer extends Model
{
    use HasFactory;

    protected function casts(): array
    {
        return [
            'is_published' => 'boolean',
            'answered_at' => 'datetime',
        ];
    }

    protected static function booted(): void
    {
        static::creating(function (QuestionAnswer $answer) {
            if (empty($answer->answered_at)) {
                $answer->answered_at = now();
            }
        });

        static::saved(function (QuestionAnswer $answer) {
            if ($answer->is_published && $answer->question) {
                $answer->question->update(['status' => QuestionStatus::Answered]);

                // Send email notification to citizen
                try {
                    Notification::route('mail', $answer->question->email)
                        ->notify(new QuestionAnsweredNotification($answer->question, $answer));
                } catch (\Throwable $e) {
                    // Log or ignore if mail server is not configured in local environment
                    report($e);
                }
            }
        });
    }

    public function question(): BelongsTo
    {
        return $this->belongsTo(Question::class);
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }
}
