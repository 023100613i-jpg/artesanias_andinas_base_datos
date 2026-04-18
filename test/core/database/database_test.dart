// ignore_for_file: avoid_print

import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:artesanias_andinas/core/database/app_database.dart';

void main() {
  group('Migración v2→v3', () {
    late AppDatabase database;

    setUp(() async {
      // Usar base de datos en memoria para pruebas
      database = AppDatabase.forTesting(NativeDatabase.memory());
    });

    tearDown(() async {
      await database.close();
    });

    // ==================== TEST 1 ====================
    test('Verificar que updateRatingAndCount actualiza correctamente', () async {
      // 1. Insertar un producto de prueba
      final productCompanion = ProductsCompanion(
        name: const Value('Producto para prueba de rating'),
        description: const Value('Descripción del producto'),
        price: const Value(99.99),
        category: const Value('Textiles'),
        imageUrl: const Value('https://ejemplo.com/imagen.jpg'),
        stock: const Value(10),
        artisan: const Value('Juan Pérez'),
        origin: const Value('Cusco'),
        cachedAt: Value(DateTime.now().millisecondsSinceEpoch),
        rating: const Value(null),  // Inicialmente null
        reviewCount: const Value(0), // Inicialmente 0
      );

      final productId = await database.productsDao.upsertProduct(productCompanion);
      
      // 2. Verificar valores iniciales
      final productBefore = await database.productsDao.getProductById(productId);
      expect(productBefore, isNotNull);
      expect(productBefore!.rating, isNull);
      expect(productBefore.reviewCount, 0);
      
      print('✅ Valores iniciales - ID: $productId, Rating: ${productBefore.rating}, ReviewCount: ${productBefore.reviewCount}');
      
      // 3. Actualizar rating y review_count
      // ignore: prefer_const_declarations
      final newRating = 4.5;
      const newReviewCount = 15;
      
      final updateSuccess = await database.productsDao.updateRatingAndCount(
        productId,
        newRating,
        newReviewCount,
      );
      
      // 4. Verificar que la actualización fue exitosa
      expect(updateSuccess, true);
      
      // 5. Verificar valores actualizados
      final productAfter = await database.productsDao.getProductById(productId);
      expect(productAfter!.rating, newRating);
      expect(productAfter.reviewCount, newReviewCount);
      
      print('✅ Valores actualizados - Rating: ${productAfter.rating}, ReviewCount: ${productAfter.reviewCount}');
      
      // 6. Verificar que otros campos no se modificaron
      expect(productAfter.name, 'Producto para prueba de rating');
      expect(productAfter.price, 99.99);
      expect(productAfter.stock, 10);
    });

    // ==================== TEST 2 ====================
    test('Verificar que el valor por defecto de review_count es 0', () async {
      // 1. Insertar un producto SIN especificar review_count
      final productCompanion = ProductsCompanion(
        name: const Value('Producto sin review_count especificado'),
        description: const Value('Descripción del producto'),
        price: const Value(49.99),
        category: const Value('Cerámica'),
        imageUrl: const Value('https://ejemplo.com/ceramica.jpg'),
        stock: const Value(5),
        artisan: const Value('María Gómez'),
        origin: const Value('Cusco'),
        cachedAt: Value(DateTime.now().millisecondsSinceEpoch),
        rating: const Value(null),
        // review_count NO se especifica, debe tomar valor por defecto 0
      );

      final productId = await database.productsDao.upsertProduct(productCompanion);
      
      // 2. Verificar que review_count es 0 (valor por defecto)
      final product = await database.productsDao.getProductById(productId);
      expect(product, isNotNull);
      expect(product!.reviewCount, 0);
      
      print('✅ Producto insertado sin review_count - Valor por defecto: ${product.reviewCount}');
      
      // 3. Verificar que el producto fue insertado correctamente
      final productCheck = await database.productsDao.getProductById(productId);
      expect(productCheck, isNotNull);
      expect(productCheck!.reviewCount, 0);
      
      print('✅ Verificación adicional - review_count = ${productCheck.reviewCount}');
    });

    // ==================== TEST ADICIONAL (Opcional pero recomendado) ====================
    test('Verificar que review_count existe en la estructura de la tabla', () async {
      // Verificar que la columna review_count existe en la tabla products
      final tableInfo = await database.customSelect('PRAGMA table_info(products)').get();
      final columnNames = tableInfo.map((row) => row.read<String>('name')).toList();
      
      expect(columnNames, contains('review_count'));
      expect(columnNames, contains('rating'));
      
      print('✅ Columnas en products: $columnNames');
      print('✅ rating existe: ${columnNames.contains('rating')}');
      print('✅ review_count existe: ${columnNames.contains('review_count')}');
      
      // Verificar el tipo de la columna review_count
      final reviewCountColumn = tableInfo.firstWhere(
        (row) => row.read<String>('name') == 'review_count',
      );
      
      final type = reviewCountColumn.read<String>('type');
      final notNull = reviewCountColumn.read<int>('notnull');
      final defaultValue = reviewCountColumn.read<String?>('dflt_value');
      
      print('✅ Tipo de review_count: $type');
      print('✅ NOT NULL: $notNull (0 = nullable, 1 = NOT NULL)');
      print('✅ Valor por defecto: $defaultValue');
    });
  });
}