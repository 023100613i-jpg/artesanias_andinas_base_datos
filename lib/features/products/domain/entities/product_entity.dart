import 'package:equatable/equatable.dart';

enum ProductCategory {
  textiles('Textiles'),
  ceramica('Cerámica'),
  joyeria('Joyería'),
  madera('Madera Tallada'),
  pintura('Pintura'),
  otro('Otro');

  final String label;
  const ProductCategory(this.label);
}

class ProductEntity extends Equatable {
  final int id;
  final String name;
  final String description;
  final double price;
  final ProductCategory category;
  final String imageUrl;
  final int stock;
  final String artisan;
  final String origin;

  const ProductEntity({
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

  bool get isAvailable => stock > 0;
  bool get isPremium    => price > 200.0;

  String get formattedPrice => 'S/. ${price.toStringAsFixed(2)}';

  String get stockStatus {
    if (stock == 0) return 'Sin stock';
    if (stock <= 5) return 'Últimas unidades ($stock)';
    return 'Disponible ($stock)';
  }

  @override
  List<Object?> get props =>
      [id, name, description, price, category, imageUrl, stock, artisan, origin];

  ProductEntity copyWith({
    int? id, String? name, String? description, double? price,
    ProductCategory? category, String? imageUrl, int? stock,
    String? artisan, String? origin,
  }) => ProductEntity(
    id: id ?? this.id, name: name ?? this.name,
    description: description ?? this.description, price: price ?? this.price,
    category: category ?? this.category, imageUrl: imageUrl ?? this.imageUrl,
    stock: stock ?? this.stock, artisan: artisan ?? this.artisan,
    origin: origin ?? this.origin,
  );
}
