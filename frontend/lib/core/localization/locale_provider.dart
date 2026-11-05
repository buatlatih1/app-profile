import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  static const String _prefKey = 'app_language_code';

  Locale _locale = const Locale('id');
  bool _isInitialized = false;

  Locale get locale => _locale;
  String get languageCode => _locale.languageCode;
  bool get isInitialized => _isInitialized;

  LocaleProvider() {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedCode = prefs.getString(_prefKey);
      if (savedCode != null && (savedCode == 'id' || savedCode == 'en')) {
        _locale = Locale(savedCode);
      }
    } catch (_) {
      // Fallback to default 'id'
    } finally {
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<void> setLocale(Locale newLocale) async {
    if (_locale.languageCode == newLocale.languageCode) return;
    _locale = newLocale;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefKey, newLocale.languageCode);
    } catch (_) {}
  }

  Future<void> toggleLocale() async {
    if (_locale.languageCode == 'id') {
      await setLocale(const Locale('en'));
    } else {
      await setLocale(const Locale('id'));
    }
  }
}

