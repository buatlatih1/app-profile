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
                    ->label(__('Received Date'))
                    ->dateTime('d M Y H:i')
                    ->sortable(),

                TextColumn::make('name')
                    ->label(__('Citizen Name'))
                    ->weight('bold')
                    ->searchable()
                    ->sortable(),

                TextColumn::make('subject')
                    ->label(__('Subject'))
                    ->limit(35)
                    ->tooltip(fn ($record): string => $record->subject)
                    ->searchable(),

                TextColumn::make('topic.name')
                    ->label(__('Topic'))
                    ->badge()
                    ->color('info')
                    ->sortable()
                    ->searchable(),

                TextColumn::make('status')
                    ->label(__('Status'))
                    ->badge()
                    ->color(fn ($state) => match ($state instanceof QuestionStatus ? $state->value : $state) {
                        QuestionStatus::Answered->value => 'success',
                        QuestionStatus::Pending->value => 'warning',
                        QuestionStatus::Rejected->value => 'danger',
                        default => 'gray',
                    })
                    ->formatStateUsing(fn ($state) => match ($state instanceof QuestionStatus ? $state->value : $state) {
                        QuestionStatus::Answered->value => __('Answered'),
                        QuestionStatus::Pending->value => __('Pending'),
                        QuestionStatus::Rejected->value => __('Rejected'),
                        default => $state,
                    })
                    ->sortable(),

                TextColumn::make('email')
                    ->label(__('Email'))
                    ->searchable()
                    ->toggleable(isToggledHiddenByDefault: true),

                TextColumn::make('phone')
                    ->label(__('Phone'))
                    ->searchable()
                    ->toggleable(isToggledHiddenByDefault: true),
            ])
            ->filters([
                SelectFilter::make('status')
                    ->label(__('Filter by Status'))
                    ->options([
                        QuestionStatus::Pending->value => __('Pending'),
                        QuestionStatus::Answered->value => __('Answered'),
                        QuestionStatus::Rejected->value => __('Rejected'),
                    ]),

                SelectFilter::make('topic_id')
                    ->label(__('Filter by Topic'))
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
