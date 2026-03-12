import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/app_database.dart';

class HomeViewModel extends ChangeNotifier {
  static const _prefKey = 'isDarkMode';
  final AppDatabase _db;

  bool _isDark = false;
  bool get isDark => _isDark;

  HomeViewModel(this._db) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDark = prefs.getBool(_prefKey) ?? false;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDark = !_isDark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey, _isDark);
    notifyListeners();
  }

  Future<void> saveDraft(Draft data) async {
    final companion = data.toCompanion(true);
    await _db.into(_db.drafts).insertOnConflictUpdate(companion);
  }
}
