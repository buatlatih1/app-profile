<?php

namespace Database\Seeders;

use App\Models\Page;
use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Str;

class PageSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $admin = User::first();
        if (! $admin) {
            return;
        }

        $pages = [
            [
                'title' => 'Tentang Kami',
                'content' => '<h2>Profil Instansi</h2><p>Kami adalah instansi pemerintah yang bertugas menyelenggarakan urusan komunikasi, informatika, dan pelayanan informasi publik bagi masyarakat secara transparan, profesional, dan akuntabel.</p>',
                'status' => 'published',
                'sort_order' => 1,
                'show_in_menu' => true,
            ],
            [
                'title' => 'Visi dan Misi',
                'content' => '<h2>Visi</h2><p>Terwujudnya tata kelola pemerintahan berbasis digital yang transparan dan melayani masyarakat seutuhnya.</p><h2>Misi</h2><ol><li>Meningkatkan kualitas infrastruktur telekomunikasi dan informasi.</li><li>Menyelenggarakan pelayanan informasi publik yang cepat, tepat, dan mudah diakses.</li><li>Mengembangkan kompetensi SDM dalam pemanfaatan teknologi informasi.</li></ol>',
                'status' => 'published',
                'sort_order' => 2,
                'show_in_menu' => true,
            ],
            [
                'title' => 'Struktur Organisasi',
                'content' => '<h2>Bagan Struktur Organisasi</h2><p>Struktur kepemimpinan dan pembagian divisi kerja yang bertanggung jawab dalam operasional dan pelayanan harian instansi.</p>',
                'status' => 'published',
                'sort_order' => 3,
                'show_in_menu' => true,
            ],
            [
                'title' => 'Maklumat Pelayanan',
                'content' => '<h2>Maklumat Pelayanan</h2><p>"Dengan ini kami menyatakan sanggup menyelenggarakan pelayanan sesuai standar pelayanan yang telah ditetapkan dan apabila tidak menepati janji ini, kami siap menerima sanksi sesuai peraturan perundang-undangan yang berlaku."</p>',
                'status' => 'published',
                'sort_order' => 4,
                'show_in_menu' => false,
            ],
        ];

        foreach ($pages as $p) {
            Page::updateOrCreate(
                ['slug' => Str::slug($p['title'])],
                [
                    'user_id' => $admin->id,
                    'title' => $p['title'],
                    'content' => $p['content'],
                    'status' => $p['status'],
                    'sort_order' => $p['sort_order'],
                    'show_in_menu' => $p['show_in_menu'],
                ]
            );
        }
    }
}
