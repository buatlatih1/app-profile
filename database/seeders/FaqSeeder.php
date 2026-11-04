<?php

namespace Database\Seeders;

use App\Models\Faq;
use App\Models\QuestionTopic;
use Illuminate\Database\Seeder;

class FaqSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $perizinan = QuestionTopic::where('slug', 'pelayanan-informasi-perizinan')->first();
        $aplikasi = QuestionTopic::where('slug', 'aplikasi-sistem-digital')->first();

        $faqs = [
            [
                'topic_id' => $perizinan?->id,
                'question' => 'Berapa lama waktu yang dibutuhkan untuk proses permohonan informasi publik?',
                'answer' => 'Sesuai dengan ketentuan UU Keterbukaan Informasi Publik (KIP), permohonan informasi akan ditindaklanjuti paling lambat 10 (sepuluh) hari kerja sejak permohonan diterima secara lengkap, dan dapat diperpanjang maksimal 7 (tujuh) hari kerja dengan pemberitahuan tertulis.',
                'sort_order' => 1,
            ],
            [
                'topic_id' => $perizinan?->id,
                'question' => 'Apakah pemohon dipungut biaya untuk mendapatkan salinan informasi?',
                'answer' => 'Pejabat Pengelola Informasi dan Dokumentasi (PPID) menyediakan informasi publik secara gratis (tidak dipungut biaya). Biaya penggandaan atau pengiriman fisik (jika diperlukan) ditanggung oleh pemohon sesuai ketentuan yang berlaku.',
                'sort_order' => 2,
            ],
            [
                'topic_id' => $aplikasi?->id,
                'question' => 'Bagaimana cara menyampaikan pertanyaan atau aduan melalui portal ini?',
                'answer' => 'Anda dapat memilih menu "Layanan Pertanyaan", memilih topik yang sesuai, mengisi identitas (nama, email aktif, nomor telepon) serta rincian pertanyaan Anda. Notifikasi balasan akan otomatis dikirimkan ke email Anda begitu pertanyaan selesai ditelaah dan dijawab.',
                'sort_order' => 3,
            ],
        ];

        foreach ($faqs as $faq) {
            Faq::updateOrCreate(
                ['question' => $faq['question']],
                $faq
            );
        }
    }
}
