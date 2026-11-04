<?php

namespace App\Filament\Resources\Settings\Schemas;

use Filament\Forms\Components\FileUpload;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\Textarea;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\Toggle;
use Filament\Schemas\Schema;

class SettingForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Select::make('group')
                    ->label(__('Group'))
                    ->options([
                        'general' => __('General'),
                        'contact' => __('Contact'),
                        'social' => __('Social Media'),
                        'appearance' => __('Appearance'),
                    ])
                    ->required()
                    ->default('general'),

                Select::make('type')
                    ->label(__('Value Type'))
                    ->options([
                        'text' => __('Short Text'),
                        'textarea' => __('Long Text'),
                        'image' => __('Image / Logo'),
                        'boolean' => __('Boolean (On/Off)'),
                        'json' => __('JSON'),
                    ])
                    ->required()
                    ->default('text')
                    ->reactive(),

                TextInput::make('key')
                    ->label(__('Key'))
                    ->required()
                    ->unique(ignoreRecord: true)
                    ->helperText(__('Example: site_name, contact_email, etc.')),

                TextInput::make('value')
                    ->label(__('Setting Value'))
                    ->visible(fn ($get) => in_array($get('type'), ['text', null]))
                    ->columnSpanFull(),

                Textarea::make('value')
                    ->label(__('Setting Value'))
                    ->rows(4)
                    ->visible(fn ($get) => in_array($get('type'), ['textarea', 'json']))
                    ->columnSpanFull(),

                FileUpload::make('value')
                    ->label(__('Upload Image'))
                    ->image()
                    ->disk('public')
                    ->directory('settings')
                    ->visible(fn ($get) => $get('type') === 'image')
                    ->columnSpanFull(),

                Toggle::make('value')
                    ->label(__('Active Status'))
                    ->visible(fn ($get) => $get('type') === 'boolean')
                    ->columnSpanFull(),
            ]);
    }
}
