<?php

namespace App\Filament\Resources\Users\Schemas;

use App\Enums\UserRole;
use Filament\Forms\Components\FileUpload;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\TextInput;
use Filament\Schemas\Schema;

class UserForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                FileUpload::make('avatar')
                    ->label(__('Profile Picture'))
                    ->image()
                    ->avatar()
                    ->disk('public')
                    ->directory('avatars')
                    ->columnSpanFull(),

                TextInput::make('name')
                    ->label(__('Full Name'))
                    ->required()
                    ->maxLength(255),

                TextInput::make('email')
                    ->label(__('Email Address'))
                    ->email()
                    ->required()
                    ->unique(ignoreRecord: true)
                    ->maxLength(255),

                Select::make('role')
                    ->label(__('Role'))
                    ->options([
                        UserRole::Admin->value => __('Administrator'),
                        UserRole::Editor->value => __('Content Editor'),
                        UserRole::Viewer->value => __('Viewer (Read Only)'),
                    ])
                    ->default(UserRole::Editor->value)
                    ->required(),

                TextInput::make('password')
                    ->label(__('Password'))
                    ->password()
                    ->dehydrated(fn ($state) => filled($state))
                    ->required(fn (string $context): bool => $context === 'create')
                    ->helperText(fn (string $context): string => $context === 'edit' ? __('Leave blank if you do not want to change the password') : ''),
            ]);
    }
}
