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
                    ->label(__('Article Category'))
                    ->relationship('category', 'name')
                    ->searchable()
                    ->preload()
                    ->required(),

                TextInput::make('title')
                    ->label(__('Article Title'))
                    ->required()
                    ->maxLength(255)
                    ->live(onBlur: true)
                    ->afterStateUpdated(fn ($state, callable $set) => $set('slug', Str::slug($state))),

                TextInput::make('slug')
                    ->label(__('URL Slug'))
                    ->required()
                    ->unique(ignoreRecord: true)
                    ->maxLength(255),

                FileUpload::make('image')
                    ->label(__('Featured Image'))
                    ->image()
                    ->disk('public')
                    ->directory('posts')
                    ->columnSpanFull(),

                Textarea::make('summary')
                    ->label(__('Brief Summary'))
                    ->rows(3)
                    ->helperText(__('Appears in the article preview list.'))
                    ->columnSpanFull(),

                RichEditor::make('content')
                    ->label(__('Article Content'))
                    ->required()
                    ->columnSpanFull(),

                Select::make('status')
                    ->label(__('Publication Status'))
                    ->options([
                        PostStatus::Draft->value => __('Draft'),
                        PostStatus::Published->value => __('Published'),
                        PostStatus::Archived->value => __('Archived'),
                    ])
                    ->default(PostStatus::Published->value)
                    ->required(),

                DateTimePicker::make('published_at')
                    ->label(__('Publish Time'))
                    ->default(now()),

                Toggle::make('is_featured')
                    ->label(__('Featured Post'))
                    ->default(false),
            ]);
    }
}
