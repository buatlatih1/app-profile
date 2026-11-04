<?php

namespace Database\Seeders;

use App\Models\Category;
use Illuminate\Database\Seeder;
use Illuminate\Support\Str;

class CategorySeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $categories = [
            ['name' => 'Berita Utama', 'description' => 'Kumpulan berita terkini dan utama seputar kegiatan instansi.', 'icon' => 'newspaper', 'sort_order' => 1],
            ['name' => 'Pengumuman', 'description' => 'Pengumuman resmi kedinasan dan informasi penting untuk publik.', 'icon' => 'megaphone', 'sort_order' => 2],
            ['name' => 'Artikel & Edukasi', 'description' => 'Artikel informatif, tips, dan wawasan edukasi kemasyarakatan.', 'icon' => 'book-open', 'sort_order' => 3],
            ['name' => 'Kegiatan & Sosialisasi', 'description' => 'Dokumentasi dan laporan kegiatan sosialisasi program kerja.', 'icon' => 'calendar-days', 'sort_order' => 4],
            ['name' => 'Transparansi Kinerja', 'description' => 'Laporan akuntabilitas, data statistik, dan publikasi keterbukaan informasi.', 'icon' => 'chart-bar', 'sort_order' => 5],
        ];

        foreach ($categories as $cat) {
            Category::updateOrCreate(
                ['slug' => Str::slug($cat['name'])],
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
