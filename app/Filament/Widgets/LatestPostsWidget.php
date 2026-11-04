<?php

namespace App\Filament\Widgets;

use App\Enums\PostStatus;
use App\Filament\Resources\Posts\PostResource;
use App\Models\Post;
use Filament\Tables\Columns\ImageColumn;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Table;
use Filament\Widgets\TableWidget;

class LatestPostsWidget extends TableWidget
{
    protected static ?int $sort = 3;

    protected static ?string $heading = 'Artikel Terbaru';

    protected int|string|array $columnSpan = 'full';

    public function table(Table $table): Table
    {
        return $table
            ->query(Post::query()->latest())
            ->defaultPaginationPageOption(5)
            ->columns([
                ImageColumn::make('image')
                    ->label('Gambar')
                    ->disk('public')
                    ->square(),

                TextColumn::make('title')
                    ->label('Judul')
                    ->weight('bold')
                    ->limit(40),

                TextColumn::make('category.name')
                    ->label('Kategori')
                    ->badge()
                    ->color('info'),

                TextColumn::make('status')
                    ->label('Status')
                    ->badge()
                    ->color(fn ($state) => match ($state instanceof PostStatus ? $state->value : $state) {
                        PostStatus::Published->value => 'success',
                        PostStatus::Draft->value => 'warning',
                        PostStatus::Archived->value => 'gray',
                        default => 'primary',
                    })
                    ->formatStateUsing(fn ($state) => match ($state instanceof PostStatus ? $state->value : $state) {
                        PostStatus::Published->value => 'Published',
                        PostStatus::Draft->value => 'Draft',
                        PostStatus::Archived->value => 'Archived',
                        default => $state,
                    }),

                TextColumn::make('view_count')
                    ->label('Dilihat')
                    ->sortable(),

                TextColumn::make('created_at')
                    ->label('Dibuat')
                    ->dateTime('d M Y'),
            ])
            ->recordUrl(fn (Post $record): string => PostResource::getUrl('edit', ['record' => $record]));
    }
}
