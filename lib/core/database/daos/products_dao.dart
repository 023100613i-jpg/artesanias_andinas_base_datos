
import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/app_tables.dart';

part 'products_dao.g.dart';

@DriftAccessor(tables: [Products])
class ProductsDao extends DatabaseAccessor<AppDatabase> with _$ProductsDaoMixin {
  ProductsDao(super.db);

  // ==================== READ ====================
  
  Future<List<Product>> getAllProducts() => select(products).get();
  
  Stream<List<Product>> watchAllProducts() => select(products).watch();
  
  Future<Product?> getProductById(int id) =>
      (select(products)..where((t) => t.id.equals(id))).getSingleOrNull();
  
  Future<List<Product>> getByCategory(String category) =>
      (select(products)..where((t) => t.category.equals(category))).get();
  
  // ==================== CREATE/UPDATE ====================
  
  Future<int> upsertProduct(ProductsCompanion p) => 
      into(products).insertOnConflictUpdate(p);
  
  Future<void> upsertProducts(List<ProductsCompanion> items) => 
      batch((b) => b.insertAllOnConflictUpdate(products, items));
  
  Future<bool> updateStock(int productId, int newStock) async {
    final result = await (update(products)..where((t) => t.id.equals(productId)))
        .write(ProductsCompanion(stock: Value(newStock)));
    return result > 0;
  }

  // NUEVO MÉTODO - Tarea 2
  /// Actualiza el rating y el contador de reseñas de un producto
  /// 
  /// [productId] - ID del producto a actualizar
  /// [rating] - Nuevo promedio de calificación (1-5)
  /// [count] - Nuevo número total de reseñas
  /// 
  /// Retorna true si la actualización fue exitosa, false si no se encontró el producto
  Future<bool> updateRatingAndCount(int productId, double rating, int count) async {
    try {
      final result = await (update(products)..where((t) => t.id.equals(productId)))
          .write(ProductsCompanion(
            rating: Value(rating),
            reviewCount: Value(count),
          ));
      return result > 0;
    } catch (e) {
      // ignore: avoid_print
      print('Error actualizando rating y count: $e');
      return false;
    }
  }
  
  // ==================== DELETE ====================
  
  Future<int> deleteProduct(int id) => 
      (delete(products)..where((t) => t.id.equals(id))).go();
  
  Future<int> clearCache() => delete(products).go();
}