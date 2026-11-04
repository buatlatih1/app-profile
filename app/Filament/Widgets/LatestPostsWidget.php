<?php

namespace App\Filament\Widgets;

use App\Enums\PostStatus;
use App\Filament\Resources\Posts\PostResource;
use App\Models\Post;
use Filament\Tables\Columns\ImageColumn;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Table;
use Filament\Widgets\TableWidget;
use Illuminate\Contracts\Support\Htmlable;

class LatestPostsWidget extends TableWidget
{
    protected static ?int $sort = 3;

    protected int|string|array $columnSpan = 'full';

    public function getTableHeading(): string|Htmlable|null
    {
        return __('Latest Articles');
    }

    public function table(Table $table): Table
    {
        return $table
            ->query(Post::query()->latest())
            ->defaultPaginationPageOption(5)
            ->columns([
                ImageColumn::make('image')
                    ->label(__('Image'))
                    ->disk('public')
                    ->square(),

                TextColumn::make('title')
                    ->label(__('Title'))
                    ->weight('bold')
                    ->limit(40),

                TextColumn::make('category.name')
                    ->label(__('Category'))
                    ->badge()
                    ->color('info'),

                TextColumn::make('status')
                    ->label(__('Status'))
                    ->badge()
                    ->color(fn ($state) => match ($state instanceof PostStatus ? $state->value : $state) {
                        PostStatus::Published->value => 'success',
                        PostStatus::Draft->value => 'warning',
                        PostStatus::Archived->value => 'gray',
                        default => 'primary',
                    })
                    ->formatStateUsing(fn ($state) => match ($state instanceof PostStatus ? $state->value : $state) {
                        PostStatus::Published->value => __('Published'),
                        PostStatus::Draft->value => __('Draft'),
                        PostStatus::Archived->value => __('Archived'),
                        default => $state,
                    }),

                TextColumn::make('view_count')
                    ->label(__('Views'))
                    ->sortable(),

                TextColumn::make('created_at')
                    ->label(__('Created At'))
                    ->dateTime('d M Y'),
            ])
            ->recordUrl(fn (Post $record): string => PostResource::getUrl('edit', ['record' => $record]));
    }
}
