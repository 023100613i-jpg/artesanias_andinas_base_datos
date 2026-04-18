import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_datasource.dart';
import '../datasources/product_remote_datasource.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource  localDataSource;

  const ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts() async {
    try {
      final remote = await remoteDataSource.fetchProducts();
      await localDataSource.cacheProducts(remote);
      return Right(remote.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      try {
        final cached = await localDataSource.getCachedProducts();
        return Right(cached.map((m) => m.toEntity()).toList());
      } on CacheException {
        return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
      }
    } on CacheException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> getProductById(int id) async {
    try {
      final model = await remoteDataSource.fetchProductById(id);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      try {
        final cached = await localDataSource.getCachedProductById(id);
        return Right(cached.toEntity());
      } on CacheException {
        return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
      }
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> searchProducts(String query) async {
    try {
      final cached = await localDataSource.getCachedProducts();
      final q = query.toLowerCase();
      final results = cached
          .where((m) =>
              m.name.toLowerCase().contains(q) ||
              m.description.toLowerCase().contains(q) ||
              m.artisan.toLowerCase().contains(q))
          .map((m) => m.toEntity())
          .toList();
      return Right(results);
    } on CacheException {
      return const Right([]);
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProductsByCategory(
      ProductCategory category) async {
    try {
      final cached = await localDataSource.getCachedProducts();
      // Convert each model to entity and filter — avoids accessing private _parseCategory
      final results = cached
          .map((m) => m.toEntity())
          .where((e) => e.category == category)
          .toList();
      return Right(results);
    } on CacheException {
      return const Right([]);
    }
  }

  @override
  Future<Either<Failure, void>> cacheProducts(List<ProductEntity> products) async {
    try {
      await localDataSource.cacheProducts(
        products.map(ProductModel.fromEntity).toList(),
      );
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    }
  }
}
