<?php

namespace Database\Seeders;

use App\Enums\PostStatus;
use App\Models\Category;
use App\Models\Post;
use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Str;

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
                'title' => 'Peluncuran Aplikasi Layanan Digital Masyarakat Terpadu',
                'category_slug' => 'berita-utama',
                'summary' => 'Pemerintah resmi merilis portal aplikasi layanan terpadu guna mempercepat dan memudahkan urusan administrasi warga.',
                'content' => '<p>Dalam rangka mewujudkan transformasi digital di lingkungan pemerintahan dan memberikan pelayanan prima kepada seluruh lapisan masyarakat, hari ini secara resmi diluncurkan Aplikasi Layanan Digital Terpadu.</p><p>Aplikasi ini mengintegrasikan berbagai layanan administrasi, publikasi informasi berkala, hingga saluran pengaduan dan pertanyaan publik secara real-time. Diharapkan dengan hadirnya inovasi ini, transparansi dan efisiensi birokrasi dapat semakin meningkat.</p>',
                'status' => PostStatus::Published,
                'is_featured' => true,
                'view_count' => 342,
            ],
            [
                'title' => 'Jadwal Pemeliharaan Server Portal Resmi Bulan Ini',
                'category_slug' => 'pengumuman',
                'summary' => 'Diberitahukan kepada seluruh pengguna bahwa akan dilakukan pemeliharaan sistem pada akhir pekan ini.',
                'content' => '<p>Sehubungan dengan peningkatan kapasitas infrastruktur server cloud, kami menginformasikan bahwa akan dilaksanakan pemeliharaan rutin pada hari Sabtu mulai pukul 23:00 WIB hingga Minggu pukul 04:00 WIB.</p><p>Selama periode pemeliharaan tersebut, beberapa layanan interaktif mungkin mengalami penurunan performa sementara. Kami memohon maaf atas ketidaknyamanan yang terjadi.</p>',
                'status' => PostStatus::Published,
                'is_featured' => false,
                'view_count' => 125,
            ],
            [
                'title' => '5 Tips Aman Menjaga Data Pribadi di Era Digital',
                'category_slug' => 'artikel-edukasi',
                'summary' => 'Panduan penting bagi masyarakat dalam melindungi privasi dan keamanan identitas diri saat berselancar di dunia maya.',
                'content' => '<p>Keamanan siber merupakan tanggung jawab bersama. Berikut beberapa tips sederhana yang dapat Anda terapkan sehari-hari:</p><ul><li>Gunakan password yang kuat dan aktifkan verifikasi dua langkah (2FA).</li><li>Hindari membagikan data sensitif seperti NIK atau OTP kepada pihak asing.</li><li>Selalu periksa keaslian URL sebelum memasukkan akun credential.</li></ul>',
                'status' => PostStatus::Published,
                'is_featured' => true,
                'view_count' => 512,
            ],
            [
                'title' => 'Sosialisasi Literasi Digital untuk Generasi Muda',
                'category_slug' => 'kegiatan-sosialisasi',
                'summary' => 'Kegiatan workshop edukasi literasi digital sukses digelar bersama ratusan pelajar dan mahasiswa.',
                'content' => '<p>Ratusan peserta dari kalangan generasi muda antusias mengikuti workshop literasi teknologi dan etika bermedia sosial yang diselenggarakan di aula utama pada hari Rabu lalu.</p>',
                'status' => PostStatus::Published,
                'is_featured' => false,
                'view_count' => 89,
            ],
            [
                'title' => 'Laporan Kinerja Pelayanan Publik Triwulan Ketiga Tahun Ini',
                'category_slug' => 'transparansi-kinerja',
                'summary' => 'Publikasi capaian target kepuasan masyarakat terhadap layanan publik mencapai skor indeks 89.5%.',
                'content' => '<p>Berdasarkan survei kepuasan masyarakat (SKM) triwulan ketiga, tingkat kepuasan layanan publik mencapai indeks memuaskan 89.5%. Hasil lengkap dan rincian metodologi dapat diunduh pada lampiran dokumen transparansi.</p>',
                'status' => PostStatus::Published,
                'is_featured' => false,
                'view_count' => 210,
            ],
        ];

        foreach ($posts as $item) {
            $category = Category::where('slug', $item['category_slug'])->first();
            if ($category) {
                Post::updateOrCreate(
                    ['slug' => Str::slug($item['title'])],
                    [
                        'user_id' => $admin->id,
                        'category_id' => $category->id,
                        'title' => $item['title'],
                        'summary' => $item['summary'],
                        'content' => $item['content'],
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
