<?php

namespace App\Filament\Resources\Questions\Tables;

use App\Enums\QuestionStatus;
use Filament\Actions\BulkActionGroup;
use Filament\Actions\DeleteBulkAction;
use Filament\Actions\EditAction;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Filters\SelectFilter;
use Filament\Tables\Table;

class QuestionsTable
{
    public static function configure(Table $table): Table
    {
        return $table
            ->columns([
                TextColumn::make('created_at')
                    ->label('Tanggal Masuk')
                    ->dateTime('d M Y H:i')
                    ->sortable(),

                TextColumn::make('name')
                    ->label('Nama Warga')
                    ->weight('bold')
                    ->searchable()
                    ->sortable(),

                TextColumn::make('subject')
                    ->label('Subjek')
                    ->limit(35)
                    ->tooltip(fn ($record): string => $record->subject)
                    ->searchable(),

                TextColumn::make('topic.name')
                    ->label('Topik')
                    ->badge()
                    ->color('info')
                    ->sortable()
                    ->searchable(),

                TextColumn::make('status')
                    ->label('Status')
                    ->badge()
                    ->color(fn ($state) => match ($state instanceof QuestionStatus ? $state->value : $state) {
                        QuestionStatus::Answered->value => 'success',
                        QuestionStatus::Pending->value => 'warning',
                        QuestionStatus::Rejected->value => 'danger',
                        default => 'gray',
                    })
                    ->formatStateUsing(fn ($state) => match ($state instanceof QuestionStatus ? $state->value : $state) {
                        QuestionStatus::Answered->value => 'Dijawab',
                        QuestionStatus::Pending->value => 'Menunggu',
                        QuestionStatus::Rejected->value => 'Ditolak',
                        default => $state,
                    })
                    ->sortable(),

                TextColumn::make('email')
                    ->label('Email')
                    ->searchable()
                    ->toggleable(isToggledHiddenByDefault: true),

                TextColumn::make('phone')
                    ->label('Telepon')
                    ->searchable()
                    ->toggleable(isToggledHiddenByDefault: true),
            ])
            ->filters([
                SelectFilter::make('status')
                    ->label('Filter Status')
                    ->options([
                        QuestionStatus::Pending->value => 'Menunggu',
                        QuestionStatus::Answered->value => 'Sudah Dijawab',
                        QuestionStatus::Rejected->value => 'Ditolak',
                    ]),

                SelectFilter::make('topic_id')
                    ->label('Filter Topik')
                    ->relationship('topic', 'name'),
            ])
            ->recordActions([
                EditAction::make(),
            ])
            ->toolbarActions([
                BulkActionGroup::make([
                    DeleteBulkAction::make(),
                ]),
            ])
            ->defaultSort('created_at', 'desc');
    }
}
