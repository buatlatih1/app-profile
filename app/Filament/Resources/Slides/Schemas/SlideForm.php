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
                    ->label(__('Slide Title'))
                    ->required()
                    ->maxLength(255),

                TextInput::make('link_url')
                    ->label(__('Destination Link URL'))
                    ->placeholder(__('https://... or /posts/article-title'))
                    ->maxLength(255),

                FileUpload::make('image')
                    ->label(__('Slide Banner Image'))
                    ->image()
                    ->disk('public')
                    ->directory('slides')
                    ->required()
                    ->columnSpanFull(),

                Textarea::make('description')
                    ->label(__('Short Description'))
                    ->rows(2)
                    ->columnSpanFull(),

                TextInput::make('sort_order')
                    ->label(__('Sort Order'))
                    ->numeric()
                    ->default(0),

                Toggle::make('is_active')
                    ->label(__('Active Display'))
                    ->default(true),

                DatePicker::make('start_date')
                    ->label(__('Start Display Date (Optional)')),

                DatePicker::make('end_date')
                    ->label(__('End Display Date (Optional)')),
            ]);
    }
}
