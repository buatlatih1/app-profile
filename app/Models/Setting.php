<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Cache;

#[Fillable(['group', 'key', 'value', 'type'])]
class Setting extends Model
{
    use HasFactory;

    /**
     * Cache key for settings.
     */
    public const CACHE_KEY = 'app_settings_all';

    protected static function booted(): void
    {
        static::saved(function () {
            Cache::forget(self::CACHE_KEY);
        });

        static::deleted(function () {
            Cache::forget(self::CACHE_KEY);
        });
    }

    /**
     * Get a setting by key.
     */
    public static function get(string $key, mixed $default = null): mixed
    {
        $settings = Cache::rememberForever(self::CACHE_KEY, function () {
            return static::pluck('value', 'key')->all();
        });

        return $settings[$key] ?? $default;
    }

    /**
     * Set a setting value.
     */
    public static function set(string $key, mixed $value, string $group = 'general', string $type = 'text'): self
    {
        $setting = static::updateOrCreate(
            ['key' => $key],
            [
                'group' => $group,
                'value' => is_array($value) ? json_encode($value) : $value,
                'type' => $type,
            ]
        );

        Cache::forget(self::CACHE_KEY);

        return $setting;
    }

    /**
     * Get all settings grouped by group.
     *
     * @return array<string, array<string, mixed>>
     */
    public static function getGrouped(): array
    {
        $records = static::all();
        $grouped = [];

        foreach ($records as $record) {
            $grouped[$record->group][$record->key] = $record->value;
        }

        return $grouped;
    }
}
