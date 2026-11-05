<?php

namespace Database\Seeders;

use App\Enums\PostStatus;
use App\Models\Category;
use App\Models\Post;
use App\Models\User;
use Illuminate\Database\Seeder;

class PostSeeder extends Seeder
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

        $posts = [
            [
                'title' => [
                    'id' => 'Peluncuran Aplikasi Layanan Digital Masyarakat Terpadu',
                    'en' => 'Launch of the Integrated Public Digital Service Application',
                ],
                'slug' => 'peluncuran-aplikasi-layanan-digital-masyarakat-terpadu',
                'category_slug' => 'berita-utama',
                'summary' => [
                    'id' => 'Pemerintah resmi merilis portal aplikasi layanan terpadu guna mempercepat dan memudahkan urusan administrasi warga.',
                    'en' => 'The government officially launched the integrated service application portal to speed up and simplify citizens administrative affairs.',
                ],
                'content' => [
                    'id' => '<p>Dalam rangka mewujudkan transformasi digital di lingkungan pemerintahan dan memberikan pelayanan prima kepada seluruh lapisan masyarakat, hari ini secara resmi diluncurkan Aplikasi Layanan Digital Terpadu.</p><p>Aplikasi ini mengintegrasikan berbagai layanan administrasi, publikasi informasi berkala, hingga saluran pengaduan dan pertanyaan publik secara real-time. Diharapkan dengan hadirnya inovasi ini, transparansi dan efisiensi birokrasi dapat semakin meningkat.</p>',
                    'en' => '<p>In order to realize digital transformation within the government environment and provide excellent service to all levels of society, the Integrated Digital Service Application was officially launched today.</p><p>This application integrates various administrative services, periodic information publications, as well as real-time public inquiry and grievance channels. It is hoped that this innovation will increase bureaucratic transparency and efficiency.</p>',
                ],
                'image' => 'posts/post-1.jpg',
                'status' => PostStatus::Published,
                'is_featured' => true,
                'view_count' => 342,
            ],
            [
                'title' => [
                    'id' => 'Jadwal Pemeliharaan Server Portal Resmi Bulan Ini',
                    'en' => 'Official Portal Server Maintenance Schedule for This Month',
                ],
                'slug' => 'jadwal-pemeliharaan-server-portal-resmi-bulan-ini',
                'category_slug' => 'pengumuman',
                'summary' => [
                    'id' => 'Diberitahukan kepada seluruh pengguna bahwa akan dilakukan pemeliharaan sistem pada akhir pekan ini.',
                    'en' => 'All users are hereby notified that system maintenance will be carried out this weekend.',
                ],
                'content' => [
                    'id' => '<p>Sehubungan dengan peningkatan kapasitas infrastruktur server cloud, kami menginformasikan bahwa akan dilaksanakan pemeliharaan rutin pada hari Sabtu mulai pukul 23:00 WIB hingga Minggu pukul 04:00 WIB.</p><p>Selama periode pemeliharaan tersebut, beberapa layanan interaktif mungkin mengalami penurunan performa sementara. Kami memohon maaf atas ketidaknyamanan yang terjadi.</p>',
                    'en' => '<p>Due to cloud server infrastructure capacity upgrades, we inform you that routine maintenance will take place on Saturday from 23:00 WIB until Sunday at 04:00 WIB.</p><p>During this maintenance period, some interactive services may experience temporary degradation. We apologize for any inconvenience caused.</p>',
                ],
                'image' => 'posts/post-2.jpg',
                'status' => PostStatus::Published,
                'is_featured' => false,
                'view_count' => 125,
            ],
            [
                'title' => [
                    'id' => '5 Tips Aman Menjaga Data Pribadi di Era Digital',
                    'en' => '5 Safe Tips for Protecting Personal Data in the Digital Era',
                ],
                'slug' => '5-tips-aman-menjaga-data-pribadi-di-era-digital',
                'category_slug' => 'artikel-edukasi',
                'summary' => [
                    'id' => 'Panduan penting bagi masyarakat dalam melindungi privasi dan keamanan identitas diri saat berselancar di dunia maya.',
                    'en' => 'An essential guide for the public in protecting privacy and personal identity security while surfing cyberspace.',
                ],
                'content' => [
                    'id' => '<p>Keamanan siber merupakan tanggung jawab bersama. Berikut beberapa tips sederhana yang dapat Anda terapkan sehari-hari:</p><ul><li>Gunakan password yang kuat dan aktifkan verifikasi dua langkah (2FA).</li><li>Hindari membagikan data sensitif seperti NIK atau OTP kepada pihak asing.</li><li>Selalu periksa keaslian URL sebelum memasukkan akun credential.</li></ul>',
                    'en' => '<p>Cyber security is a shared responsibility. Here are some simple tips you can implement everyday:</p><ul><li>Use strong passwords and enable two-factor authentication (2FA).</li><li>Avoid sharing sensitive data such as national ID or OTPs with unknown parties.</li><li>Always verify URL authenticity before entering account credentials.</li></ul>',
                ],
                'image' => 'posts/post-3.jpg',
                'status' => PostStatus::Published,
                'is_featured' => true,
                'view_count' => 512,
            ],
            [
                'title' => [
                    'id' => 'Sosialisasi Literasi Digital untuk Generasi Muda',
                    'en' => 'Digital Literacy Outreach for the Younger Generation',
                ],
                'slug' => 'sosialisasi-literasi-digital-untuk-generasi-muda',
                'category_slug' => 'kegiatan-sosialisasi',
                'summary' => [
                    'id' => 'Kegiatan workshop edukasi literasi digital sukses digelar bersama ratusan pelajar dan mahasiswa.',
                    'en' => 'A digital literacy educational workshop was successfully held with hundreds of students.',
                ],
                'content' => [
                    'id' => '<p>Ratusan peserta dari kalangan generasi muda antusias mengikuti workshop literasi teknologi dan etika bermedia sosial yang diselenggarakan di aula utama pada hari Rabu lalu.</p>',
                    'en' => '<p>Hundreds of young participants enthusiastically attended the technology literacy and social media ethics workshop held in the main hall last Wednesday.</p>',
                ],
                'image' => 'posts/post-4.jpg',
                'status' => PostStatus::Published,
                'is_featured' => false,
                'view_count' => 89,
            ],
            [
                'title' => [
                    'id' => 'Laporan Kinerja Pelayanan Publik Triwulan Ketiga Tahun Ini',
                    'en' => 'Third Quarter Public Service Performance Report for This Year',
                ],
                'slug' => 'laporan-kinerja-pelayanan-publik-triwulan-ketiga-tahun-ini',
                'category_slug' => 'transparansi-kinerja',
                'summary' => [
                    'id' => 'Publikasi capaian target kepuasan masyarakat terhadap layanan publik mencapai skor indeks 89.5%.',
                    'en' => 'Publication of public satisfaction achievement target for public services reaching an index score of 89.5%.',
                ],
                'content' => [
                    'id' => '<p>Berdasarkan survei kepuasan masyarakat (SKM) triwulan ketiga, tingkat kepuasan layanan publik mencapai indeks memuaskan 89.5%. Hasil lengkap dan rincian metodologi dapat diunduh pada lampiran dokumen transparansi.</p>',
                    'en' => '<p>Based on the third quarter public satisfaction survey, the public service satisfaction level reached a satisfactory index of 89.5%. Full results and methodology details can be downloaded from the transparency document attachment.</p>',
                ],
                'image' => 'posts/post-5.jpg',
                'status' => PostStatus::Published,
                'is_featured' => false,
                'view_count' => 210,
            ],
        ];

        foreach ($posts as $item) {
            $category = Category::where('slug', $item['category_slug'])->first();
            if ($category) {
                Post::updateOrCreate(
                    ['slug' => $item['slug']],
                    [
                        'user_id' => $admin->id,
                        'category_id' => $category->id,
                        'title' => $item['title'],
                        'summary' => $item['summary'],
                        'content' => $item['content'],
                        'image' => $item['image'],
                        'status' => $item['status'],
                        'is_featured' => $item['is_featured'],
                        'view_count' => $item['view_count'],
                        'published_at' => now()->subDays(rand(1, 10)),
                    ]
                );
            }
        }
    }
}
