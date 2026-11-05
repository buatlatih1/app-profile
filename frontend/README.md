# 🌐 Portal Frontend Flutter (Web & Mobile)

Aplikasi portal halaman depan (frontend publik) profil instansi yang dibangun dengan **Flutter 3**, mendukung routing web & mobile deklaratif menggunakan [**go_router**](https://pub.dev/packages/go_router), serta fitur **multibahasa** (Bahasa Indonesia `id` & English `en`) yang terintegrasi penuh dengan REST API Laravel (`routes/api.php`).

---

## 🚀 Fitur Utama

1. **Routing Modern & Deklaratif dengan `go_router`**:
   - URL ramah web & deep linking (`/`, `/posts`, `/posts/:slug`, `/pages/:slug`, `/questions`, `/questions/new`, `/faqs`).
   - `ShellRoute` menyatukan navbar responsif, drawer mobile, dan footer instansi.
   - Penanganan query parameter (pencarian artikel `?q=...`, filter kategori `?category=...`, filter topik FAQ `?topic=...`).
   - Halaman 404 Not Found kustom.

2. **Dukungan Multibahasa (Multilingual `ID` & `EN`)**:
   - **Sinkronisasi Otomatis dengan Backend**: Saat bahasa diubah di navbar atau drawer, `ApiClient` otomatis mengirimkan header `Accept-Language: id` atau `Accept-Language: en` serta parameter `?lang=...` ke backend Laravel.
   - Backend merespons dengan konten terjemahan (Spatie Translatable untuk judul, ringkasan, isi berita, kategori, halaman statis, FAQ, topik pertanyaan, dan slide banner).
   - Seluruh teks antarmuka (UI labels, tombol, navigasi, formulir, pesan validasi) diterjemahkan via `AppLocalizations`.
   - Preferensi bahasa disimpan secara persisten di `SharedPreferences`.

3. **Modul CMS**:
   - **Hero Slide Banner**: Carousel interaktif (`/slides`) dengan auto-play, indikator dot, dan tombol aksi tautan.
   - **Berita & Artikel Publik**: Daftar artikel (`/posts`), filter per kategori (`/categories`), pencarian judul & isi, penomoran halaman (pagination), dan halaman detail artikel lengkap (`/posts/:slug`) dengan rich text HTML (`flutter_widget_from_html_core`).
   - **Halaman Profil Statis**: Halaman detail (`/pages/:slug`) seperti *Tentang Kami*, *Visi Misi*, dan *Struktur Organisasi*.
   - **Pengaturan Instansi & Menu**: Nama instansi, logo, deskripsi, alamat, kontak telepon, email, jam pelayanan, media sosial, dan menu dinamis (`/settings`, `/menus/header`, `/menus/footer`).

4. **Modul Aspirasi & Pertanyaan Masyarakat**:
   - **Daftar Pertanyaan Terjawab**: Masyarakat dapat melihat pertanyaan publik yang telah diberikan tanggapan resmi oleh petugas (`/questions`).
   - **Formulir Pengajuan Pertanyaan**: Form publik (`/questions/new`) untuk mengirim pertanyaan dengan pilihan topik layanan (`/question-topics`), validasi format email, nomor telepon, dan uraian pertanyaan (terlindungi rate limiting backend).
   - **Pusat FAQ**: Halaman tanya jawab populer (`/faqs`) dengan akordeon interaktif dan filter topik.

---

## 📁 Struktur Direktori

```
frontend/
├── lib/
│   ├── main.dart                          # Inisialisasi app, providers, & router
│   ├── core/
│   │   ├── constants/
│   │   │   └── api_constants.dart         # Base URL & endpoint API
│   │   ├── localization/
│   │   │   ├── app_localizations.dart     # Kamus terjemahan ID & EN
│   │   │   └── locale_provider.dart       # State management bahasa & SharedPreferences
│   │   ├── network/
│   │   │   └── api_client.dart            # HTTP Client dengan header Accept-Language
│   │   ├── router/
│   │   │   └── app_router.dart            # Konfigurasi GoRouter & ShellRoute
│   │   └── theme/
│   │       └── app_theme.dart             # Tema Material 3 & Breakpoints responsif
│   ├── models/
│   │   ├── post_model.dart                # Model Berita & Penulis
│   │   ├── category_model.dart            # Model Kategori Berita
│   │   ├── page_model.dart                # Model Halaman Statis
│   │   ├── slide_model.dart               # Model Banner Hero
│   │   ├── menu_model.dart                # Model Menu & Item Menu
│   │   ├── setting_model.dart             # Model Pengaturan Profil Instansi
│   │   ├── question_topic_model.dart      # Model Topik Pelayanan
│   │   ├── question_model.dart            # Model Pertanyaan & Jawaban Resmi
│   │   ├── faq_model.dart                 # Model FAQ
│   │   └── pagination_meta.dart           # Model Metadata Paginasi
│   ├── services/
│   │   ├── post_service.dart              # API calls Post & Kategori
│   │   ├── page_service.dart              # API calls Halaman Statis
│   │   ├── portal_service.dart            # API calls Slide, Setting, & Menu
│   │   ├── inquiry_service.dart           # API calls Topik, Pertanyaan, & Form Kirim
│   │   └── faq_service.dart               # API calls FAQ
│   ├── providers/
│   │   ├── portal_provider.dart           # State Beranda, Slide, & Pengaturan
│   │   ├── post_list_provider.dart        # State Pencarian, Filter Kategori, & Paginasi Berita
│   │   ├── inquiry_provider.dart          # State Daftar Pertanyaan & Submit Form
│   │   └── faq_provider.dart              # State Tanya Jawab FAQ
│   ├── widgets/
│   │   ├── app_navbar.dart                # Header navigasi responsif & pemilih bahasa
│   │   ├── app_drawer.dart                # Menu laci navigasi untuk perangkat mobile
│   │   ├── app_footer.dart                # Footer profil instansi & kontak
│   │   ├── portal_shell.dart              # Shell scaffold untuk GoRouter
│   │   ├── slide_carousel.dart            # Carousel slider banner interaktif
│   │   ├── post_card.dart                 # Kartu artikel berita modern
│   │   ├── question_card.dart             # Kartu aspirasi warga & jawaban resmi
│   │   ├── faq_accordion.dart             # Akordeon ekspansi FAQ
│   │   ├── loading_indicator.dart         # Indikator loading
│   │   └── error_display.dart             # Tampilan error & tombol coba lagi
│   └── views/
│       ├── home_view.dart                 # Halaman Beranda portal
│       ├── posts_view.dart                # Halaman Arsip Berita
│       ├── post_detail_view.dart          # Halaman Detail Berita (/posts/:slug)
│       ├── page_detail_view.dart          # Halaman Detail Statis (/pages/:slug)
│       ├── questions_view.dart            # Halaman Aspirasi Masyarakat (/questions)
│       ├── submit_question_view.dart      # Halaman Formulir Kirim Pertanyaan (/questions/new)
│       ├── faqs_view.dart                 # Halaman FAQ (/faqs)
│       └── not_found_view.dart            # Halaman 404 Not Found
└── test/
    └── widget_test.dart                   # Pengujian unit model & lokalisasi
```

---

## 🛠️ Cara Menjalankan Aplikasi

### 1. Pastikan Backend Laravel Berjalan
Jalankan server Laravel pada port `8000`:
```bash
php artisan serve
```
*(Backend akan aktif di `http://localhost:8000`)*

### 2. Jalankan Flutter Frontend
Masuk ke direktori `frontend`:
```bash
cd frontend
```

#### Menjalankan di Browser (Chrome / Edge):
```bash
flutter run -d chrome
```
atau
```bash
flutter run -d edge
```

#### Menjalankan di Emulator Android:
Untuk Android Emulator, `lib/core/constants/api_constants.dart` sudah secara otomatis mengarahkan host ke `http://10.0.2.2:8000/api/v1`:
```bash
flutter run
```

#### Menjalankan di Desktop Windows:
```bash
flutter run -d windows
```

### 3. Menjalankan Tes Unit
```bash
flutter test
```

---

## 🌐 Alur Integrasi Multibahasa

1. Pengguna memilih tombol **ID** atau **EN** pada bagian atas navigasi.
2. `LocaleProvider` memperbarui locale aktif dan menyimpannya ke `SharedPreferences`.
3. `ApiClient` secara otomatis menyematkan header HTTP:
   ```http
   Accept-Language: id  # atau en
   ```
   dan query parameter `?lang=id` (atau `?lang=en`).
4. Backend Laravel membaca header melalui `SetLocaleMiddleware`, lalu Spatie Translatable mengembalikan atribut model (`title`, `summary`, `content`, `question`, `answer`, `description`) dalam bahasa yang dipilih.
5. Tampilan aplikasi segera menyegarkan seluruh teks UI dan konten API secara instan.
