import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/favorites_dao.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/favorite_model.dart';

abstract class FavoriteLocalDataSource {
  Future<List<FavoriteModel>> getFavorites();
  Future<void> addFavorite(int productId, String productName);
  Future<void> removeFavorite(int productId);
  Future<bool> isFavorite(int productId);
}

class FavoriteLocalDataSourceImpl implements FavoriteLocalDataSource {
  final AppDatabase database;
  late final FavoritesDao _dao;

  FavoriteLocalDataSourceImpl({required this.database}) {
    _dao = database.favoritesDao;
  }

  // ─────────────────────────────
  // 📥 GET
  // ─────────────────────────────
  @override
  Future<List<FavoriteModel>> getFavorites() async {
    try {
      final list = await _dao.getAllFavorites();
      return list.map((e) => FavoriteModel.fromDrift(e)).toList();
    } catch (e) {
      throw DatabaseException(message: 'Error al obtener favoritos: $e');
    }
  }

  // ─────────────────────────────
  // ❤️ ADD
  // ─────────────────────────────
  @override
  Future<void> addFavorite(int productId, String productName) async {
    try {
      await _dao.insertFavorite(productId, productName);
    } catch (e) {
      throw DatabaseException(message: 'Error al agregar favorito: $e');
    }
  }

  // ─────────────────────────────
  // ❌ REMOVE
  // ─────────────────────────────
  @override
  Future<void> removeFavorite(int productId) async {
    try {
      await _dao.deleteFavorite(productId);
    } catch (e) {
      throw DatabaseException(message: 'Error al eliminar favorito: $e');
    }
  }

  // ─────────────────────────────
  // 🔍 CHECK
  // ─────────────────────────────
  @override
  Future<bool> isFavorite(int productId) async {
    final fav = await _dao.getFavoriteByProductId(productId);
    return fav != null;
  }
}