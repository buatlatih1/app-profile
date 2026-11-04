<?php

namespace App\Filament\Resources\Users\Tables;

use App\Enums\UserRole;
use Filament\Actions\BulkActionGroup;
use Filament\Actions\DeleteBulkAction;
use Filament\Actions\EditAction;
use Filament\Tables\Columns\ImageColumn;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Filters\SelectFilter;
use Filament\Tables\Table;

class UsersTable
{
    public static function configure(Table $table): Table
    {
        return $table
            ->columns([
                ImageColumn::make('avatar')
                    ->label(__('Avatar'))
                    ->circular()
                    ->disk('public'),

                TextColumn::make('name')
                    ->label(__('Name'))
                    ->weight('bold')
                    ->searchable()
                    ->sortable(),

                TextColumn::make('email')
                    ->label(__('Email'))
                    ->searchable()
                    ->sortable(),

                TextColumn::make('role')
                    ->label(__('Role'))
                    ->badge()
                    ->color(fn ($state) => match ($state instanceof UserRole ? $state->value : $state) {
                        UserRole::Admin->value => 'danger',
                        UserRole::Editor->value => 'warning',
                        UserRole::Viewer->value => 'info',
                        default => 'gray',
                    })
                    ->formatStateUsing(fn ($state) => match ($state instanceof UserRole ? $state->value : $state) {
                        UserRole::Admin->value => __('Administrator'),
                        UserRole::Editor->value => __('Editor'),
                        UserRole::Viewer->value => __('Viewer'),
                        default => $state,
                    })
                    ->sortable(),

                TextColumn::make('created_at')
                    ->label(__('Registered At'))
                    ->dateTime('d M Y')
                    ->sortable(),
            ])
            ->filters([
                SelectFilter::make('role')
                    ->label(__('Filter by Role'))
                    ->options([
                        UserRole::Admin->value => __('Administrator'),
                        UserRole::Editor->value => __('Editor'),
                        UserRole::Viewer->value => __('Viewer'),
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
