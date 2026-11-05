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
                'question' => [
                    'id' => 'Berapa lama waktu yang dibutuhkan untuk proses permohonan informasi publik?',
                    'en' => 'How long does the public information request process take?',
                ],
                'answer' => [
                    'id' => 'Sesuai dengan ketentuan UU Keterbukaan Informasi Publik (KIP), permohonan informasi akan ditindaklanjuti paling lambat 10 (sepuluh) hari kerja sejak permohonan diterima secara lengkap, dan dapat diperpanjang maksimal 7 (tujuh) hari kerja dengan pemberitahuan tertulis.',
                    'en' => 'In accordance with the Public Information Disclosure Law, information requests will be followed up at the latest 10 (ten) working days from the date of complete receipt, and can be extended by a maximum of 7 (seven) working days with written notice.',
                ],
                'sort_order' => 1,
            ],
            [
                'topic_id' => $perizinan?->id,
                'question' => [
                    'id' => 'Apakah pemohon dipungut biaya untuk mendapatkan salinan informasi?',
                    'en' => 'Are applicants charged any fee to obtain copies of information?',
                ],
                'answer' => [
                    'id' => 'Pejabat Pengelola Informasi dan Dokumentasi (PPID) menyediakan informasi publik secara gratis (tidak dipungut biaya). Biaya penggandaan atau pengiriman fisik (jika diperlukan) ditanggung oleh pemohon sesuai ketentuan yang berlaku.',
                    'en' => 'The Information and Documentation Management Officer provides public information free of charge. Physical copying or delivery fees (if required) are borne by the applicant in accordance with applicable regulations.',
                ],
                'sort_order' => 2,
            ],
            [
                'topic_id' => $aplikasi?->id,
                'question' => [
                    'id' => 'Bagaimana cara menyampaikan pertanyaan atau aduan melalui portal ini?',
                    'en' => 'How do I submit a question or complaint through this portal?',
                ],
                'answer' => [
                    'id' => 'Anda dapat memilih menu "Layanan Pertanyaan", memilih topik yang sesuai, mengisi identitas (nama, email aktif, nomor telepon) serta rincian pertanyaan Anda. Notifikasi balasan akan otomatis dikirimkan ke email Anda begitu pertanyaan selesai ditelaah dan dijawab.',
                    'en' => 'You can choose the "Questions Service" menu, select the appropriate topic, fill in your identity (name, active email, phone number) and details of your inquiry. Reply notifications will automatically be sent to your email once reviewed and answered.',
                ],
                'sort_order' => 3,
            ],
        ];

        foreach ($faqs as $faq) {
            Faq::updateOrCreate(
                ['sort_order' => $faq['sort_order']],
                $faq
            );
        }
    }
}
