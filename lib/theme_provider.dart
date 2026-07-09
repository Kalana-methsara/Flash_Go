import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  // Dark mode සහ Light mode අතර මාරු වීමට (Toggle)
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners(); // ඇප් එකේ UI එක වෙනස් කරන්න මේක අනිවාර්යයි
  }
}