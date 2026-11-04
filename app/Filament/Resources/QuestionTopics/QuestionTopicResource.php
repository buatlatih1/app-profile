<?php

namespace App\Filament\Resources\QuestionTopics;

use App\Filament\Resources\QuestionTopics\Pages\CreateQuestionTopic;
use App\Filament\Resources\QuestionTopics\Pages\EditQuestionTopic;
use App\Filament\Resources\QuestionTopics\Pages\ListQuestionTopics;
use App\Filament\Resources\QuestionTopics\Schemas\QuestionTopicForm;
use App\Filament\Resources\QuestionTopics\Tables\QuestionTopicsTable;
use App\Models\QuestionTopic;
use BackedEnum;
use Filament\Resources\Resource;
use Filament\Schemas\Schema;
use Filament\Support\Icons\Heroicon;
use Filament\Tables\Table;
use UnitEnum;

class QuestionTopicResource extends Resource
{
    protected static ?string $model = QuestionTopic::class;

    protected static string|BackedEnum|null $navigationIcon = Heroicon::OutlinedTag;

    protected static UnitEnum|string|null $navigationGroup = 'Layanan Masyarakat';

    protected static ?int $navigationSort = 2;

    public static function getNavigationLabel(): string
    {
        return 'Topik Pertanyaan';
    }

    public static function getModelLabel(): string
    {
        return 'Topik Pertanyaan';
    }

    public static function getPluralModelLabel(): string
    {
        return 'Daftar Topik Pertanyaan';
    }

    public static function form(Schema $schema): Schema
    {
        return QuestionTopicForm::configure($schema);
    }

    public static function table(Table $table): Table
    {
        return QuestionTopicsTable::configure($table);
    }

    public static function getRelations(): array
    {
        return [
            //
        ];
    }

    public static function getPages(): array
    {
        return [
            'index' => ListQuestionTopics::route('/'),
            'create' => CreateQuestionTopic::route('/create'),
            'edit' => EditQuestionTopic::route('/{record}/edit'),
        ];
    }
}
