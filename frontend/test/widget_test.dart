import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_portal/core/localization/app_localizations.dart';
import 'package:frontend_portal/models/category_model.dart';
import 'package:frontend_portal/models/post_model.dart';

void main() {
  group('Portal Frontend Unit Tests', () {
    test('AppLocalizations returns correct text for Indonesian and English', () {
      final l10nId = AppLocalizations(const Locale('id'));
      final l10nEn = AppLocalizations(const Locale('en'));

      expect(l10nId.text('nav_home'), 'Beranda');
      expect(l10nEn.text('nav_home'), 'Home');
      expect(l10nId.text('nav_posts'), 'Berita & Artikel');
      expect(l10nEn.text('nav_posts'), 'News & Articles');
    });

    test('PostModel parses json properly', () {
      final json = {
        'id': 1,
        'title': 'Judul Berita',
        'slug': 'judul-berita',
        'summary': 'Ringkasan berita',
        'content': '<p>Konten artikel</p>',
        'category': {
          'id': 10,
          'name': 'Berita Utama',
          'slug': 'berita-utama',
        },
        'view_count': 42,
        'is_featured': true,
      };

      final post = PostModel.fromJson(json);

      expect(post.id, 1);
      expect(post.title, 'Judul Berita');
      expect(post.slug, 'judul-berita');
      expect(post.category?.name, 'Berita Utama');
      expect(post.viewCount, 42);
      expect(post.isFeatured, true);
    });

    test('CategoryModel parses json properly', () {
      final json = {
        'id': 5,
        'name': 'Pengumuman',
        'slug': 'pengumuman',
        'posts_count': 12,
      };

      final category = CategoryModel.fromJson(json);

      expect(category.id, 5);
      expect(category.name, 'Pengumuman');
      expect(category.postsCount, 12);
    });
  });
}
