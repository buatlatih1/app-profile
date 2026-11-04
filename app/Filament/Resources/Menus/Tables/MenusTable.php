<?php

namespace App\Filament\Resources\Menus\Tables;

use Filament\Actions\BulkActionGroup;
use Filament\Actions\DeleteBulkAction;
use Filament\Actions\EditAction;
use Filament\Tables\Columns\IconColumn;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Filters\SelectFilter;
use Filament\Tables\Table;

class MenusTable
{
    public static function configure(Table $table): Table
    {
        return $table
            ->columns([
                TextColumn::make('name')
                    ->label(__('Menu Name'))
                    ->weight('bold')
                    ->searchable()
                    ->sortable(),

                TextColumn::make('location')
                    ->label(__('Location'))
                    ->badge()
                    ->color(fn (string $state): string => match ($state) {
                        'header' => 'primary',
                        'footer' => 'info',
                        'sidebar' => 'warning',
                        default => 'gray',
                    })
                    ->formatStateUsing(fn (string $state): string => match ($state) {
                        'header' => __('Header'),
                        'footer' => __('Footer'),
                        'sidebar' => __('Sidebar'),
                        default => $state,
                    })
                    ->sortable(),

                TextColumn::make('items_count')
                    ->label(__('Total Items'))
                    ->counts('items')
                    ->badge()
                    ->color('success'),

                IconColumn::make('is_active')
                    ->label(__('Active'))
                    ->boolean()
                    ->sortable(),

                TextColumn::make('updated_at')
                    ->label(__('Last Updated'))
                    ->dateTime('d M Y')
                    ->sortable(),
            ])
            ->filters([
                SelectFilter::make('location')
                    ->label(__('Filter by Location'))
                    ->options([
                        'header' => __('Header'),
                        'footer' => __('Footer'),
                        'sidebar' => __('Sidebar'),
                    ]),
            ])
            ->recordActions([
                EditAction::make(),
            ])
            ->toolbarActions([
                BulkActionGroup::make([
                    DeleteBulkAction::make(),
                ]),
            ]);
    }
}
