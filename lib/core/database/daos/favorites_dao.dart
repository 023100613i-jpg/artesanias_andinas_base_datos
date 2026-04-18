import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/app_tables.dart';

part 'favorites_dao.g.dart';

@DriftAccessor(tables: [Favorites])
class FavoritesDao extends DatabaseAccessor<AppDatabase>
    with _$FavoritesDaoMixin {
  FavoritesDao(super.db);

  Future<List<Favorite>> getAllFavorites() =>
      (select(favorites)
            ..orderBy([(t) => OrderingTerm.desc(t.addedAt)]))
          .get();

  Future<Favorite?> getFavoriteByProductId(int productId) =>
      (select(favorites)
            ..where((t) => t.productId.equals(productId)))
          .getSingleOrNull();

  Future<void> insertFavorite(int productId, String productName) async {
    await into(favorites).insertOnConflictUpdate(
      FavoritesCompanion(
        productId: Value(productId),
        productName: Value(productName),
        addedAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
  }

  Future<void> deleteFavorite(int productId) async {
    await (delete(favorites)
          ..where((t) => t.productId.equals(productId)))
        .go();
  }
}