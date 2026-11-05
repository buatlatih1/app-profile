<?php

namespace Database\Seeders;

use App\Models\Category;
use Illuminate\Database\Seeder;

class CategorySeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $categories = [
            [
                'name' => [
                    'id' => 'Berita Utama',
                    'en' => 'Main News',
                ],
                'description' => [
                    'id' => 'Kumpulan berita terkini dan utama seputar kegiatan instansi.',
                    'en' => 'Collection of the latest and top news regarding agency activities.',
                ],
                'slug' => 'berita-utama',
                'icon' => 'newspaper',
                'sort_order' => 1,
            ],
            [
                'name' => [
                    'id' => 'Pengumuman',
                    'en' => 'Announcements',
                ],
                'description' => [
                    'id' => 'Pengumuman resmi kedinasan dan informasi penting untuk publik.',
                    'en' => 'Official service announcements and important public information.',
                ],
                'slug' => 'pengumuman',
                'icon' => 'megaphone',
                'sort_order' => 2,
            ],
            [
                'name' => [
                    'id' => 'Artikel & Edukasi',
                    'en' => 'Articles & Education',
                ],
                'description' => [
                    'id' => 'Artikel informatif, tips, dan wawasan edukasi kemasyarakatan.',
                    'en' => 'Informative articles, tips, and public education insights.',
                ],
                'slug' => 'artikel-edukasi',
                'icon' => 'book-open',
                'sort_order' => 3,
            ],
            [
                'name' => [
                    'id' => 'Kegiatan & Sosialisasi',
                    'en' => 'Activities & Outreach',
                ],
                'description' => [
                    'id' => 'Dokumentasi dan laporan kegiatan sosialisasi program kerja.',
                    'en' => 'Documentation and reports on work program socialization activities.',
                ],
                'slug' => 'kegiatan-sosialisasi',
                'icon' => 'calendar-days',
                'sort_order' => 4,
            ],
            [
                'name' => [
                    'id' => 'Transparansi Kinerja',
                    'en' => 'Performance Transparency',
                ],
                'description' => [
                    'id' => 'Laporan akuntabilitas, data statistik, dan publikasi keterbukaan informasi.',
                    'en' => 'Accountability reports, statistical data, and public disclosure publications.',
                ],
                'slug' => 'transparansi-kinerja',
                'icon' => 'chart-bar',
                'sort_order' => 5,
            ],
        ];

        foreach ($categories as $cat) {
            Category::updateOrCreate(
                ['slug' => $cat['slug']],
                [
                    'name' => $cat['name'],
                    'description' => $cat['description'],
                    'icon' => $cat['icon'],
                    'sort_order' => $cat['sort_order'],
                    'is_active' => true,
                ]
            );
        }
    }
}
