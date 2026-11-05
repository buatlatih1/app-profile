import 'package:flutter/foundation.dart';

class ApiConstants {
  /// Base API URL for backend.
  /// Can be overridden at build/run time via:
  /// flutter run --dart-define=API_URL=http://127.0.0.1:8000/api/v1
  static String get baseUrl {
    const envUrl = String.fromEnvironment('API_URL');
    if (envUrl.isNotEmpty) {
      return envUrl;
    }

    // Android emulator standard alias to host loopback
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8000/api/v1';
    }

    // For Web: check current hostname
    if (kIsWeb) {
      final host = Uri.base.host;
      // If deployed on Laragon virtual host (e.g. app-profile.test)
      if (host.isNotEmpty && host != 'localhost' && host != '127.0.0.1') {
        final port = Uri.base.port != 80 && Uri.base.port != 443 && Uri.base.port != 0
            ? ':${Uri.base.port}'
            : '';
        return '${Uri.base.scheme}://$host$port/api/v1';
      }
      // On Windows, use 127.0.0.1 instead of 'localhost' to prevent IPv6 [::1] connection refused
      return 'http://127.0.0.1:8000/api/v1';
    }

    // Default desktop/mobile loopback
    return 'http://127.0.0.1:8000/api/v1';
  }

  /// Base host for media / storage files
  static String get storageBaseUrl {
    const envStorage = String.fromEnvironment('STORAGE_URL');
    if (envStorage.isNotEmpty) {
      return envStorage;
    }

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8000';
    }

    if (kIsWeb) {
      final host = Uri.base.host;
      if (host.isNotEmpty && host != 'localhost' && host != '127.0.0.1') {
        final port = Uri.base.port != 80 && Uri.base.port != 443 && Uri.base.port != 0
            ? ':${Uri.base.port}'
            : '';
        return '${Uri.base.scheme}://$host$port';
      }
      return 'http://127.0.0.1:8000';
    }

    return 'http://127.0.0.1:8000';
  }

  // CMS Endpoints
  static const String posts = '/posts';
  static const String categories = '/categories';
  static const String pages = '/pages';
  static const String slides = '/slides';
  static const String menus = '/menus';
  static const String settings = '/settings';

  // Citizen Inquiry & FAQ Endpoints
  static const String questionTopics = '/question-topics';
  static const String questions = '/questions';
  static const String faqs = '/faqs';
}
