<?php

namespace App\Providers;

use BezhanSalleh\LanguageSwitch\LanguageSwitch;
use Carbon\Carbon;
use Illuminate\Support\ServiceProvider;
use Spatie\Translatable\Facades\Translatable;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        //
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        Carbon::setLocale(config('app.locale', 'id'));

        Translatable::fallback(
            fallbackLocale: config('app.fallback_locale', 'id'),
            fallbackAny: true
        );

        LanguageSwitch::configureUsing(function (LanguageSwitch $switch): void {
            $switch
                ->locales(['id', 'en'])
                ->labels([
                    'id' => 'Bahasa Indonesia',
                    'en' => 'English',
                ])
                ->circular();
        });
    }
}
