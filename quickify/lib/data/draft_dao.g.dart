// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'draft_dao.dart';

// ignore_for_file: type=lint
mixin _$DraftDaoMixin on DatabaseAccessor<AppDatabase> {
  $DraftsTable get drafts => attachedDatabase.drafts;
  DraftDaoManager get managers => DraftDaoManager(this);
}

class DraftDaoManager {
  final _$DraftDaoMixin _db;
  DraftDaoManager(this._db);
  $$DraftsTableTableManager get drafts =>
      $$DraftsTableTableManager(_db.attachedDatabase, _db.drafts);
}
