<?php

namespace App\Http\Resources\Api\V1;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class QuestionAnswerResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'body' => $this->body,
            'answered_at' => $this->answered_at?->toIso8601String(),
            'officer' => [
                'name' => $this->user?->name,
                'avatar' => $this->user?->filament_avatar_url,
            ],
        ];
    }
}
