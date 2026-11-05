<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Spatie\Translatable\HasTranslations;

#[Fillable([
    'menu_id',
    'parent_id',
    'label',
    'url',
    'type',
    'linkable_id',
    'linkable_type',
    'sort_order',
    'is_active',
])]
class MenuItem extends Model
{
    use HasFactory;
    use HasTranslations;

    public array $translatable = ['label'];

    protected function casts(): array
    {
        return [
            'is_active' => 'boolean',
            'sort_order' => 'integer',
        ];
    }

    public function menu(): BelongsTo
    {
        return $this->belongsTo(Menu::class);
    }

    public function parent(): BelongsTo
    {
        return $this->belongsTo(MenuItem::class, 'parent_id');
    }

    public function children(): HasMany
    {
        return $this->hasMany(MenuItem::class, 'parent_id')->orderBy('sort_order');
    }

    /**
     * Compute final destination URL based on type.
     */
    public function getTargetUrlAttribute(): ?string
    {
        if ($this->type === 'custom') {
            return $this->url;
        }

        if ($this->type === 'page' && $this->linkable_id) {
            $page = Page::find($this->linkable_id);

            return $page ? '/page/'.$page->slug : $this->url;
        }

        if ($this->type === 'post' && $this->linkable_id) {
            $post = Post::find($this->linkable_id);

            return $post ? '/post/'.$post->slug : $this->url;
        }

        if ($this->type === 'category' && $this->linkable_id) {
            $cat = Category::find($this->linkable_id);

            return $cat ? '/category/'.$cat->slug : $this->url;
        }

        return $this->url;
    }
}
