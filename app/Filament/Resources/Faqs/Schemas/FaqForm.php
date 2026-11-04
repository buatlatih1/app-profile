<?php

namespace App\Filament\Resources\Faqs\Schemas;

use Filament\Forms\Components\RichEditor;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\Toggle;
use Filament\Schemas\Schema;

class FaqForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Select::make('topic_id')
                    ->label('Topik Kategori FAQ')
                    ->relationship('topic', 'name')
                    ->searchable()
                    ->preload(),

                TextInput::make('question')
                    ->label('Pertanyaan (FAQ)')
                    ->required()
                    ->maxLength(255)
                    ->columnSpanFull(),

                RichEditor::make('answer')
                    ->label('Jawaban')
                    ->required()
                    ->columnSpanFull(),

                TextInput::make('sort_order')
                    ->label('Nomor Urut')
                    ->numeric()
                    ->default(0),

                Toggle::make('is_active')
                    ->label('Aktif')
                    ->default(true),
            ]);
    }
}
