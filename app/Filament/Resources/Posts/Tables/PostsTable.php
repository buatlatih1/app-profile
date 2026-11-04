<?php

namespace App\Filament\Resources\Posts\Tables;

use App\Enums\PostStatus;
use Filament\Actions\BulkActionGroup;
use Filament\Actions\DeleteBulkAction;
use Filament\Actions\EditAction;
use Filament\Tables\Columns\IconColumn;
use Filament\Tables\Columns\ImageColumn;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Filters\SelectFilter;
use Filament\Tables\Filters\TernaryFilter;
use Filament\Tables\Table;

class PostsTable
{
    public static function configure(Table $table): Table
    {
        return $table
            ->columns([
                ImageColumn::make('image')
                    ->label('Gambar')
                    ->disk('public')
                    ->square(),

                TextColumn::make('title')
                    ->label('Judul')
                    ->limit(40)
                    ->tooltip(fn ($record): string => $record->title)
                    ->weight('bold')
                    ->searchable()
                    ->sortable(),

                TextColumn::make('category.name')
                    ->label('Kategori')
                    ->badge()
                    ->color('info')
                    ->sortable()
                    ->searchable(),

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
                    })
                    ->sortable(),

                IconColumn::make('is_featured')
                    ->label('Featured')
                    ->boolean()
                    ->sortable(),

                TextColumn::make('view_count')
                    ->label('Dilihat')
                    ->sortable(),

                TextColumn::make('published_at')
                    ->label('Waktu Publikasi')
                    ->dateTime('d M Y H:i')
                    ->sortable(),
            ])
            ->filters([
                SelectFilter::make('category_id')
                    ->label('Filter Kategori')
                    ->relationship('category', 'name'),

                SelectFilter::make('status')
                    ->label('Filter Status')
                    ->options([
                        PostStatus::Published->value => 'Published',
                        PostStatus::Draft->value => 'Draft',
                        PostStatus::Archived->value => 'Archived',
                    ]),

                TernaryFilter::make('is_featured')
                    ->label('Artikel Unggulan')
                    ->trueLabel('Hanya Unggulan')
                    ->falseLabel('Bukan Unggulan'),
            ])
            ->recordActions([
                EditAction::make(),
            ])
            ->toolbarActions([
                BulkActionGroup::make([
                    DeleteBulkAction::make(),
                ]),
            ])
            ->defaultSort('published_at', 'desc');
    }
}
