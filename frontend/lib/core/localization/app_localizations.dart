import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('id'));
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'id': {
      'app_title': 'Portal Resmi Informasi & Layanan Publik',
      'nav_home': 'Beranda',
      'nav_posts': 'Berita & Artikel',
      'nav_pages': 'Profil & Info',
      'nav_questions': 'Tanya Publik',
      'nav_faqs': 'FAQ',
      'nav_ask_question': 'Kirim Pertanyaan',
      'search': 'Cari...',
      'search_posts_hint': 'Cari berita, pengumuman, atau artikel...',
      'search_faqs_hint': 'Cari pertanyaan yang sering diajukan...',
      'search_questions_hint': 'Cari pertanyaan warga yang sudah dijawab...',
      'all_categories': 'Semua Kategori',
      'all_topics': 'Semua Topik',
      'featured_posts': 'Berita Utama & Terpopuler',
      'latest_posts': 'Berita & Kabar Terkini',
      'view_all': 'Lihat Semua',
      'read_more': 'Baca Selengkapnya',
      'views': 'dilihat',
      'by': 'Oleh',
      'published_on': 'Diterbitkan pada',
      'updated_on': 'Diperbarui pada',
      'related_posts': 'Berita Terkait',
      'share': 'Bagikan',
      'share_copied': 'Tautan berhasil disalin ke papan klip!',
      'back': 'Kembali',
      'back_to_home': 'Kembali ke Beranda',
      'page_not_found': 'Halaman Tidak Ditemukan',
      'page_not_found_desc': 'Maaf, halaman yang Anda cari tidak tersedia atau telah dipindahkan.',
      'loading': 'Memuat data...',
      'no_data': 'Belum ada data tersedia saat ini.',
      'error_title': 'Terjadi Kesalahan',
      'error_retry': 'Coba Lagi',
      'faqs_title': 'Pusat Tanya Jawab (FAQ)',
      'faqs_subtitle': 'Temukan jawaban cepat untuk pertanyaan yang sering diajukan oleh masyarakat seputar layanan kami.',
      'questions_title': 'Saluran Aspirasi & Pertanyaan Masyarakat',
      'questions_subtitle': 'Layanan komunikasi dua arah bagi masyarakat untuk menyampaikan pertanyaan, pengaduan, dan permohonan informasi secara transparan.',
      'submit_question_btn': 'Ajukan Pertanyaan Baru',
      'form_title': 'Formulir Pertanyaan & Aspirasi',
      'form_desc': 'Silakan lengkapi data berikut. Tim kami akan menindaklanjuti dan memberikan tanggapan resmi.',
      'field_name': 'Nama Lengkap',
      'field_name_hint': 'Masukkan nama lengkap Anda',
      'field_email': 'Alamat Email',
      'field_email_hint': 'contoh: nama@email.com',
      'field_phone': 'Nomor Telepon / WhatsApp',
      'field_phone_hint': 'contoh: 081234567890 (opsional)',
      'field_topic': 'Topik Layanan',
      'field_topic_hint': 'Pilih topik yang sesuai',
      'field_subject': 'Subjek / Judul Pertanyaan',
      'field_subject_hint': 'Ringkasan singkat pertanyaan Anda',
      'field_body': 'Uraian Pertanyaan',
      'field_body_hint': 'Jelaskan pertanyaan atau aspirasi Anda secara rinci (minimal 10 karakter)',
      'submit_btn': 'Kirimkan Sekarang',
      'submitting_btn': 'Mengirimkan...',
      'validation_required': 'Bagian ini wajib diisi',
      'validation_email_invalid': 'Format email tidak valid',
      'validation_body_min': 'Uraian pertanyaan minimal 10 karakter',
      'submit_success_title': 'Pertanyaan Berhasil Dikirim!',
      'submit_success_desc': 'Terima kasih atas partisipasi Anda. Pertanyaan Anda telah masuk antrean telaah dan tim kami akan mengirimkan tanggapan resmi ke email Anda.',
      'send_another': 'Kirim Pertanyaan Lain',
      'official_answer': 'Tanggapan Resmi Petugas',
      'answered_by': 'Dijawab oleh',
      'answered_at': 'pada',
      'status_pending': 'Menunggu Tanggapan',
      'status_answered': 'Sudah Dijawab',
      'status_rejected': 'Ditolak',
      'hero_tag': 'Keterbukaan Informasi Publik',
      'hero_cta': 'Jelajahi Berita',
      'quick_links': 'Tautan Penting',
      'footer_about': 'Tentang Instansi',
      'footer_contact': 'Hubungi Kami',
      'footer_navigation': 'Navigasi Menu',
      'footer_rights': 'Hak Cipta Dilindungi.',
      'language': 'Bahasa',
      'lang_id': 'Indonesia',
      'lang_en': 'English',
      'pagination_prev': 'Sebelumnya',
      'pagination_next': 'Selanjutnya',
      'pagination_page': 'Halaman',
      'pagination_of': 'dari',
      'inquiry_cta_title': 'Memiliki Pertanyaan atau Membutuhkan Bantuan?',
      'inquiry_cta_desc': 'Kirimkan pertanyaan Anda melalui portal resmi ini dan dapatkan jawaban terverifikasi dari tim layanan kami.',
      'inquiry_cta_btn': 'Tanya Petugas',
    },
    'en': {
      'app_title': 'Official Public Information & Service Portal',
      'nav_home': 'Home',
      'nav_posts': 'News & Articles',
      'nav_pages': 'About & Info',
      'nav_questions': 'Citizen Inquiries',
      'nav_faqs': 'FAQ',
      'nav_ask_question': 'Ask Question',
      'search': 'Search...',
      'search_posts_hint': 'Search news, announcements, or articles...',
      'search_faqs_hint': 'Search frequently asked questions...',
      'search_questions_hint': 'Search answered citizen inquiries...',
      'all_categories': 'All Categories',
      'all_topics': 'All Topics',
      'featured_posts': 'Featured News & Headlines',
      'latest_posts': 'Latest News & Updates',
      'view_all': 'View All',
      'read_more': 'Read More',
      'views': 'views',
      'by': 'By',
      'published_on': 'Published on',
      'updated_on': 'Updated on',
      'related_posts': 'Related Articles',
      'share': 'Share',
      'share_copied': 'Link copied to clipboard!',
      'back': 'Back',
      'back_to_home': 'Back to Home',
      'page_not_found': 'Page Not Found',
      'page_not_found_desc': 'Sorry, the page you are looking for does not exist or has been moved.',
      'loading': 'Loading data...',
      'no_data': 'No data available at this time.',
      'error_title': 'An Error Occurred',
      'error_retry': 'Try Again',
      'faqs_title': 'Frequently Asked Questions (FAQ)',
      'faqs_subtitle': 'Find quick answers to common questions regarding our public services.',
      'questions_title': 'Citizen Inquiry & Feedback Channel',
      'questions_subtitle': 'A transparent two-way communication service for citizens to submit inquiries, questions, and public information requests.',
      'submit_question_btn': 'Submit New Inquiry',
      'form_title': 'Inquiry & Feedback Submission Form',
      'form_desc': 'Please fill out the information below. Our team will review and provide an official response.',
      'field_name': 'Full Name',
      'field_name_hint': 'Enter your full name',
      'field_email': 'Email Address',
      'field_email_hint': 'e.g. name@email.com',
      'field_phone': 'Phone / WhatsApp',
      'field_phone_hint': 'e.g. +6281234567890 (optional)',
      'field_topic': 'Service Topic',
      'field_topic_hint': 'Select matching service topic',
      'field_subject': 'Subject / Inquiry Title',
      'field_subject_hint': 'Brief summary of your inquiry',
      'field_body': 'Inquiry Details',
      'field_body_hint': 'Describe your question or inquiry in detail (minimum 10 characters)',
      'submit_btn': 'Submit Inquiry',
      'submitting_btn': 'Submitting...',
      'validation_required': 'This field is required',
      'validation_email_invalid': 'Please enter a valid email address',
      'validation_body_min': 'Details must be at least 10 characters long',
      'submit_success_title': 'Inquiry Successfully Submitted!',
      'submit_success_desc': 'Thank you for reaching out. Your inquiry has been queued for review and our team will send an official response to your email.',
      'send_another': 'Submit Another Inquiry',
      'official_answer': 'Official Response',
      'answered_by': 'Answered by',
      'answered_at': 'on',
      'status_pending': 'Pending Review',
      'status_answered': 'Answered',
      'status_rejected': 'Rejected',
      'hero_tag': 'Public Information Transparency',
      'hero_cta': 'Explore News',
      'quick_links': 'Quick Links',
      'footer_about': 'About Agency',
      'footer_contact': 'Contact Us',
      'footer_navigation': 'Navigation',
      'footer_rights': 'All Rights Reserved.',
      'language': 'Language',
      'lang_id': 'Indonesian',
      'lang_en': 'English',
      'pagination_prev': 'Previous',
      'pagination_next': 'Next',
      'pagination_page': 'Page',
      'pagination_of': 'of',
      'inquiry_cta_title': 'Have Questions or Need Assistance?',
      'inquiry_cta_desc': 'Submit your inquiry through this official portal to get verified answers from our service officers.',
      'inquiry_cta_btn': 'Ask Officers',
    },
  };

  String text(String key) {
    final lang = locale.languageCode;
    return _localizedValues[lang]?[key] ??
        _localizedValues['id']?[key] ??
        key;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['id', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

