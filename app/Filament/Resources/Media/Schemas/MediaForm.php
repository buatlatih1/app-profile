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
                    ->label(__('File / Image'))
                    ->disk('public')
                    ->directory('media')
                    ->required()
                    ->columnSpanFull(),

                TextInput::make('file_name')
                    ->label(__('File Name / Title'))
                    ->required()
                    ->maxLength(255),

                TextInput::make('alt_text')
                    ->label(__('Alt Text'))
                    ->maxLength(255),

                TextInput::make('mime_type')
                    ->label(__('MIME Type'))
                    ->placeholder('image/jpeg, application/pdf'),

                TextInput::make('file_size')
                    ->label(__('File Size (bytes)'))
                    ->numeric()
                    ->default(0),

                TextInput::make('disk')
                    ->label(__('Storage Disk'))
                    ->default('public')
                    ->required(),
            ]);
    }
}
