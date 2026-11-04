<?php

namespace App\Filament\Resources\Slides\Schemas;

use Filament\Forms\Components\DatePicker;
use Filament\Forms\Components\FileUpload;
use Filament\Forms\Components\Textarea;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\Toggle;
use Filament\Schemas\Schema;

class SlideForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                TextInput::make('title')
                    ->label('Judul Slide')
                    ->required()
                    ->maxLength(255),

                TextInput::make('link_url')
                    ->label('Tautan Tujuan (Link URL)')
                    ->placeholder('https://... atau /posts/judul-artikel')
                    ->maxLength(255),

                FileUpload::make('image')
                    ->label('Gambar Banner Slide')
                    ->image()
                    ->disk('public')
                    ->directory('slides')
                    ->required()
                    ->columnSpanFull(),

                Textarea::make('description')
                    ->label('Keterangan Singkat')
                    ->rows(2)
                    ->columnSpanFull(),

                TextInput::make('sort_order')
                    ->label('Nomor Urut')
                    ->numeric()
                    ->default(0),

                Toggle::make('is_active')
                    ->label('Aktif Ditampilkan')
                    ->default(true),

                DatePicker::make('start_date')
                    ->label('Mulai Ditampilkan (Opsional)'),

                DatePicker::make('end_date')
                    ->label('Selesai Ditampilkan (Opsional)'),
            ]);
    }
}
