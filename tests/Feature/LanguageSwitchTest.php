<?php

namespace Tests\Feature;

use App\Enums\UserRole;
use App\Models\User;
use BezhanSalleh\LanguageSwitch\Http\Livewire\LanguageSwitchComponent;
use BezhanSalleh\LanguageSwitch\LanguageSwitch;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Livewire\Livewire;
use Tests\TestCase;

class LanguageSwitchTest extends TestCase
{
    use RefreshDatabase;

    public function test_language_switch_is_configured_with_expected_locales_and_labels(): void
    {
        $switch = LanguageSwitch::make();

        $this->assertEquals(['id', 'en'], $switch->getLocales());
        $this->assertEquals([
            'id' => 'Bahasa Indonesia',
            'en' => 'English',
        ], $switch->getLabels());
        $this->assertTrue($switch->isVisible());
    }

    public function test_language_switch_can_switch_locale(): void
    {
        Livewire::test(LanguageSwitchComponent::class)
            ->call('changeLocale', 'en')
            ->assertSessionHas('locale', 'en');

        Livewire::test(LanguageSwitchComponent::class)
            ->call('changeLocale', 'id')
            ->assertSessionHas('locale', 'id');
    }

    public function test_filament_admin_panel_displays_language_switch_component(): void
    {
        $user = User::factory()->create([
            'role' => UserRole::Admin,
        ]);

        $response = $this->actingAs($user)->get('/admin');

        $response->assertSuccessful();
        $response->assertSee('fi-ls');
    }
}
