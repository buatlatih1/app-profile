<?php

namespace Database\Seeders;

use App\Models\Menu;
use App\Models\MenuItem;
use Illuminate\Database\Seeder;

class MenuSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $headerMenu = Menu::updateOrCreate(
            ['location' => 'header'],
            [
                'name' => 'Menu Utama (Header)',
                'is_active' => true,
            ]
        );

        $footerMenu = Menu::updateOrCreate(
            ['location' => 'footer'],
            [
                'name' => 'Menu Bawah (Footer)',
                'is_active' => true,
            ]
        );

        // Header Items
        $items = [
            ['label' => ['id' => 'Beranda', 'en' => 'Home'], 'url' => '/', 'type' => 'custom', 'sort_order' => 1],
            ['label' => ['id' => 'Berita', 'en' => 'News'], 'url' => '/posts', 'type' => 'custom', 'sort_order' => 2],
            ['label' => ['id' => 'Tentang Kami', 'en' => 'About Us'], 'url' => '/page/tentang-kami', 'type' => 'page', 'sort_order' => 3],
            ['label' => ['id' => 'Visi & Misi', 'en' => 'Vision & Mission'], 'url' => '/page/visi-dan-misi', 'type' => 'page', 'sort_order' => 4],
            ['label' => ['id' => 'Layanan Pertanyaan', 'en' => 'Inquiries'], 'url' => '/questions', 'type' => 'custom', 'sort_order' => 5],
            ['label' => ['id' => 'FAQ', 'en' => 'FAQ'], 'url' => '/faqs', 'type' => 'custom', 'sort_order' => 6],
        ];

        foreach ($items as $item) {
            MenuItem::updateOrCreate(
                ['menu_id' => $headerMenu->id, 'sort_order' => $item['sort_order']],
                [
                    'label' => $item['label'],
                    'url' => $item['url'],
                    'type' => $item['type'],
                    'sort_order' => $item['sort_order'],
                    'is_active' => true,
                ]
            );
        }

        // Footer Items
        $footerItems = [
            ['label' => ['id' => 'Tentang Kami', 'en' => 'About Us'], 'url' => '/page/tentang-kami', 'type' => 'page', 'sort_order' => 1],
            ['label' => ['id' => 'Maklumat Pelayanan', 'en' => 'Service Declaration'], 'url' => '/page/maklumat-pelayanan', 'type' => 'page', 'sort_order' => 2],
            ['label' => ['id' => 'Kontak Kami', 'en' => 'Contact Us'], 'url' => '/contact', 'type' => 'custom', 'sort_order' => 3],
        ];

        foreach ($footerItems as $fItem) {
            MenuItem::updateOrCreate(
                ['menu_id' => $footerMenu->id, 'sort_order' => $fItem['sort_order']],
                [
                    'label' => $fItem['label'],
                    'url' => $fItem['url'],
                    'type' => $fItem['type'],
                    'sort_order' => $fItem['sort_order'],
                    'is_active' => true,
                ]
            );
        }
    }
}
