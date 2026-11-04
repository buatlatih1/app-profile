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
                    ->label('Kelompok')
                    ->options([
                        'general' => 'Umum (General)',
                        'contact' => 'Kontak (Contact)',
                        'social' => 'Media Sosial (Social)',
                        'appearance' => 'Tampilan (Appearance)',
                    ])
                    ->required()
                    ->default('general'),

                Select::make('type')
                    ->label('Tipe Nilai')
                    ->options([
                        'text' => 'Teks Pendek',
                        'textarea' => 'Teks Panjang',
                        'image' => 'Gambar / Logo',
                        'boolean' => 'Boolean (Aktif/Nonaktif)',
                        'json' => 'JSON',
                    ])
                    ->required()
                    ->default('text')
                    ->reactive(),

                TextInput::make('key')
                    ->label('Kunci (Key)')
                    ->required()
                    ->unique(ignoreRecord: true)
                    ->helperText('Contoh: site_name, contact_email, dll.'),

                TextInput::make('value')
                    ->label('Nilai Pengaturan')
                    ->visible(fn ($get) => in_array($get('type'), ['text', null]))
                    ->columnSpanFull(),

                Textarea::make('value')
                    ->label('Nilai Pengaturan')
                    ->rows(4)
                    ->visible(fn ($get) => in_array($get('type'), ['textarea', 'json']))
                    ->columnSpanFull(),

                FileUpload::make('value')
                    ->label('Upload Gambar')
                    ->image()
                    ->disk('public')
                    ->directory('settings')
                    ->visible(fn ($get) => $get('type') === 'image')
                    ->columnSpanFull(),

                Toggle::make('value')
                    ->label('Status Aktif')
                    ->visible(fn ($get) => $get('type') === 'boolean')
                    ->columnSpanFull(),
            ]);
    }
}
