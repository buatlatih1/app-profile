<?php

namespace App\Filament\Resources\Questions\RelationManagers;

use Filament\Actions\BulkActionGroup;
use Filament\Actions\CreateAction;
use Filament\Actions\DeleteAction;
use Filament\Actions\DeleteBulkAction;
use Filament\Actions\EditAction;
use Filament\Forms\Components\Hidden;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\Textarea;
use Filament\Forms\Components\Toggle;
use Filament\Resources\RelationManagers\RelationManager;
use Filament\Schemas\Schema;
use Filament\Tables\Columns\IconColumn;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Model;

class AnswersRelationManager extends RelationManager
{
    protected static string $relationship = 'answers';

    public static function getTitle(Model $ownerRecord, string $pageClass): string
    {
        return __('Official Responses & Answers');
    }

    public static function getModelLabel(): ?string
    {
        return __('Response');
    }

    public static function getPluralModelLabel(): ?string
    {
        return __('Official Responses & Answers');
    }

    public function form(Schema $schema): Schema
    {
        return $schema
            ->components([
                Hidden::make('user_id')
                    ->default(fn () => auth()->id()),

                Textarea::make('body')
                    ->label(__('Response / Answer Content'))
                    ->rows(6)
                    ->required()
                    ->helperText(__('This response will be sent to the citizen\'s email upon publication.'))
                    ->columnSpanFull(),

                Select::make('status')
                    ->label(__('Status'))
                    ->options([
                        'published' => __('Published (Sent to Citizen)'),
                        'draft' => __('Internal Draft'),
                    ])
                    ->default('published')
                    ->required(),

                Toggle::make('is_published')
                    ->label(__('Publish to App & Web (Public)'))
                    ->default(true),
            ]);
    }

    public function table(Table $table): Table
    {
        return $table
            ->recordTitleAttribute('body')
            ->columns([
                TextColumn::make('user.name')
                    ->label(__('Responding Officer'))
                    ->weight('bold'),

                TextColumn::make('body')
                    ->label(__('Response'))
                    ->limit(60)
                    ->tooltip(fn ($record): string => $record->body),

                IconColumn::make('is_published')
                    ->label(__('Public'))
                    ->boolean(),

                TextColumn::make('answered_at')
                    ->label(__('Answered At'))
                    ->dateTime('d M Y H:i')
                    ->sortable(),
            ])
            ->filters([
                //
            ])
            ->headerActions([
                CreateAction::make()
                    ->label(__('Add New Response')),
            ])
            ->recordActions([
                EditAction::make(),
                DeleteAction::make(),
            ])
            ->toolbarActions([
                BulkActionGroup::make([
                    DeleteBulkAction::make(),
                ]),
            ]);
    }
}
