import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/products_dao.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<List<ProductModel>> getCachedProducts();
  Future<ProductModel> getCachedProductById(int id);
  Future<void> cacheProducts(List<ProductModel> products);
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final AppDatabase database;
  late final ProductsDao _dao;

  ProductLocalDataSourceImpl({required this.database}) {
    _dao = database.productsDao;
  }

  @override
  Future<List<ProductModel>> getCachedProducts() async {
    try {
      final products = await _dao.getAllProducts();

      if (products.isEmpty) throw const CacheException();

      return products.map((e) => ProductModel.fromDrift(e)).toList();
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<ProductModel> getCachedProductById(int id) async {
    try {
      final product = await _dao.getProductById(id);

      if (product == null) {
        throw const CacheException(message: 'Producto no encontrado');
      }

      return ProductModel.fromDrift(product);
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    try {
      final companions = products.map((p) => p.toCompanion()).toList();
      await _dao.upsertProducts(companions);
    } catch (e) {
      throw DatabaseException(message: 'Error cacheando: $e');
    }
  }
}