import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

// ── Get all products ──────────────────────────────────────────────────────
class GetProductsUseCase implements UseCase<List<ProductEntity>, NoParams> {
  final ProductRepository repository;
  const GetProductsUseCase({required this.repository});

  @override
  Future<Either<Failure, List<ProductEntity>>> call(NoParams params) =>
      repository.getProducts();
}

// ── Get single product ────────────────────────────────────────────────────
class GetProductDetailParams {
  final int id;
  const GetProductDetailParams({required this.id});
}

class GetProductDetailUseCase
    implements UseCase<ProductEntity, GetProductDetailParams> {
  final ProductRepository repository;
  const GetProductDetailUseCase({required this.repository});

  @override
  Future<Either<Failure, ProductEntity>> call(GetProductDetailParams params) =>
      repository.getProductById(params.id);
}

// ── Search products ───────────────────────────────────────────────────────
class SearchProductsParams {
  final String query;
  const SearchProductsParams({required this.query});
}

class SearchProductsUseCase
    implements UseCase<List<ProductEntity>, SearchProductsParams> {
  final ProductRepository repository;
  const SearchProductsUseCase({required this.repository});

  @override
  Future<Either<Failure, List<ProductEntity>>> call(
      SearchProductsParams params) {
    if (params.query.trim().isEmpty) {
      return Future.value(const Right([]));
    }
    return repository.searchProducts(params.query.trim());
  }
}
