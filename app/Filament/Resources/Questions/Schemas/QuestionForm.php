<?php

namespace App\Filament\Resources\Questions\Schemas;

use App\Enums\QuestionStatus;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\Textarea;
use Filament\Forms\Components\TextInput;
use Filament\Schemas\Schema;

class QuestionForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Select::make('topic_id')
                    ->label('Topik Pertanyaan')
                    ->relationship('topic', 'name')
                    ->required()
                    ->searchable()
                    ->preload(),

                Select::make('status')
                    ->label('Status Pertanyaan')
                    ->options([
                        QuestionStatus::Pending->value => 'Menunggu Tanggapan',
                        QuestionStatus::Answered->value => 'Sudah Dijawab',
                        QuestionStatus::Rejected->value => 'Ditolak',
                    ])
                    ->default(QuestionStatus::Pending->value)
                    ->required(),

                TextInput::make('name')
                    ->label('Nama Penanya')
                    ->required()
                    ->maxLength(255),

                TextInput::make('email')
                    ->label('Alamat Email')
                    ->email()
                    ->required()
                    ->maxLength(255),

                TextInput::make('phone')
                    ->label('Nomor WhatsApp / Telepon')
                    ->tel()
                    ->maxLength(50),

                TextInput::make('ip_address')
                    ->label('Alamat IP Penanya')
                    ->disabled()
                    ->dehydrated(false),

                TextInput::make('subject')
                    ->label('Subjek / Judul Pertanyaan')
                    ->required()
                    ->maxLength(255)
                    ->columnSpanFull(),

                Textarea::make('body')
                    ->label('Isi Pertanyaan / Aspirasi')
                    ->required()
                    ->rows(5)
                    ->columnSpanFull(),
            ]);
    }
}
