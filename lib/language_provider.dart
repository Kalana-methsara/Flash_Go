import 'package:flutter/material.dart';

enum AppLanguage { en, si }

/// 💡 App language state - default English ('en').
/// Provider pattern එකම ThemeProvider එකට use කරපු විදිහටම.
class LanguageProvider with ChangeNotifier {
  AppLanguage _language = AppLanguage.en; // 👈 default language

  AppLanguage get language => _language;
  bool get isSinhala => _language == AppLanguage.si;

  void toggleLanguage() {
    _language = _language == AppLanguage.en ? AppLanguage.si : AppLanguage.en;
    notifyListeners();
  }

  void setLanguage(AppLanguage lang) {
    _language = lang;
    notifyListeners();
  }
}