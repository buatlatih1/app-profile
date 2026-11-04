<?php

namespace Database\Seeders;

use App\Enums\QuestionStatus;
use App\Models\Question;
use App\Models\QuestionAnswer;
use App\Models\QuestionTopic;
use App\Models\User;
use Illuminate\Database\Seeder;

class QuestionSeeder extends Seeder
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

        $perizinanTopic = QuestionTopic::where('slug', 'pelayanan-informasi-perizinan')->first() ?? QuestionTopic::first();
        $infrastrukturTopic = QuestionTopic::where('slug', 'layanan-infrastruktur-jaringan')->first() ?? QuestionTopic::first();

        // Question 1: Answered
        $q1 = Question::updateOrCreate(
            ['email' => 'ahmad.fauzi@gmail.com', 'subject' => 'Persyaratan Permohonan Informasi Publik PPID'],
            [
                'topic_id' => $perizinanTopic->id,
                'name' => 'Ahmad Fauzi',
                'phone' => '081298765432',
                'body' => 'Selamat pagi admin, saya ingin menanyakan dokumen apa saja yang wajib dilampirkan jika ingin mengajukan permohonan salinan data statistik keterbukaan informasi publik?',
                'status' => QuestionStatus::Answered,
                'ip_address' => '127.0.0.1',
            ]
        );

        QuestionAnswer::updateOrCreate(
            ['question_id' => $q1->id],
            [
                'user_id' => $admin->id,
                'body' => 'Selamat pagi Bapak Ahmad Fauzi. Untuk permohonan informasi publik melalui PPID, Anda cukup melampirkan: 1) Fotokopi/Scan KTP yang masih berlaku, 2) Mengisi formulir permohonan informasi publik secara online atau langsung di loket PPID, dan 3) Menyebutkan tujuan penggunaan informasi tersebut. Dokumen permohonan akan diproses maksimal 10 hari kerja.',
                'status' => 'published',
                'is_published' => true,
                'answered_at' => now(),
            ]
        );

        // Question 2: Pending
        Question::updateOrCreate(
            ['email' => 'siti.nurhaliza@gmail.com', 'subject' => 'Permintaan Akses WiFi Publik di Balai Warga RT 05'],
            [
                'topic_id' => $infrastrukturTopic->id,
                'name' => 'Siti Nurhaliza',
                'phone' => '085712345678',
                'body' => 'Halo dinas kominfo, apakah ada program bantuan penyediaan titik internet wifi publik gratis untuk balai pertemuan warga? Bagaimana prosedur pengajuannya?',
                'status' => QuestionStatus::Pending,
                'ip_address' => '127.0.0.1',
            ]
        );
    }
}
