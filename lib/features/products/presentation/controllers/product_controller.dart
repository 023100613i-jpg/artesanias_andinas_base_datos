import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/usecases/get_products_usecase.dart';

/// ─────────────────────────────────────────────────────────
/// 🟢 ALL PRODUCTS
/// ─────────────────────────────────────────────────────────
final productListProvider =
    AsyncNotifierProvider<ProductListController, List<ProductEntity>>(
  ProductListController.new,
);

class ProductListController extends AsyncNotifier<List<ProductEntity>> {
  late final GetProductsUseCase _uc;

  @override
  Future<List<ProductEntity>> build() async {
    _uc = sl<GetProductsUseCase>();
    return _load();
  }

  Future<List<ProductEntity>> _load() async {
    final result = await _uc(NoParams());
    return result.fold(
      (f) => throw Exception(f.message),
      (p) => p,
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_load);
  }
}

/// ─────────────────────────────────────────────────────────
/// 🔍 SEARCH (FIX REAL DEFINITIVO)
/// ─────────────────────────────────────────────────────────
final searchResultsProvider =
    AsyncNotifierProvider<SearchController, List<ProductEntity>>(
  SearchController.new,
);

class SearchController extends AsyncNotifier<List<ProductEntity>> {
  late final SearchProductsUseCase _uc;

  @override
  Future<List<ProductEntity>> build() async {
    _uc = sl<SearchProductsUseCase>();
    return [];
  }

  Future<void> search(String query) async {
    final trimmed = query.trim();

    // 🔥 CLAVE: evita modificar estado durante build
    await Future.delayed(Duration.zero);

    // vacío
    if (trimmed.isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }

    // evita llamadas múltiples (freeze)
    if (state.isLoading) return;

    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final result = await _uc(
        SearchProductsParams(query: trimmed),
      );

      return result.fold(
        (f) => throw Exception(f.message),
        (data) => data,
      );
    });
  }
}

/// ─────────────────────────────────────────────────────────
/// 📦 PRODUCT DETAIL
/// ─────────────────────────────────────────────────────────
final selectedProductIdProvider = StateProvider<int>((ref) => 0);

final productDetailProvider =
    AsyncNotifierProviderFamily<ProductDetailController, ProductEntity, int>(
  ProductDetailController.new,
);

class ProductDetailController
    extends FamilyAsyncNotifier<ProductEntity, int> {
  late final GetProductDetailUseCase _uc;

  @override
  Future<ProductEntity> build(int arg) async {
    _uc = sl<GetProductDetailUseCase>();

    final result = await _uc(
      GetProductDetailParams(id: arg),
    );

    return result.fold(
      (f) => throw Exception(f.message),
      (p) => p,
    );
  }
}