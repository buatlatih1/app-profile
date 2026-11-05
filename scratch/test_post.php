<?php

require 'vendor/autoload.php';
$app = require_once 'bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

$post = \App\Models\Post::where('slug', 'like', 'detail-berita%')->first();
echo "fallback_locale: " . var_export(config('app.fallback_locale'), true) . PHP_EOL;
echo "translated locales: " . json_encode($post->getTranslatedLocales('title')) . PHP_EOL;
echo "title en with fallback true: " . var_export($post->getTranslation('title', 'en', true), true) . PHP_EOL;
echo "app(Translatable::class)->fallbackLocale: " . var_export(app(\Spatie\Translatable\Translatable::class)->fallbackLocale, true) . PHP_EOL;
