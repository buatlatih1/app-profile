<?php

namespace Database\Seeders;

use App\Models\QuestionTopic;
use Illuminate\Database\Seeder;
use Illuminate\Support\Str;

class QuestionTopicSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $topics = [
            ['name' => 'Pelayanan Informasi & Perizinan', 'description' => 'Pertanyaan seputar alur dan berkas perizinan publik.', 'icon' => 'document-check', 'sort_order' => 1],
            ['name' => 'Layanan Infrastruktur & Jaringan', 'description' => 'Laporan atau pertanyaan mengenai fasilitas jaringan internet desa/kota.', 'icon' => 'signal', 'sort_order' => 2],
            ['name' => 'Aplikasi & Sistem Digital', 'description' => 'Bantuan teknis dan panduan penggunaan aplikasi layanan masyarakat.', 'icon' => 'computer-desktop', 'sort_order' => 3],
            ['name' => 'Pengaduan & Kritik Saran', 'description' => 'Aspirasi, kritik konstruktif, serta aduan layanan publik.', 'icon' => 'chat-bubble-bottom-center-text', 'sort_order' => 4],
            ['name' => 'Umum & Lainnya', 'description' => 'Topik pertanyaan umum seputar instansi dan kedinasan.', 'icon' => 'question-mark-circle', 'sort_order' => 5],
        ];

        foreach ($topics as $t) {
            QuestionTopic::updateOrCreate(
                ['slug' => Str::slug($t['name'])],
                [
                    'name' => $t['name'],
                    'description' => $t['description'],
                    'icon' => $t['icon'],
                    'sort_order' => $t['sort_order'],
                    'is_active' => true,
                ]
            );
        }
    }
}
