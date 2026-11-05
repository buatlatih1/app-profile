import 'package:flutter/foundation.dart';

class ApiConstants {
  /// Base API URL for backend.
  /// When running in browser (Flutter Web), 'http://localhost:8000/api/v1' or current host works.
  /// For Android emulator, 'http://10.0.2.2:8000/api/v1' can be used.
  /// You can customize or override this via kApiBaseUrl.
  static String get baseUrl {
    // If Web or Desktop
    if (kIsWeb) {
      return 'http://localhost:8000/api/v1';
    }
    // Android emulator standard alias to host localhost
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8000/api/v1';
    }
    // Windows, macOS, Linux, iOS Simulator
    return 'http://localhost:8000/api/v1';
  }

  /// Base host for media / storage files
  static String get storageBaseUrl {
    if (kIsWeb) {
      return 'http://localhost:8000';
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8000';
    }
    return 'http://localhost:8000';
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

