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
            Stat::make(__('Published Articles'), $publishedPosts)
                ->description(__('Total active public articles'))
                ->descriptionIcon('heroicon-m-document-text')
                ->color('primary'),

            Stat::make(__('Pending Questions'), $pendingQuestions)
                ->description($pendingQuestions > 0 ? __('Needs response from admin team') : __('All questions handled'))
                ->descriptionIcon('heroicon-m-chat-bubble-left-ellipsis')
                ->color($pendingQuestions > 0 ? 'warning' : 'success'),

            Stat::make(__('Answered Questions'), $answeredQuestions)
                ->description(__('Responded and published'))
                ->descriptionIcon('heroicon-m-check-badge')
                ->color('success'),

            Stat::make(__('Total Article Readers'), number_format($totalViews))
                ->description(__('Accumulated portal readers'))
                ->descriptionIcon('heroicon-m-eye')
                ->color('info'),
        ];
    }
}
