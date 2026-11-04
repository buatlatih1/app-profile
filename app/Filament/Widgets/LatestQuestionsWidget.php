<?php

namespace App\Filament\Widgets;

use App\Enums\QuestionStatus;
use App\Filament\Resources\Questions\QuestionResource;
use App\Models\Question;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Table;
use Filament\Widgets\TableWidget;

class LatestQuestionsWidget extends TableWidget
{
    protected static ?int $sort = 2;

    protected static ?string $heading = 'Pertanyaan Masyarakat Terbaru';

    protected int|string|array $columnSpan = 'full';

    public function table(Table $table): Table
    {
        return $table
            ->query(Question::query()->latest())
            ->defaultPaginationPageOption(5)
            ->columns([
                TextColumn::make('created_at')
                    ->label('Tanggal Masuk')
                    ->dateTime('d M Y H:i'),

                TextColumn::make('name')
                    ->label('Nama Warga')
                    ->weight('bold'),

                TextColumn::make('topic.name')
                    ->label('Topik')
                    ->badge()
                    ->color('info'),

                TextColumn::make('subject')
                    ->label('Subjek Pertanyaan')
                    ->limit(40),

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
                    }),
            ])
            ->recordUrl(fn (Question $record): string => QuestionResource::getUrl('edit', ['record' => $record]));
    }
}
