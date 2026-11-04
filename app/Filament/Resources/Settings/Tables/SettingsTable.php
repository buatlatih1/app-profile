<?php

namespace App\Filament\Resources\Settings\Tables;

use Filament\Actions\BulkActionGroup;
use Filament\Actions\DeleteBulkAction;
use Filament\Actions\EditAction;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Filters\SelectFilter;
use Filament\Tables\Table;

class SettingsTable
{
    public static function configure(Table $table): Table
    {
        return $table
            ->columns([
                TextColumn::make('group')
                    ->label(__('Group'))
                    ->badge()
                    ->colors([
                        'primary' => 'general',
                        'success' => 'contact',
                        'warning' => 'social',
                        'info' => 'appearance',
                    ])
                    ->formatStateUsing(fn (string $state): string => match ($state) {
                        'general' => __('General'),
                        'contact' => __('Contact'),
                        'social' => __('Social Media'),
                        'appearance' => __('Appearance'),
                        default => $state,
                    })
                    ->sortable()
                    ->searchable(),

                TextColumn::make('key')
                    ->label(__('Key'))
                    ->weight('bold')
                    ->searchable()
                    ->sortable(),

                TextColumn::make('value')
                    ->label(__('Value'))
                    ->limit(50)
                    ->tooltip(fn ($record): ?string => $record->value)
                    ->searchable(),

                TextColumn::make('type')
                    ->label(__('Type'))
                    ->badge()
                    ->formatStateUsing(fn (string $state): string => match ($state) {
                        'text' => __('Short Text'),
                        'textarea' => __('Long Text'),
                        'image' => __('Image / Logo'),
                        'boolean' => __('Boolean (On/Off)'),
                        'json' => __('JSON'),
                        default => $state,
                    })
                    ->sortable(),

                TextColumn::make('updated_at')
                    ->label(__('Last Updated'))
                    ->dateTime('d M Y H:i')
                    ->sortable(),
            ])
            ->filters([
                SelectFilter::make('group')
                    ->label(__('Filter by Group'))
                    ->options([
                        'general' => __('General'),
                        'contact' => __('Contact'),
                        'social' => __('Social Media'),
                        'appearance' => __('Appearance'),
                    ]),
                SelectFilter::make('type')
                    ->label(__('Filter by Type'))
                    ->options([
                        'text' => __('Short Text'),
                        'textarea' => __('Long Text'),
                        'image' => __('Image / Logo'),
                        'boolean' => __('Boolean (On/Off)'),
                        'json' => __('JSON'),
                    ]),
            ])
            ->recordActions([
                EditAction::make(),
            ])
            ->toolbarActions([
                BulkActionGroup::make([
                    DeleteBulkAction::make(),
                ]),
            ])
            ->defaultSort('group');
    }
}
