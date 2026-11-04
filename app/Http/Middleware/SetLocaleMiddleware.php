<?php

namespace App\Http\Middleware;

use Carbon\Carbon;
use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class SetLocaleMiddleware
{
    /**
     * Supported application locales.
     *
     * @var array<string>
     */
    protected array $supportedLocales = ['id', 'en'];

    /**
     * Handle an incoming request.
     *
     * @param  Closure(Request): (Response)  $next
     */
    public function handle(Request $request, Closure $next): Response
    {
        $locale = $this->determineLocale($request);

        app()->setLocale($locale);
        Carbon::setLocale($locale);

        $response = $next($request);

        $response->headers->set('Content-Language', $locale);

        return $response;
    }

    protected function determineLocale(Request $request): string
    {
        // 1. Query parameter (?locale=en or ?lang=en)
        if ($request->filled('locale') && in_array($request->query('locale'), $this->supportedLocales, true)) {
            $locale = (string) $request->query('locale');
            if ($request->hasSession()) {
                $request->session()->put('locale', $locale);
            }

            return $locale;
        }

        if ($request->filled('lang') && in_array($request->query('lang'), $this->supportedLocales, true)) {
            $locale = (string) $request->query('lang');
            if ($request->hasSession()) {
                $request->session()->put('locale', $locale);
            }

            return $locale;
        }

        // 2. Session (for Filament Admin / Web)
        if ($request->hasSession() && $request->session()->has('locale')) {
            $sessionLocale = (string) $request->session()->get('locale');
            if (in_array($sessionLocale, $this->supportedLocales, true)) {
                return $sessionLocale;
            }
        }

        // 3. Accept-Language HTTP Header (only if header is explicitly provided)
        if ($request->hasHeader('Accept-Language')) {
            $preferred = $request->getPreferredLanguage($this->supportedLocales);
            if ($preferred && in_array($preferred, $this->supportedLocales, true)) {
                return $preferred;
            }
        }

        // 4. Fallback configuration
        return config('app.locale', 'id');
    }
}
