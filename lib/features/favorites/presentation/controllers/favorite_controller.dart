import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/favorite_entity.dart';
import '../../domain/usecases/get_favorites_usecase.dart';
import '../../../products/domain/entities/product_entity.dart';

final favoritesProvider =
    AsyncNotifierProvider<FavoritesController, List<FavoriteEntity>>(
  FavoritesController.new,
);

class FavoritesController extends AsyncNotifier<List<FavoriteEntity>> {
  late final GetFavoritesUseCase _get;
  late final AddFavoriteUseCase _add;

  @override
  Future<List<FavoriteEntity>> build() async {
    _get = sl<GetFavoritesUseCase>();
    _add = sl<AddFavoriteUseCase>();
    return _load();
  }

  Future<List<FavoriteEntity>> _load() async {
    final result = await _get(NoParams());
    return result.fold(
      (f) => throw Exception(f.message),
      (list) => list,
    );
  }

  // ─────────────────────────────
  // ❤️ ADD
  // ─────────────────────────────
  Future<void> addFavorite(ProductEntity product) async {
    // 🔥 evita múltiples ejecuciones
    if (state.isLoading) return;

    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      await _add(AddFavoriteParams(
        productId: product.id,
        productName: product.name,
      ));

      return await _load();
    });
  }

  void deleteFavorite(int id) {}

  void removeFavorite(int productId) {}
}
