<?php

namespace App\Filament\Resources\Questions\RelationManagers;

use Filament\Actions\BulkActionGroup;
use Filament\Actions\CreateAction;
use Filament\Actions\DeleteAction;
use Filament\Actions\DeleteBulkAction;
use Filament\Actions\EditAction;
use Filament\Forms\Components\Hidden;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\Textarea;
use Filament\Forms\Components\Toggle;
use Filament\Resources\RelationManagers\RelationManager;
use Filament\Schemas\Schema;
use Filament\Tables\Columns\IconColumn;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Table;

class AnswersRelationManager extends RelationManager
{
    protected static string $relationship = 'answers';

    protected static ?string $title = 'Tanggapan & Jawaban Resmi';

    public function form(Schema $schema): Schema
    {
        return $schema
            ->components([
                Hidden::make('user_id')
                    ->default(fn () => auth()->id()),

                Textarea::make('body')
                    ->label('Isi Tanggapan / Jawaban')
                    ->rows(6)
                    ->required()
                    ->helperText('Tanggapan ini akan otomatis dikirimkan ke email penanya jika dipublikasikan.')
                    ->columnSpanFull(),

                Select::make('status')
                    ->label('Status')
                    ->options([
                        'published' => 'Dipublikasikan (Kirim ke Warga)',
                        'draft' => 'Draf Internal',
                    ])
                    ->default('published')
                    ->required(),

                Toggle::make('is_published')
                    ->label('Publikasikan ke Aplikasi & Web (Bisa dibaca umum)')
                    ->default(true),
            ]);
    }

    public function table(Table $table): Table
    {
        return $table
            ->recordTitleAttribute('body')
            ->columns([
                TextColumn::make('user.name')
                    ->label('Petugas Penjawab')
                    ->weight('bold'),

                TextColumn::make('body')
                    ->label('Tanggapan')
                    ->limit(60)
                    ->tooltip(fn ($record): string => $record->body),

                IconColumn::make('is_published')
                    ->label('Publik')
                    ->boolean(),

                TextColumn::make('answered_at')
                    ->label('Waktu Menjawab')
                    ->dateTime('d M Y H:i')
                    ->sortable(),
            ])
            ->filters([
                //
            ])
            ->headerActions([
                CreateAction::make()
                    ->label('Beri Tanggapan Baru'),
            ])
            ->recordActions([
                EditAction::make(),
                DeleteAction::make(),
            ])
            ->toolbarActions([
                BulkActionGroup::make([
                    DeleteBulkAction::make(),
                ]),
            ]);
    }
}
