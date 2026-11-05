<?php

use App\Http\Controllers\Api\V1\CategoryController;
use App\Http\Controllers\Api\V1\FaqController;
use App\Http\Controllers\Api\V1\MenuController;
use App\Http\Controllers\Api\V1\PageController;
use App\Http\Controllers\Api\V1\PostController;
use App\Http\Controllers\Api\V1\QuestionController;
use App\Http\Controllers\Api\V1\QuestionTopicController;
use App\Http\Controllers\Api\V1\SettingController;
use App\Http\Controllers\Api\V1\SlideController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\Storage;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

Route::prefix('v1')->name('api.v1.')->group(function () {
    // CMS Module
    Route::get('/posts', [PostController::class, 'index'])->name('posts.index');
    Route::get('/posts/{slug}', [PostController::class, 'show'])->name('posts.show');
    Route::get('/categories', [CategoryController::class, 'index'])->name('categories.index');
    Route::get('/categories/{slug}', [CategoryController::class, 'show'])->name('categories.show');
    Route::get('/pages', [PageController::class, 'index'])->name('pages.index');
    Route::get('/pages/{slug}', [PageController::class, 'show'])->name('pages.show');
    Route::get('/slides', [SlideController::class, 'index'])->name('slides.index');
    Route::get('/menus/{location}', [MenuController::class, 'show'])->name('menus.show');
    Route::get('/settings', [SettingController::class, 'index'])->name('settings.index');

    // Citizen Inquiry & FAQ Module
    Route::get('/question-topics', [QuestionTopicController::class, 'index'])->name('question-topics.index');
    Route::get('/questions', [QuestionController::class, 'index'])->name('questions.index');
    Route::post('/questions', [QuestionController::class, 'store'])
        ->middleware('throttle:10,1')
        ->name('questions.store');
    Route::get('/faqs', [FaqController::class, 'index'])->name('faqs.index');

    // Media / Storage file serving with full CORS headers & dynamic fallback
    Route::get('/storage/{path}', function (string $path) {
        $disk = Storage::disk('public');
        if ($disk->exists($path)) {
            return response()->file($disk->path($path), [
                'Access-Control-Allow-Origin' => '*',
                'Access-Control-Allow-Methods' => 'GET, OPTIONS',
                'Access-Control-Allow-Headers' => '*',
                'Cache-Control' => 'public, max-age=86400',
            ]);
        }

        // Return a clean fallback SVG placeholder with CORS
        $label = htmlspecialchars(str_replace(['-', '_'], ' ', ucwords(pathinfo($path, PATHINFO_FILENAME))));
        $svg = <<<SVG
        <svg xmlns="http://www.w3.org/2000/svg" width="800" height="450" viewBox="0 0 800 450">
            <defs>
                <linearGradient id="g" x1="0%" y1="0%" x2="100%" y2="100%">
                    <stop offset="0%" stop-color="#0F766E"/>
                    <stop offset="100%" stop-color="#1E293B"/>
                </linearGradient>
            </defs>
            <rect width="100%" height="100%" fill="url(#g)"/>
            <circle cx="700" cy="80" r="140" fill="white" opacity="0.08"/>
            <circle cx="100" cy="380" r="180" fill="white" opacity="0.05"/>
            <text x="50%" y="48%" font-family="Segoe UI, sans-serif" font-size="28" font-weight="bold" fill="white" text-anchor="middle">{$label}</text>
            <text x="50%" y="58%" font-family="Segoe UI, sans-serif" font-size="16" fill="#99F6E4" text-anchor="middle">Portal Informasi &amp; Layanan Publik</text>
        </svg>
        SVG;

        return response($svg, 200, [
            'Content-Type' => 'image/svg+xml',
            'Access-Control-Allow-Origin' => '*',
            'Access-Control-Allow-Methods' => 'GET, OPTIONS',
            'Access-Control-Allow-Headers' => '*',
            'Cache-Control' => 'public, max-age=86400',
        ]);
    })->where('path', '.*')->name('storage.file');

    // Media / Storage file serving with full CORS headers & dynamic fallback
    Route::get('/storage/{path}', function (string $path) {
        $disk = \Illuminate\Support\Facades\Storage::disk('public');
        if ($disk->exists($path)) {
            return response()->file($disk->path($path), [
                'Access-Control-Allow-Origin' => '*',
                'Access-Control-Allow-Methods' => 'GET, OPTIONS',
                'Access-Control-Allow-Headers' => '*',
                'Cache-Control' => 'public, max-age=86400',
            ]);
        }

        // Return a clean fallback SVG placeholder with CORS
        $label = htmlspecialchars(str_replace(['-', '_'], ' ', ucwords(pathinfo($path, PATHINFO_FILENAME))));
        $svg = <<<SVG
        <svg xmlns="http://www.w3.org/2000/svg" width="800" height="450" viewBox="0 0 800 450">
            <defs>
                <linearGradient id="g" x1="0%" y1="0%" x2="100%" y2="100%">
                    <stop offset="0%" stop-color="#0F766E"/>
                    <stop offset="100%" stop-color="#1E293B"/>
                </linearGradient>
            </defs>
            <rect width="100%" height="100%" fill="url(#g)"/>
            <circle cx="700" cy="80" r="140" fill="white" opacity="0.08"/>
            <circle cx="100" cy="380" r="180" fill="white" opacity="0.05"/>
            <text x="50%" y="48%" font-family="Segoe UI, sans-serif" font-size="28" font-weight="bold" fill="white" text-anchor="middle">{$label}</text>
            <text x="50%" y="58%" font-family="Segoe UI, sans-serif" font-size="16" fill="#99F6E4" text-anchor="middle">Portal Informasi &amp; Layanan Publik</text>
        </svg>
        SVG;

        return response($svg, 200, [
            'Content-Type' => 'image/svg+xml',
            'Access-Control-Allow-Origin' => '*',
            'Access-Control-Allow-Methods' => 'GET, OPTIONS',
            'Access-Control-Allow-Headers' => '*',
            'Cache-Control' => 'public, max-age=86400',
        ]);
    })->where('path', '.*')->name('storage.file');
});
