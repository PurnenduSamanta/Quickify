import 'package:flutter/material.dart';

import '../data/app_database.dart';
import 'package:http/http.dart' as http;

class DraftViewModel extends ChangeNotifier {
  final AppDatabase _db;
  List<Draft> _drafts = [];
  int? _editingIndex;

  DraftViewModel(this._db) {
    _loadDrafts();
  }

  Future<void> _loadDrafts() async {
    _drafts = await _db.select(_db.drafts).get();
    notifyListeners();
  }

  List<Draft> get drafts => List.unmodifiable(_drafts);
  bool get isEditing => _editingIndex != null;
  Draft? get editingData =>
      _editingIndex != null ? _drafts[_editingIndex!] : null;

  void startEditing(int index) {
    _editingIndex = index;
    notifyListeners();
  }

  void clearEditing() {
    _editingIndex = null;
    notifyListeners();
  }

  Future<void> add(Draft data) async {
    final companion = data.toCompanion(true);
    await _db.into(_db.drafts).insert(companion);
    await _loadDrafts();
  }

  Future<void> update(Draft data) async {
    if (_editingIndex == null) return;
    await _db.update(_db.drafts).replace(data);
    _editingIndex = null;
    await _loadDrafts();
  }

  Future<void> delete(int index) async {
    if (index < 0 || index >= _drafts.length) return;
    final id = _drafts[index].id;
    await (_db.delete(_db.drafts)..where((t) => t.id.equals(id))).go();
    if (_editingIndex == index) _editingIndex = null;
    await _loadDrafts();
  }

  Future<bool> send(int index) async {
    if (index < 0 || index >= _drafts.length) return false;
    final entry = _drafts[index];
    final uri = Uri.parse('https://jsonplaceholder.typicode.com/posts');
    try {
      final response = await http.post(
        uri,
        body: {'name': entry.name, 'email': entry.email, 'phone': entry.phone},
      );
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
