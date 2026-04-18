// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artisans_dao.dart';

// ignore_for_file: type=lint
mixin _$ArtisansDaoMixin on DatabaseAccessor<AppDatabase> {
  $ArtisansTable get artisans => attachedDatabase.artisans;
  ArtisansDaoManager get managers => ArtisansDaoManager(this);
}

class ArtisansDaoManager {
  final _$ArtisansDaoMixin _db;
  ArtisansDaoManager(this._db);
  $$ArtisansTableTableManager get artisans =>
      $$ArtisansTableTableManager(_db.attachedDatabase, _db.artisans);
}
