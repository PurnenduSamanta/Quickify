import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeViewModel extends ChangeNotifier {
  static const _prefKey = 'isDarkMode';

  bool _isDark;
  bool get isDark => _isDark;

  HomeViewModel({bool initialDarkMode = false})
      : _isDark = initialDarkMode;

  Future<void> toggleTheme() async {
    _isDark = !_isDark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey, _isDark);
    notifyListeners();
  }
}
