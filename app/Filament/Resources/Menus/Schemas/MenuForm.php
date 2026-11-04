<?php

namespace App\Filament\Resources\Menus\Schemas;

use App\Models\Category;
use App\Models\Page;
use App\Models\Post;
use Filament\Forms\Components\Repeater;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\Toggle;
use Filament\Schemas\Schema;

class MenuForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                TextInput::make('name')
                    ->label('Nama Menu')
                    ->required()
                    ->maxLength(255),

                Select::make('location')
                    ->label('Lokasi Menu')
                    ->options([
                        'header' => 'Header (Navigasi Atas)',
                        'footer' => 'Footer (Navigasi Bawah)',
                        'sidebar' => 'Sidebar (Menu Samping)',
                    ])
                    ->required()
                    ->default('header'),

                Toggle::make('is_active')
                    ->label('Status Aktif')
                    ->default(true),

                Repeater::make('items')
                    ->label('Daftar Tautan Menu')
                    ->relationship('items')
                    ->orderColumn('sort_order')
                    ->schema([
                        TextInput::make('label')
                            ->label('Teks Label')
                            ->required(),

                        Select::make('type')
                            ->label('Tipe Tautan')
                            ->options([
                                'custom' => 'Tautan Kustom / URL Luar',
                                'page' => 'Halaman Statis',
                                'category' => 'Kategori Post',
                                'post' => 'Artikel Tertentu',
                            ])
                            ->default('custom')
                            ->reactive(),

                        TextInput::make('url')
                            ->label('Alamat URL')
                            ->visible(fn ($get) => $get('type') === 'custom')
                            ->placeholder('https://... atau /path'),

                        Select::make('linkable_id')
                            ->label('Pilih Halaman Statis')
                            ->options(fn () => Page::pluck('title', 'id'))
                            ->visible(fn ($get) => $get('type') === 'page')
                            ->searchable(),

                        Select::make('linkable_id')
                            ->label('Pilih Kategori')
                            ->options(fn () => Category::pluck('name', 'id'))
                            ->visible(fn ($get) => $get('type') === 'category')
                            ->searchable(),

                        Select::make('linkable_id')
                            ->label('Pilih Artikel')
                            ->options(fn () => Post::pluck('title', 'id'))
                            ->visible(fn ($get) => $get('type') === 'post')
                            ->searchable(),

                        Toggle::make('is_active')
                            ->label('Aktif')
                            ->default(true),
                    ])
                    ->columns(3)
                    ->columnSpanFull()
                    ->collapsible()
                    ->itemLabel(fn (array $state): ?string => $state['label'] ?? null),
            ]);
    }
}
