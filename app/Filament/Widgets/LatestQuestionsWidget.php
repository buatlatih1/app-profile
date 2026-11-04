<?php

namespace App\Filament\Widgets;

use App\Enums\QuestionStatus;
use App\Filament\Resources\Questions\QuestionResource;
use App\Models\Question;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Table;
use Filament\Widgets\TableWidget;
use Illuminate\Contracts\Support\Htmlable;

class LatestQuestionsWidget extends TableWidget
{
    protected static ?int $sort = 2;

    protected int|string|array $columnSpan = 'full';

    public function getTableHeading(): string|Htmlable|null
    {
        return __('Latest Citizen Questions');
    }

    public function table(Table $table): Table
    {
        return $table
            ->query(Question::query()->latest())
            ->defaultPaginationPageOption(5)
            ->columns([
                TextColumn::make('created_at')
                    ->label(__('Received Date'))
                    ->dateTime('d M Y H:i'),

                TextColumn::make('name')
                    ->label(__('Citizen Name'))
                    ->weight('bold'),

                TextColumn::make('topic.name')
                    ->label(__('Topic'))
                    ->badge()
                    ->color('info'),

                TextColumn::make('subject')
                    ->label(__('Subject'))
                    ->limit(40),

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
                    }),
            ])
            ->recordUrl(fn (Question $record): string => QuestionResource::getUrl('edit', ['record' => $record]));
    }
}
