import 'package:flutter/material.dart';

import '../data/app_database.dart';
import '../data/draft_dao.dart';
import 'package:http/http.dart' as http;

class DraftViewModel extends ChangeNotifier {
  final AppDatabase db = AppDatabase();
  late final DraftDao _dao = db.draftDao;

  Stream<List<Draft>> get draftsStream => _dao.watchAll();

  Future<void> add(Draft data, {bool isUpdate = false}) async {
    if (isUpdate) {
      await _dao.updateDraft(data);
    } else {
      await _dao.insertDraft(data);
    }
  }

  Future<void> delete(String id) async {
    await _dao.deleteDraft(id);
  }

  Future<bool> send(String id) async {
    final entry = await _dao.getById(id);
    if (entry == null) return false;
    
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
