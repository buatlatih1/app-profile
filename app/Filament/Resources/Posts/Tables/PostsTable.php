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
                    ->label(__('Image'))
                    ->disk('public')
                    ->square(),

                TextColumn::make('title')
                    ->label(__('Title'))
                    ->limit(40)
                    ->tooltip(fn ($record): string => $record->title)
                    ->weight('bold')
                    ->searchable()
                    ->sortable(),

                TextColumn::make('category.name')
                    ->label(__('Category'))
                    ->badge()
                    ->color('info')
                    ->sortable()
                    ->searchable(),

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
                    })
                    ->sortable(),

                IconColumn::make('is_featured')
                    ->label(__('Featured'))
                    ->boolean()
                    ->sortable(),

                TextColumn::make('view_count')
                    ->label(__('Views'))
                    ->sortable(),

                TextColumn::make('published_at')
                    ->label(__('Published At'))
                    ->dateTime('d M Y H:i')
                    ->sortable(),
            ])
            ->filters([
                SelectFilter::make('category_id')
                    ->label(__('Filter by Category'))
                    ->relationship('category', 'name'),

                SelectFilter::make('status')
                    ->label(__('Filter by Status'))
                    ->options([
                        PostStatus::Published->value => __('Published'),
                        PostStatus::Draft->value => __('Draft'),
                        PostStatus::Archived->value => __('Archived'),
                    ]),

                TernaryFilter::make('is_featured')
                    ->label(__('Featured Articles'))
                    ->trueLabel(__('Featured Only'))
                    ->falseLabel(__('Non-Featured Only')),
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
