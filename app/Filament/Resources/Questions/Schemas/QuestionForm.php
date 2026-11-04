<?php

namespace App\Filament\Resources\Questions\Schemas;

use App\Enums\QuestionStatus;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\Textarea;
use Filament\Forms\Components\TextInput;
use Filament\Schemas\Schema;

class QuestionForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Select::make('topic_id')
                    ->label(__('Question Topic'))
                    ->relationship('topic', 'name')
                    ->required()
                    ->searchable()
                    ->preload(),

                Select::make('status')
                    ->label(__('Question Status'))
                    ->options([
                        QuestionStatus::Pending->value => __('Pending Response'),
                        QuestionStatus::Answered->value => __('Answered'),
                        QuestionStatus::Rejected->value => __('Rejected'),
                    ])
                    ->default(QuestionStatus::Pending->value)
                    ->required(),

                TextInput::make('name')
                    ->label(__('Citizen Name'))
                    ->required()
                    ->maxLength(255),

                TextInput::make('email')
                    ->label(__('Email Address'))
                    ->email()
                    ->required()
                    ->maxLength(255),

                TextInput::make('phone')
                    ->label(__('Phone / WhatsApp Number'))
                    ->tel()
                    ->maxLength(50),

                TextInput::make('ip_address')
                    ->label(__('Citizen IP Address'))
                    ->disabled()
                    ->dehydrated(false),

                TextInput::make('subject')
                    ->label(__('Subject'))
                    ->required()
                    ->maxLength(255)
                    ->columnSpanFull(),

                Textarea::make('body')
                    ->label(__('Question / Feedback Content'))
                    ->required()
                    ->rows(5)
                    ->columnSpanFull(),
            ]);
    }
}
