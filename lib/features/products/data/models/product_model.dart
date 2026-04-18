import 'package:artesanias_andinas/core/database/app_database.dart';
import 'package:drift/drift.dart';

import '../../domain/entities/product_entity.dart';

class ProductModel {
  final int id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String imageUrl;
  final int stock;
  final String artisan;
  final String origin;

  const ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
    required this.stock,
    required this.artisan,
    required this.origin,
  });

  // ─────────────────────────────────────────
  // 🌐 FROM API
  // ─────────────────────────────────────────
  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: (json['id'] as num?)?.toInt() ?? 0,
        name: json['name'] as String? ??
            json['title'] as String? ??
            '',
        description: json['description'] as String? ?? '',
        price: (json['price'] as num?)?.toDouble() ?? 0.0,
        category: json['category'] as String? ?? 'otro',
        imageUrl: json['image'] as String? ??
            json['imageUrl'] as String? ??
            '',
        stock: (json['stock'] as num?)?.toInt() ?? 10,
        artisan: json['artisan'] as String? ?? 'Artesano Andino',
        origin: json['origin'] as String? ?? 'Cusco',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'category': category,
        'imageUrl': imageUrl,
        'stock': stock,
        'artisan': artisan,
        'origin': origin,
      };

  // ─────────────────────────────────────────
  // 🗄️ FROM DRIFT (DB → MODEL)
  // ─────────────────────────────────────────
  factory ProductModel.fromDrift(Product p) => ProductModel(
        id: p.id,
        name: p.name,
        description: p.description,
        price: p.price,
        category: p.category,
        imageUrl: p.imageUrl,
        stock: p.stock,
        artisan: p.artisan,
        origin: p.origin,
      );

  // ─────────────────────────────────────────
  // 🗄️ TO DRIFT (MODEL → DB)
  // ─────────────────────────────────────────
  ProductsCompanion toCompanion() {
    return ProductsCompanion(
      id: Value(id),
      name: Value(name),
      description: Value(description),
      price: Value(price),
      category: Value(category),
      imageUrl: Value(imageUrl),
      stock: Value(stock),
      artisan: Value(artisan),
      origin: Value(origin),
    );
  }

  // ─────────────────────────────────────────
  // 🧠 ENTITY CONVERSION
  // ─────────────────────────────────────────
  ProductEntity toEntity() => ProductEntity(
        id: id,
        name: name,
        description: description,
        price: price,
        category: _parseCategory(category),
        imageUrl: imageUrl,
        stock: stock,
        artisan: artisan,
        origin: origin,
      );

  factory ProductModel.fromEntity(ProductEntity e) => ProductModel(
        id: e.id,
        name: e.name,
        description: e.description,
        price: e.price,
        category: e.category.name,
        imageUrl: e.imageUrl,
        stock: e.stock,
        artisan: e.artisan,
        origin: e.origin,
      );

  // ─────────────────────────────────────────
  // 🎯 CATEGORY PARSER
  // ─────────────────────────────────────────
  static ProductCategory _parseCategory(String raw) {
    switch (raw.toLowerCase()) {
      case 'textiles':
      case "men's clothing":
      case "women's clothing":
        return ProductCategory.textiles;

      case 'ceramica':
      case 'cerámica':
      case 'electronics':
        return ProductCategory.ceramica;

      case 'joyeria':
      case 'joyería':
      case 'jewelery':
        return ProductCategory.joyeria;

      case 'madera':
        return ProductCategory.madera;

      case 'pintura':
        return ProductCategory.pintura;

      default:
        return ProductCategory.otro;
    }
  }
}