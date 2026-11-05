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
                'sort_order' => 1,
                'title' => [
                    'id' => 'Selamat Datang di Portal Resmi Pelayanan Publik',
                    'en' => 'Welcome to the Official Public Service Portal',
                ],
                'description' => [
                    'id' => 'Akses informasi kedinasan, berita terkini, dan sampaikan pertanyaan serta aspirasi secara langsung.',
                    'en' => 'Access official information, latest news, and submit questions and feedback directly.',
                ],
                'image' => 'slides/slide-1.jpg',
                'link_url' => '/page/tentang-kami',
                'is_active' => true,
            ],
            [
                'sort_order' => 2,
                'title' => [
                    'id' => 'Layanan Aspirasi & Tanya Jawab Masyarakat',
                    'en' => 'Community Feedback & FAQ Service',
                ],
                'description' => [
                    'id' => 'Kami siap mendengarkan pertanyaan dan masukan Anda untuk kemajuan pelayanan publik yang lebih baik.',
                    'en' => 'We are ready to hear your questions and suggestions for better public services.',
                ],
                'image' => 'slides/slide-2.jpg',
                'link_url' => '/questions',
                'is_active' => true,
            ],
            [
                'sort_order' => 3,
                'title' => [
                    'id' => 'Transparansi dan Akuntabilitas Informasi',
                    'en' => 'Information Transparency and Accountability',
                ],
                'description' => [
                    'id' => 'Cek laporan kinerja berkala dan dokumen keterbukaan informasi publik kapan saja.',
                    'en' => 'Check periodic performance reports and public disclosure documents anytime.',
                ],
                'image' => 'slides/slide-3.jpg',
                'link_url' => '/posts',
                'is_active' => true,
            ],
        ];

        foreach ($slides as $slide) {
            Slide::updateOrCreate(
                ['sort_order' => $slide['sort_order']],
                $slide
            );
        }
    }
}
