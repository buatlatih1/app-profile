<?php

namespace App\Filament\Widgets;

use App\Enums\PostStatus;
use App\Enums\QuestionStatus;
use App\Models\Post;
use App\Models\Question;
use Filament\Widgets\StatsOverviewWidget as BaseStatsOverviewWidget;
use Filament\Widgets\StatsOverviewWidget\Stat;

class StatsOverviewWidget extends BaseStatsOverviewWidget
{
    protected static ?int $sort = 1;

    protected function getStats(): array
    {
        $publishedPosts = Post::where('status', PostStatus::Published)->count();
        $totalViews = Post::sum('view_count');
        $pendingQuestions = Question::where('status', QuestionStatus::Pending)->count();
        $answeredQuestions = Question::where('status', QuestionStatus::Answered)->count();

        return [
            Stat::make('Artikel Diterbitkan', $publishedPosts)
                ->description('Total artikel aktif publik')
                ->descriptionIcon('heroicon-m-document-text')
                ->color('primary'),

            Stat::make('Pertanyaan Menunggu', $pendingQuestions)
                ->description($pendingQuestions > 0 ? 'Perlu respon tim admin' : 'Semua pertanyaan selesai')
                ->descriptionIcon('heroicon-m-chat-bubble-left-ellipsis')
                ->color($pendingQuestions > 0 ? 'warning' : 'success'),

            Stat::make('Pertanyaan Dijawab', $answeredQuestions)
                ->description('Telah ditanggapi dan dipublikasikan')
                ->descriptionIcon('heroicon-m-check-badge')
                ->color('success'),

            Stat::make('Total Pembaca Artikel', number_format($totalViews))
                ->description('Akumulasi pembaca portal')
                ->descriptionIcon('heroicon-m-eye')
                ->color('info'),
        ];
    }
}
