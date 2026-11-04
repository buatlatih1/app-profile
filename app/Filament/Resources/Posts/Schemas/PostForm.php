<?php

namespace App\Filament\Resources\Posts\Schemas;

use App\Enums\PostStatus;
use Filament\Forms\Components\DateTimePicker;
use Filament\Forms\Components\FileUpload;
use Filament\Forms\Components\Hidden;
use Filament\Forms\Components\RichEditor;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\Textarea;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\Toggle;
use Filament\Schemas\Schema;
use Illuminate\Support\Str;

class PostForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Hidden::make('user_id')
                    ->default(fn () => auth()->id()),

                Select::make('category_id')
                    ->label('Kategori Artikel')
                    ->relationship('category', 'name')
                    ->searchable()
                    ->preload()
                    ->required(),

                TextInput::make('title')
                    ->label('Judul Artikel')
                    ->required()
                    ->maxLength(255)
                    ->live(onBlur: true)
                    ->afterStateUpdated(fn ($state, callable $set) => $set('slug', Str::slug($state))),

                TextInput::make('slug')
                    ->label('Slug URL')
                    ->required()
                    ->unique(ignoreRecord: true)
                    ->maxLength(255),

                FileUpload::make('image')
                    ->label('Gambar Utama (Featured Image)')
                    ->image()
                    ->disk('public')
                    ->directory('posts')
                    ->columnSpanFull(),

                Textarea::make('summary')
                    ->label('Ringkasan Singkat')
                    ->rows(3)
                    ->helperText('Tampil pada preview daftar artikel di aplikasi Flutter.')
                    ->columnSpanFull(),

                RichEditor::make('content')
                    ->label('Isi Konten Artikel')
                    ->required()
                    ->columnSpanFull(),

                Select::make('status')
                    ->label('Status Publikasi')
                    ->options([
                        PostStatus::Draft->value => 'Draft (Draf)',
                        PostStatus::Published->value => 'Published (Diterbitkan)',
                        PostStatus::Archived->value => 'Archived (Diarsipkan)',
                    ])
                    ->default(PostStatus::Published->value)
                    ->required(),

                DateTimePicker::make('published_at')
                    ->label('Waktu Tayang')
                    ->default(now()),

                Toggle::make('is_featured')
                    ->label('Tampilkan sebagai Unggulan (Featured)')
                    ->default(false),
            ]);
    }
}
