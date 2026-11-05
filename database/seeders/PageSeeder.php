<?php

namespace Database\Seeders;

use App\Models\Page;
use App\Models\User;
use Illuminate\Database\Seeder;

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
                'title' => [
                    'id' => 'Tentang Kami',
                    'en' => 'About Us',
                ],
                'slug' => 'tentang-kami',
                'content' => [
                    'id' => '<h2>Profil Instansi</h2><p>Kami adalah instansi pemerintah yang bertugas menyelenggarakan urusan komunikasi, informatika, dan pelayanan informasi publik bagi masyarakat secara transparan, profesional, dan akuntabel.</p>',
                    'en' => '<h2>Agency Profile</h2><p>We are a government institution tasked with managing communications, informatics, and public information services for the community in a transparent, professional, and accountable manner.</p>',
                ],
                'status' => 'published',
                'sort_order' => 1,
                'show_in_menu' => true,
            ],
            [
                'title' => [
                    'id' => 'Visi dan Misi',
                    'en' => 'Vision and Mission',
                ],
                'slug' => 'visi-dan-misi',
                'content' => [
                    'id' => '<h2>Visi</h2><p>Terwujudnya tata kelola pemerintahan berbasis digital yang transparan dan melayani masyarakat seutuhnya.</p><h2>Misi</h2><ol><li>Meningkatkan kualitas infrastruktur telekomunikasi dan informasi.</li><li>Menyelenggarakan pelayanan informasi publik yang cepat, tepat, dan mudah diakses.</li><li>Mengembangkan kompetensi SDM dalam pemanfaatan teknologi informasi.</li></ol>',
                    'en' => '<h2>Vision</h2><p>Realizing digital-based governance that is transparent and serves the entire community.</p><h2>Mission</h2><ol><li>Improve the quality of telecommunications and information infrastructure.</li><li>Deliver fast, accurate, and easily accessible public information services.</li><li>Develop human resource competencies in information technology utilization.</li></ol>',
                ],
                'status' => 'published',
                'sort_order' => 2,
                'show_in_menu' => true,
            ],
            [
                'title' => [
                    'id' => 'Struktur Organisasi',
                    'en' => 'Organizational Structure',
                ],
                'slug' => 'struktur-organisasi',
                'content' => [
                    'id' => '<h2>Bagan Struktur Organisasi</h2><p>Struktur kepemimpinan dan pembagian divisi kerja yang bertanggung jawab dalam operasional dan pelayanan harian instansi.</p>',
                    'en' => '<h2>Organizational Structure Chart</h2><p>Leadership hierarchy and division of labor responsible for daily operations and agency services.</p>',
                ],
                'status' => 'published',
                'sort_order' => 3,
                'show_in_menu' => true,
            ],
            [
                'title' => [
                    'id' => 'Maklumat Pelayanan',
                    'en' => 'Service Declaration',
                ],
                'slug' => 'maklumat-pelayanan',
                'content' => [
                    'id' => '<h2>Maklumat Pelayanan</h2><p>"Dengan ini kami menyatakan sanggup menyelenggarakan pelayanan sesuai standar pelayanan yang telah ditetapkan dan apabila tidak menepati janji ini, kami siap menerima sanksi sesuai peraturan perundang-undangan yang berlaku."</p>',
                    'en' => '<h2>Service Declaration</h2><p>"We hereby declare our commitment to deliver services in accordance with established service standards, and should we fail to honor this commitment, we are prepared to accept sanctions under applicable laws and regulations."</p>',
                ],
                'status' => 'published',
                'sort_order' => 4,
                'show_in_menu' => false,
            ],
        ];

        foreach ($pages as $p) {
            Page::updateOrCreate(
                ['slug' => $p['slug']],
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
