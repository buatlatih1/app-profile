<?php

namespace Database\Seeders;

use App\Models\Slide;
use Illuminate\Database\Seeder;

class SlideSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $slides = [
            [
                'title' => 'Selamat Datang di Portal Resmi Pelayanan Publik',
                'description' => 'Akses informasi kedinasan, berita terkini, dan sampaikan pertanyaan serta aspirasi secara langsung.',
                'image' => 'slides/slide-1.jpg',
                'link_url' => '/page/tentang-kami',
                'sort_order' => 1,
                'is_active' => true,
            ],
            [
                'title' => 'Layanan Aspirasi & Tanya Jawab Masyarakat',
                'description' => 'Kami siap mendengarkan pertanyaan dan masukan Anda untuk kemajuan pelayanan publik yang lebih baik.',
                'image' => 'slides/slide-2.jpg',
                'link_url' => '/questions',
                'sort_order' => 2,
                'is_active' => true,
            ],
            [
                'title' => 'Transparansi dan Akuntabilitas Informasi',
                'description' => 'Cek laporan kinerja berkala dan dokumen keterbukaan informasi publik kapan saja.',
                'image' => 'slides/slide-3.jpg',
                'link_url' => '/posts',
                'sort_order' => 3,
                'is_active' => true,
            ],
        ];

        foreach ($slides as $slide) {
            Slide::updateOrCreate(
                ['title' => $slide['title']],
                $slide
            );
        }
    }
}
