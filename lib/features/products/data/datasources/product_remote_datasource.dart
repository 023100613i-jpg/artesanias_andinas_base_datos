import 'package:dio/dio.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> fetchProducts();
  Future<ProductModel>       fetchProductById(int id);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Dio client;
  const ProductRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ProductModel>> fetchProducts() async {
    try {
      final response = await client.get('/products');
      if (response.statusCode == 200) {
        final list = response.data as List<dynamic>;
        return list
            .map((j) => ProductModel.fromJson(j as Map<String, dynamic>))
            .toList();
      }
      throw ServerException(
          message: 'Error al obtener productos',
          statusCode: response.statusCode);
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Error de red',
          statusCode: e.response?.statusCode);
    }
  }

  @override
  Future<ProductModel> fetchProductById(int id) async {
    try {
      final response = await client.get('/products/$id');
      if (response.statusCode == 200) {
        return ProductModel.fromJson(response.data as Map<String, dynamic>);
      }
      throw ServerException(
          message: 'Producto #$id no encontrado',
          statusCode: response.statusCode);
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Error de red',
          statusCode: e.response?.statusCode);
    }
  }
}
