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
                    ->label('Kelompok')
                    ->badge()
                    ->colors([
                        'primary' => 'general',
                        'success' => 'contact',
                        'warning' => 'social',
                        'info' => 'appearance',
                    ])
                    ->sortable()
                    ->searchable(),

                TextColumn::make('key')
                    ->label('Kunci')
                    ->weight('bold')
                    ->searchable()
                    ->sortable(),

                TextColumn::make('value')
                    ->label('Nilai')
                    ->limit(50)
                    ->tooltip(fn ($record): ?string => $record->value)
                    ->searchable(),

                TextColumn::make('type')
                    ->label('Tipe')
                    ->badge()
                    ->sortable(),

                TextColumn::make('updated_at')
                    ->label('Terakhir Diperbarui')
                    ->dateTime('d M Y H:i')
                    ->sortable(),
            ])
            ->filters([
                SelectFilter::make('group')
                    ->label('Filter Kelompok')
                    ->options([
                        'general' => 'Umum',
                        'contact' => 'Kontak',
                        'social' => 'Media Sosial',
                        'appearance' => 'Tampilan',
                    ]),
                SelectFilter::make('type')
                    ->label('Filter Tipe')
                    ->options([
                        'text' => 'Teks Pendek',
                        'textarea' => 'Teks Panjang',
                        'image' => 'Gambar',
                        'boolean' => 'Boolean',
                        'json' => 'JSON',
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
