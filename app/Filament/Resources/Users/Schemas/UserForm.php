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
                    ->label('Foto Profil')
                    ->image()
                    ->avatar()
                    ->disk('public')
                    ->directory('avatars')
                    ->columnSpanFull(),

                TextInput::make('name')
                    ->label('Nama Lengkap')
                    ->required()
                    ->maxLength(255),

                TextInput::make('email')
                    ->label('Alamat Email')
                    ->email()
                    ->required()
                    ->unique(ignoreRecord: true)
                    ->maxLength(255),

                Select::make('role')
                    ->label('Peran (Role)')
                    ->options([
                        UserRole::Admin->value => 'Administrator',
                        UserRole::Editor->value => 'Editor Konten',
                        UserRole::Viewer->value => 'Viewer (Hanya Lihat)',
                    ])
                    ->default(UserRole::Editor->value)
                    ->required(),

                TextInput::make('password')
                    ->label('Password')
                    ->password()
                    ->dehydrated(fn ($state) => filled($state))
                    ->required(fn (string $context): bool => $context === 'create')
                    ->helperText(fn (string $context): string => $context === 'edit' ? 'Kosongkan jika tidak ingin mengubah password' : ''),
            ]);
    }
}
