// ignore_for_file: use_super_parameters

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables/app_tables.dart';
import 'daos/products_dao.dart';
import 'daos/artisans_dao.dart';
import 'daos/favorites_dao.dart';
import 'daos/sync_queue_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Products, Artisans, Favorites, SyncQueue, CachedUsers],
  daos: [ProductsDao, ArtisansDao, FavoritesDao, SyncQueueDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());


  // ✅ CAMBIADO: schemaVersion ahora es 3
  @override
  int get schemaVersion => 3;


  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
      
      await customStatement('CREATE INDEX IF NOT EXISTS idx_products_category ON products(category)');
      await customStatement('CREATE INDEX IF NOT EXISTS idx_favorites_product_id ON favorites(product_id)');
      await customStatement('CREATE INDEX IF NOT EXISTS idx_sync_queue_status ON sync_queue(status)');
      
      await customStatement('PRAGMA journal_mode=WAL');
      await customStatement('PRAGMA foreign_keys=ON');
    },
    onUpgrade: (Migrator m, int from, int to) async {

      // Migración v1 → v2: agregar columna rating
      if (from < 2) {
        await m.addColumn(products, products.rating);
      }
      
      // ✅ NUEVA MIGRACIÓN v2 → v3: agregar columna review_count
      if (from < 3) {
        await m.addColumn(products, products.reviewCount as GeneratedColumn<Object>);
      }

      if (from < 2) {
        await m.addColumn(products, products.rating);
      }

    },
    beforeOpen: (OpeningDetails d) async {
      await customStatement('PRAGMA foreign_keys=ON');
    },
  );

  AppDatabase.forTesting(QueryExecutor executor) : super(executor);

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'artesanias_andinas');
  }
}