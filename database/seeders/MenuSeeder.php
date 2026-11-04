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
            ['label' => 'Beranda', 'url' => '/', 'type' => 'custom', 'sort_order' => 1],
            ['label' => 'Berita', 'url' => '/posts', 'type' => 'custom', 'sort_order' => 2],
            ['label' => 'Tentang Kami', 'url' => '/page/tentang-kami', 'type' => 'page', 'sort_order' => 3],
            ['label' => 'Visi & Misi', 'url' => '/page/visi-dan-misi', 'type' => 'page', 'sort_order' => 4],
            ['label' => 'Layanan Pertanyaan', 'url' => '/questions', 'type' => 'custom', 'sort_order' => 5],
            ['label' => 'FAQ', 'url' => '/faqs', 'type' => 'custom', 'sort_order' => 6],
        ];

        foreach ($items as $item) {
            MenuItem::updateOrCreate(
                ['menu_id' => $headerMenu->id, 'label' => $item['label']],
                [
                    'url' => $item['url'],
                    'type' => $item['type'],
                    'sort_order' => $item['sort_order'],
                    'is_active' => true,
                ]
            );
        }

        // Footer Items
        $footerItems = [
            ['label' => 'Tentang Kami', 'url' => '/page/tentang-kami', 'type' => 'page', 'sort_order' => 1],
            ['label' => 'Maklumat Pelayanan', 'url' => '/page/maklumat-pelayanan', 'type' => 'page', 'sort_order' => 2],
            ['label' => 'Kontak Kami', 'url' => '/contact', 'type' => 'custom', 'sort_order' => 3],
        ];

        foreach ($footerItems as $fItem) {
            MenuItem::updateOrCreate(
                ['menu_id' => $footerMenu->id, 'label' => $fItem['label']],
                [
                    'url' => $fItem['url'],
                    'type' => $fItem['type'],
                    'sort_order' => $fItem['sort_order'],
                    'is_active' => true,
                ]
            );
        }
    }
}
