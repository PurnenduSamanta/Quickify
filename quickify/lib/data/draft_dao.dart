import 'package:drift/drift.dart';

import 'app_database.dart';

part 'draft_dao.g.dart';

@DriftAccessor(tables: [Drafts])
class DraftDao extends DatabaseAccessor<AppDatabase> with _$DraftDaoMixin {
  DraftDao(super.db);

  Stream<List<Draft>> watchAll() => select(drafts).watch();

  Future<List<Draft>> getAll() => select(drafts).get();

  Future<void> insertDraft(Draft d) => into(drafts).insert(d);

  Future<void> updateDraft(Draft d) => update(drafts).replace(d);

  Future<Draft?> getById(String id) =>
      (select(drafts)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> deleteDraft(String id) => (delete(drafts)..where((t) => t.id.equals(id))).go();
}
