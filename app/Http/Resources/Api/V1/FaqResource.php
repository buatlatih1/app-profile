<?php

namespace App\Http\Resources\Api\V1;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class FaqResource extends JsonResource
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
            'topic' => [
                'id' => $this->topic?->id,
                'name' => $this->topic?->name,
                'slug' => $this->topic?->slug,
            ],
            'question' => $this->question,
            'answer' => $this->answer,
            'sort_order' => $this->sort_order,
        ];
    }
}
