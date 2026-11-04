<?php

namespace Tests\Feature;

use App\Enums\UserRole;
use App\Filament\Resources\Categories\CategoryResource;
use App\Filament\Resources\Faqs\FaqResource;
use App\Filament\Resources\Media\MediaResource;
use App\Filament\Resources\Menus\MenuResource;
use App\Filament\Resources\Pages\PageResource;
use App\Filament\Resources\Posts\PostResource;
use App\Filament\Resources\Questions\QuestionResource;
use App\Filament\Resources\QuestionTopics\QuestionTopicResource;
use App\Filament\Resources\Settings\SettingResource;
use App\Filament\Resources\Slides\SlideResource;
use App\Filament\Resources\Users\UserResource;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class FilamentLocalizationTest extends TestCase
{
    use RefreshDatabase;

    public function test_filament_resource_navigation_and_labels_translate_to_indonesian(): void
    {
        app()->setLocale('id');

        // CMS Group
        $this->assertSame('CMS', CategoryResource::getNavigationGroup());
        $this->assertSame('Kategori', CategoryResource::getNavigationLabel());
        $this->assertSame('Kategori', CategoryResource::getModelLabel());
        $this->assertSame('Kategori Artikel', CategoryResource::getPluralModelLabel());

        $this->assertSame('Post & Artikel', PostResource::getNavigationLabel());
        $this->assertSame('Artikel', PostResource::getModelLabel());

        $this->assertSame('Halaman Statis', PageResource::getNavigationLabel());
        $this->assertSame('Halaman', PageResource::getModelLabel());

        $this->assertSame('Pustaka Media', MediaResource::getNavigationLabel());
        $this->assertSame('Media', MediaResource::getModelLabel());

        $this->assertSame('Menu Navigasi', MenuResource::getNavigationLabel());
        $this->assertSame('Menu', MenuResource::getModelLabel());

        $this->assertSame('Slide Beranda', SlideResource::getNavigationLabel());
        $this->assertSame('Slide', SlideResource::getModelLabel());

        // Public Services Group
        $this->assertSame('Layanan Masyarakat', QuestionResource::getNavigationGroup());
        $this->assertSame('Pertanyaan Warga', QuestionResource::getNavigationLabel());
        $this->assertSame('Pertanyaan Masuk', QuestionResource::getPluralModelLabel());

        $this->assertSame('Layanan Masyarakat', QuestionTopicResource::getNavigationGroup());
        $this->assertSame('Topik Pertanyaan', QuestionTopicResource::getNavigationLabel());

        $this->assertSame('Layanan Masyarakat', FaqResource::getNavigationGroup());
        $this->assertSame('FAQ (Tanya Jawab)', FaqResource::getNavigationLabel());
        $this->assertSame('Daftar FAQ', FaqResource::getPluralModelLabel());

        // Settings Group
        $this->assertSame('Pengaturan', SettingResource::getNavigationGroup());
        $this->assertSame('Pengaturan Situs', SettingResource::getNavigationLabel());

        $this->assertSame('Pengaturan', UserResource::getNavigationGroup());
        $this->assertSame('Pengguna & Hak Akses', UserResource::getNavigationLabel());
        $this->assertSame('Daftar Pengguna', UserResource::getPluralModelLabel());
    }

    public function test_filament_resource_navigation_and_labels_translate_to_english(): void
    {
        app()->setLocale('en');

        // CMS Group
        $this->assertSame('CMS', CategoryResource::getNavigationGroup());
        $this->assertSame('Categories', CategoryResource::getNavigationLabel());
        $this->assertSame('Category', CategoryResource::getModelLabel());
        $this->assertSame('Article Categories', CategoryResource::getPluralModelLabel());

        $this->assertSame('Posts & Articles', PostResource::getNavigationLabel());
        $this->assertSame('Article', PostResource::getModelLabel());

        $this->assertSame('Static Pages', PageResource::getNavigationLabel());
        $this->assertSame('Page', PageResource::getModelLabel());

        $this->assertSame('Media Library', MediaResource::getNavigationLabel());
        $this->assertSame('Media', MediaResource::getModelLabel());

        $this->assertSame('Navigation Menus', MenuResource::getNavigationLabel());
        $this->assertSame('Menu', MenuResource::getModelLabel());

        $this->assertSame('Home Slides', SlideResource::getNavigationLabel());
        $this->assertSame('Slide', SlideResource::getModelLabel());

        // Public Services Group
        $this->assertSame('Public Services', QuestionResource::getNavigationGroup());
        $this->assertSame('Citizen Questions', QuestionResource::getNavigationLabel());
        $this->assertSame('Incoming Questions', QuestionResource::getPluralModelLabel());

        $this->assertSame('Public Services', QuestionTopicResource::getNavigationGroup());
        $this->assertSame('Question Topics', QuestionTopicResource::getNavigationLabel());

        $this->assertSame('Public Services', FaqResource::getNavigationGroup());
        $this->assertSame('FAQ', FaqResource::getNavigationLabel());
        $this->assertSame('FAQs', FaqResource::getPluralModelLabel());

        // Settings Group
        $this->assertSame('Settings', SettingResource::getNavigationGroup());
        $this->assertSame('Site Settings', SettingResource::getNavigationLabel());

        $this->assertSame('Settings', UserResource::getNavigationGroup());
        $this->assertSame('Users & Permissions', UserResource::getNavigationLabel());
        $this->assertSame('Users', UserResource::getPluralModelLabel());
    }

    public function test_admin_panel_displays_translations_in_indonesian(): void
    {
        $user = User::factory()->create([
            'role' => UserRole::Admin,
        ]);

        $responseId = $this->actingAs($user)
            ->withSession(['locale' => 'id'])
            ->get('/admin');

        $responseId->assertSuccessful();
        $responseId->assertSee('Layanan Masyarakat');
        $responseId->assertSee('Pertanyaan Warga');
        $responseId->assertSee('Post &amp; Artikel', false);
    }

    public function test_admin_panel_displays_translations_in_english(): void
    {
        $user = User::factory()->create([
            'role' => UserRole::Admin,
        ]);

        $responseEn = $this->actingAs($user)
            ->withSession(['locale' => 'en'])
            ->get('/admin');

        $responseEn->assertSuccessful();
        $responseEn->assertSee('Public Services');
        $responseEn->assertSee('Citizen Questions');
        $responseEn->assertSee('Posts &amp; Articles', false);
    }
}
