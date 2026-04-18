import 'package:drift/drift.dart';

class Products extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  RealColumn get price => real()();
  TextColumn get category => text().withDefault(const Constant('otro'))();
  TextColumn get imageUrl => text().named('image_url').withDefault(const Constant(''))();
  IntColumn get stock => integer().withDefault(const Constant(0))();
  TextColumn get artisan => text().withDefault(const Constant(''))();
  TextColumn get origin => text().withDefault(const Constant(''))();
  IntColumn get cachedAt => integer().named('cached_at')();
  RealColumn get rating => real().nullable()();
  IntColumn get reviewCount => integer().named('review_count').withDefault(const Constant(0))();

}

class Artisans extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get community => text()();
  TextColumn get specialty => text()();
  IntColumn get yearsExp => integer().named('years_exp').withDefault(const Constant(0))();
  TextColumn get photoUrl => text().named('photo_url').withDefault(const Constant(''))();
  TextColumn get biography => text().withDefault(const Constant(''))();
  IntColumn get cachedAt => integer().named('cached_at')();
}

class Favorites extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get productId => integer().named('product_id')();
  TextColumn get productName => text().named('product_name')();
  IntColumn get addedAt => integer().named('added_at')();
  
  @override
  List<Set<Column>> get uniqueKeys => [{productId}];
}

class SyncQueue extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get operation => text()();
  TextColumn get entityType => text().named('entity_type')();
  IntColumn get entityId => integer().named('entity_id')();
  TextColumn get payload => text().nullable()();
  IntColumn get createdAt => integer().named('created_at')();
  IntColumn get retryCount => integer().named('retry_count').withDefault(const Constant(0))();
  TextColumn get status => text().withDefault(const Constant('pending'))();
}

class CachedUsers extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get email => text()();
  TextColumn get role => text().withDefault(const Constant('customer'))();
  TextColumn get tokenRef => text().named('token_ref').nullable()();
  IntColumn get cachedAt => integer().named('cached_at')();
  
  @override
  Set<Column> get primaryKey => {id};
}