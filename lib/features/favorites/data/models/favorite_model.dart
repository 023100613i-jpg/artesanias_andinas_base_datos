import '../../domain/entities/favorite_entity.dart';

import '../../../../core/database/tables/favorites_table.dart' show FavoritesCompanion, FavoritesData;

class FavoriteModel {
  final int?   id;
  final int    productId;
  final String productName;
  final int    addedAt;

  const FavoriteModel({
    this.id,
    required this.productId,
    required this.productName,
    required this.addedAt,
  });

  factory FavoriteModel.fromMap(Map<String, dynamic> map) => FavoriteModel(
    id:          map['id'] as int?,
    productId:   map['productId'] as int,
    productName: map['productName'] as String,
    addedAt:     map['addedAt'] as int,
  );

  factory FavoriteModel.fromDrift(FavoritesData f) => FavoriteModel(
    id: f.id,
    productId: f.productId,
    productName: f.productName,
    addedAt: f.addedAt,
  );

  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    'productId':   productId,
    'productName': productName,
    'addedAt':     addedAt,
  };

  FavoriteEntity toEntity() => FavoriteEntity(
    id:          id ?? 0,
    productId:   productId,
    productName: productName,
    addedAt:     DateTime.fromMillisecondsSinceEpoch(addedAt),
  );
}
