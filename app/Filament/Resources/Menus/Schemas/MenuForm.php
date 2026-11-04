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
                    ->label(__('Menu Name'))
                    ->required()
                    ->maxLength(255),

                Select::make('location')
                    ->label(__('Menu Location'))
                    ->options([
                        'header' => __('Header (Top Navigation)'),
                        'footer' => __('Footer (Bottom Navigation)'),
                        'sidebar' => __('Sidebar'),
                    ])
                    ->required()
                    ->default('header'),

                Toggle::make('is_active')
                    ->label(__('Active Status'))
                    ->default(true),

                Repeater::make('items')
                    ->label(__('Menu Items'))
                    ->relationship('items')
                    ->orderColumn('sort_order')
                    ->schema([
                        TextInput::make('label')
                            ->label(__('Label Text'))
                            ->required(),

                        Select::make('type')
                            ->label(__('Link Type'))
                            ->options([
                                'custom' => __('Custom URL / External Link'),
                                'page' => __('Static Page'),
                                'category' => __('Post Category'),
                                'post' => __('Specific Post'),
                            ])
                            ->default('custom')
                            ->reactive(),

                        TextInput::make('url')
                            ->label(__('URL Address'))
                            ->visible(fn ($get) => $get('type') === 'custom')
                            ->placeholder(__('https://... or /path')),

                        Select::make('linkable_id')
                            ->label(__('Select Static Page'))
                            ->options(fn () => Page::pluck('title', 'id'))
                            ->visible(fn ($get) => $get('type') === 'page')
                            ->searchable(),

                        Select::make('linkable_id')
                            ->label(__('Select Category'))
                            ->options(fn () => Category::pluck('name', 'id'))
                            ->visible(fn ($get) => $get('type') === 'category')
                            ->searchable(),

                        Select::make('linkable_id')
                            ->label(__('Select Post'))
                            ->options(fn () => Post::pluck('title', 'id'))
                            ->visible(fn ($get) => $get('type') === 'post')
                            ->searchable(),

                        Toggle::make('is_active')
                            ->label(__('Active'))
                            ->default(true),
                    ])
                    ->columns(3)
                    ->columnSpanFull()
                    ->collapsible()
                    ->itemLabel(fn (array $state): ?string => $state['label'] ?? null),
            ]);
    }
}
