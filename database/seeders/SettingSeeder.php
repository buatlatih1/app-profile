<?php

namespace Database\Seeders;

use App\Models\Setting;
use Illuminate\Database\Seeder;

class SettingSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $settings = [
            // General
            ['group' => 'general', 'key' => 'site_name', 'value' => 'Dinas Komunikasi dan Informatika', 'type' => 'text'],
            ['group' => 'general', 'key' => 'site_tagline', 'value' => 'Mewujudkan Pelayanan Publik yang Transparan dan Akuntabel', 'type' => 'text'],
            ['group' => 'general', 'key' => 'site_description', 'value' => 'Portal resmi layanan informasi dan penyampaian aspirasi masyarakat.', 'type' => 'textarea'],
            ['group' => 'general', 'key' => 'site_logo', 'value' => null, 'type' => 'image'],
            ['group' => 'general', 'key' => 'site_favicon', 'value' => null, 'type' => 'image'],

            // Contact
            ['group' => 'contact', 'key' => 'contact_email', 'value' => 'kontak@instansi.go.id', 'type' => 'text'],
            ['group' => 'contact', 'key' => 'contact_phone', 'value' => '(021) 12345678', 'type' => 'text'],
            ['group' => 'contact', 'key' => 'contact_whatsapp', 'value' => '081234567890', 'type' => 'text'],
            ['group' => 'contact', 'key' => 'contact_address', 'value' => 'Jl. Merdeka No. 10, Jakarta Pusat, DKI Jakarta', 'type' => 'textarea'],

            // Social Media
            ['group' => 'social', 'key' => 'social_facebook', 'value' => 'https://facebook.com/instansiofficial', 'type' => 'text'],
            ['group' => 'social', 'key' => 'social_instagram', 'value' => 'https://instagram.com/instansiofficial', 'type' => 'text'],
            ['group' => 'social', 'key' => 'social_twitter', 'value' => 'https://x.com/instansiofficial', 'type' => 'text'],
            ['group' => 'social', 'key' => 'social_youtube', 'value' => 'https://youtube.com/@instansiofficial', 'type' => 'text'],
        ];

        foreach ($settings as $setting) {
            Setting::updateOrCreate(
                ['key' => $setting['key']],
                $setting
            );
        }
    }
}
