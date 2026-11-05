<?php

namespace Database\Seeders;

use App\Models\QuestionTopic;
use Illuminate\Database\Seeder;

class QuestionTopicSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $topics = [
            [
                'name' => [
                    'id' => 'Pelayanan Informasi & Perizinan',
                    'en' => 'Information & Licensing Services',
                ],
                'description' => [
                    'id' => 'Pertanyaan seputar alur dan berkas perizinan publik.',
                    'en' => 'Questions regarding public licensing procedures and documents.',
                ],
                'slug' => 'pelayanan-informasi-perizinan',
                'icon' => 'document-check',
                'sort_order' => 1,
            ],
            [
                'name' => [
                    'id' => 'Layanan Infrastruktur & Jaringan',
                    'en' => 'Infrastructure & Network Services',
                ],
                'description' => [
                    'id' => 'Laporan atau pertanyaan mengenai fasilitas jaringan internet desa/kota.',
                    'en' => 'Reports or inquiries regarding rural/urban internet facilities.',
                ],
                'slug' => 'layanan-infrastruktur-jaringan',
                'icon' => 'signal',
                'sort_order' => 2,
            ],
            [
                'name' => [
                    'id' => 'Aplikasi & Sistem Digital',
                    'en' => 'Applications & Digital Systems',
                ],
                'description' => [
                    'id' => 'Bantuan teknis dan panduan penggunaan aplikasi layanan masyarakat.',
                    'en' => 'Technical support and user guides for public service applications.',
                ],
                'slug' => 'aplikasi-sistem-digital',
                'icon' => 'computer-desktop',
                'sort_order' => 3,
            ],
            [
                'name' => [
                    'id' => 'Pengaduan & Kritik Saran',
                    'en' => 'Complaints & Suggestions',
                ],
                'description' => [
                    'id' => 'Aspirasi, kritik konstruktif, serta aduan layanan publik.',
                    'en' => 'Aspirations, constructive feedback, and public service complaints.',
                ],
                'slug' => 'pengaduan-kritik-saran',
                'icon' => 'chat-bubble-bottom-center-text',
                'sort_order' => 4,
            ],
            [
                'name' => [
                    'id' => 'Umum & Lainnya',
                    'en' => 'General & Others',
                ],
                'description' => [
                    'id' => 'Topik pertanyaan umum seputar instansi dan kedinasan.',
                    'en' => 'General question topics regarding the institution and government affairs.',
                ],
                'slug' => 'umum-lainnya',
                'icon' => 'question-mark-circle',
                'sort_order' => 5,
            ],
        ];

        foreach ($topics as $t) {
            QuestionTopic::updateOrCreate(
                ['slug' => $t['slug']],
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
