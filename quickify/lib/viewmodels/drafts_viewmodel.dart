import 'package:flutter/material.dart';

import '../models/form_data.dart';
import 'package:http/http.dart' as http;

class DraftsViewModel extends ChangeNotifier {
  final List<FormData> _drafts = [];
  int? _editingIndex;

  List<FormData> get drafts => List.unmodifiable(_drafts);
  bool get isEditing => _editingIndex != null;
  FormData? get editingData =>
      _editingIndex != null ? _drafts[_editingIndex!] : null;

  void add(FormData data) {
    _drafts.add(data);
    notifyListeners();
  }

  void update(FormData data) {
    if (_editingIndex != null) {
      _drafts[_editingIndex!] = data;
      _editingIndex = null;
      notifyListeners();
    }
  }

  void startEditing(int index) {
    _editingIndex = index;
    notifyListeners();
  }

  void delete(int index) {
    if (_editingIndex == index) {
      _editingIndex = null;
    }
    _drafts.removeAt(index);
    notifyListeners();
  }

  Future<bool> send(int index) async {
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
