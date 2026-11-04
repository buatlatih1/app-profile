<?php

namespace App\Filament\Resources\Media\Schemas;

use Filament\Forms\Components\FileUpload;
use Filament\Forms\Components\Hidden;
use Filament\Forms\Components\TextInput;
use Filament\Schemas\Schema;

class MediaForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Hidden::make('user_id')
                    ->default(fn () => auth()->id()),

                FileUpload::make('file_path')
                    ->label('File / Gambar')
                    ->disk('public')
                    ->directory('media')
                    ->required()
                    ->columnSpanFull(),

                TextInput::make('file_name')
                    ->label('Nama File / Judul')
                    ->required()
                    ->maxLength(255),

                TextInput::make('alt_text')
                    ->label('Teks Alternatif (Alt Text)')
                    ->maxLength(255),

                TextInput::make('mime_type')
                    ->label('Mime Type')
                    ->placeholder('image/jpeg, application/pdf'),

                TextInput::make('file_size')
                    ->label('Ukuran File (bytes)')
                    ->numeric()
                    ->default(0),

                TextInput::make('disk')
                    ->default('public')
                    ->required(),
            ]);
    }
}
