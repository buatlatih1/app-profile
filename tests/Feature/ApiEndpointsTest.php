<?php

namespace Tests\Feature;

use App\Enums\PostStatus;
use App\Enums\QuestionStatus;
use App\Models\Category;
use App\Models\Faq;
use App\Models\Menu;
use App\Models\MenuItem;
use App\Models\Page;
use App\Models\Post;
use App\Models\Question;
use App\Models\QuestionAnswer;
use App\Models\QuestionTopic;
use App\Models\Setting;
use App\Models\Slide;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class ApiEndpointsTest extends TestCase
{
    use RefreshDatabase;

    protected User $user;

    protected Category $category;

    protected QuestionTopic $topic;

    protected function setUp(): void
    {
        parent::setUp();

        $this->user = User::factory()->create();

        $this->category = Category::create([
            'name' => 'Berita Utama',
            'slug' => 'berita-utama',
            'is_active' => true,
        ]);

        $this->topic = QuestionTopic::create([
            'name' => 'Pelayanan Informasi',
            'slug' => 'pelayanan-informasi',
            'is_active' => true,
        ]);
    }

    public function test_can_list_published_posts(): void
    {
        Post::create([
            'user_id' => $this->user->id,
            'category_id' => $this->category->id,
            'title' => 'Judul Berita Baru',
            'slug' => 'judul-berita-baru',
            'summary' => 'Ringkasan berita',
            'content' => 'Konten lengkap berita',
            'status' => PostStatus::Published,
            'published_at' => now(),
        ]);

        $response = $this->getJson('/api/v1/posts');

        $response->assertOk()
            ->assertJsonStructure([
                'data' => [
                    '*' => ['id', 'title', 'slug', 'summary', 'published_at', 'category'],
                ],
            ]);
    }

    public function test_can_view_single_post_by_slug_and_increment_view_count(): void
    {
        $post = Post::create([
            'user_id' => $this->user->id,
            'category_id' => $this->category->id,
            'title' => 'Detail Berita',
            'slug' => 'detail-berita',
            'summary' => 'Ringkasan',
            'content' => 'Konten detail berita',
            'status' => PostStatus::Published,
            'published_at' => now(),
            'view_count' => 0,
        ]);

        $response = $this->getJson('/api/v1/posts/detail-berita');

        $response->assertOk()
            ->assertJsonPath('data.title', 'Detail Berita')
            ->assertJsonPath('data.content', 'Konten detail berita');

        $this->assertDatabaseHas('posts', [
            'id' => $post->id,
            'view_count' => 1,
        ]);
    }

    public function test_can_list_categories(): void
    {
        $response = $this->getJson('/api/v1/categories');

        $response->assertOk()
            ->assertJsonStructure([
                'data' => [
                    '*' => ['id', 'name', 'slug'],
                ],
            ]);
    }

    public function test_can_view_page_by_slug(): void
    {
        Page::create([
            'user_id' => $this->user->id,
            'title' => 'Tentang Kami',
            'slug' => 'tentang-kami',
            'content' => 'Profil instansi kami',
            'status' => 'published',
        ]);

        $response = $this->getJson('/api/v1/pages/tentang-kami');

        $response->assertOk()
            ->assertJsonPath('data.title', 'Tentang Kami')
            ->assertJsonPath('data.content', 'Profil instansi kami');
    }

    public function test_can_list_slides(): void
    {
        Slide::create([
            'title' => 'Banner Utama',
            'image' => 'slides/banner.jpg',
            'is_active' => true,
        ]);

        $response = $this->getJson('/api/v1/slides');

        $response->assertOk()
            ->assertJsonStructure([
                'data' => [
                    '*' => ['id', 'title', 'image'],
                ],
            ]);
    }

    public function test_can_get_menu_by_location(): void
    {
        $menu = Menu::create([
            'name' => 'Header Menu',
            'location' => 'header',
            'is_active' => true,
        ]);

        MenuItem::create([
            'menu_id' => $menu->id,
            'label' => 'Beranda',
            'url' => '/',
            'type' => 'custom',
            'sort_order' => 1,
            'is_active' => true,
        ]);

        $response = $this->getJson('/api/v1/menus/header');

        $response->assertOk()
            ->assertJsonPath('data.name', 'Header Menu')
            ->assertJsonStructure([
                'data' => ['id', 'name', 'location', 'items'],
            ]);
    }

    public function test_can_get_settings(): void
    {
        Setting::set('site_name', 'Portal Instansi');

        $response = $this->getJson('/api/v1/settings');

        $response->assertOk()
            ->assertJsonStructure(['data']);
    }

    public function test_can_list_question_topics(): void
    {
        $response = $this->getJson('/api/v1/question-topics');

        $response->assertOk()
            ->assertJsonStructure([
                'data' => [
                    '*' => ['id', 'name', 'slug'],
                ],
            ]);
    }

    public function test_citizen_can_submit_question(): void
    {
        $payload = [
            'topic_id' => $this->topic->id,
            'name' => 'Budi Santoso',
            'email' => 'budi@example.com',
            'phone' => '08123456789',
            'subject' => 'Pertanyaan Terkait Jadwal Operasional',
            'body' => 'Mohon informasi mengenai jam buka loket pelayanan pada akhir pekan.',
        ];

        $response = $this->postJson('/api/v1/questions', $payload);

        $response->assertStatus(201)
            ->assertJsonPath('data.subject', 'Pertanyaan Terkait Jadwal Operasional')
            ->assertJsonPath('data.status', 'pending');

        $this->assertDatabaseHas('questions', [
            'email' => 'budi@example.com',
            'subject' => 'Pertanyaan Terkait Jadwal Operasional',
            'status' => 'pending',
        ]);
    }

    public function test_question_submission_requires_valid_data(): void
    {
        $response = $this->postJson('/api/v1/questions', [
            'name' => '',
            'email' => 'not-an-email',
            'subject' => '',
            'body' => 'short',
        ]);

        $response->assertStatus(422)
            ->assertJsonValidationErrors(['topic_id', 'name', 'email', 'subject', 'body']);
    }

    public function test_can_list_answered_public_questions(): void
    {
        $question = Question::create([
            'topic_id' => $this->topic->id,
            'name' => 'Rina',
            'email' => 'rina@example.com',
            'subject' => 'Prosedur Legalisir',
            'body' => 'Bagaimana alur pengajuan legalisir dokumen secara mandiri?',
            'status' => QuestionStatus::Answered,
        ]);

        QuestionAnswer::create([
            'question_id' => $question->id,
            'user_id' => $this->user->id,
            'body' => 'Legalisir dokumen dapat dilakukan setiap hari kerja dengan membawa berkas asli.',
            'status' => 'published',
            'is_published' => true,
        ]);

        $response = $this->getJson('/api/v1/questions');

        $response->assertOk()
            ->assertJsonStructure([
                'data' => [
                    '*' => ['id', 'subject', 'body', 'answer'],
                ],
            ]);
    }

    public function test_can_list_faqs(): void
    {
        Faq::create([
            'topic_id' => $this->topic->id,
            'question' => 'Apakah layanan ini gratis?',
            'answer' => 'Ya, seluruh layanan publik di portal ini tidak dipungut biaya.',
            'sort_order' => 1,
            'is_active' => true,
        ]);

        $response = $this->getJson('/api/v1/faqs');

        $response->assertOk()
            ->assertJsonStructure([
                'data' => [
                    '*' => ['id', 'question', 'answer'],
                ],
            ]);
    }

    public function test_api_responds_in_indonesian_when_requested_via_accept_language_header(): void
    {
        $response = $this->withHeader('Accept-Language', 'id')
            ->postJson('/api/v1/questions', []);

        $response->assertStatus(422)
            ->assertHeader('Content-Language', 'id')
            ->assertJsonPath('errors.name.0', 'Nama wajib diisi.');
    }

    public function test_api_responds_in_indonesian_when_requested_via_query_parameter(): void
    {
        $response = $this->postJson('/api/v1/questions?lang=id', []);

        $response->assertStatus(422)
            ->assertHeader('Content-Language', 'id')
            ->assertJsonPath('errors.name.0', 'Nama wajib diisi.');
    }

    public function test_api_responds_in_english_when_requested_via_accept_language_header(): void
    {
        $response = $this->withHeader('Accept-Language', 'en')
            ->postJson('/api/v1/questions', []);

        $response->assertStatus(422)
            ->assertHeader('Content-Language', 'en')
            ->assertJsonPath('errors.name.0', 'The name field is required.');
    }

    public function test_api_responds_in_english_when_requested_via_query_parameter(): void
    {
        $response = $this->postJson('/api/v1/questions?lang=en', []);

        $response->assertStatus(422)
            ->assertHeader('Content-Language', 'en')
            ->assertJsonPath('errors.name.0', 'The name field is required.');
    }
}
