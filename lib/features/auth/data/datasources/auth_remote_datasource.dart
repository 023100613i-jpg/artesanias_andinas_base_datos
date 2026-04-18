import 'package:dio/dio.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/auth_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthModel> login(String email, String password);
  Future<void>      logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio client;
  const AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<AuthModel> login(String email, String password) async {
    try {
      final response = await client.post('/auth/login', data: {
        'username': email.contains('@') ? email.split('@').first : email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return AuthModel(
          id:    '1',
          name:  email.split('@').first,
          email: email,
          role:  'customer',
          token: data['token'] as String? ?? 'demo_token_${DateTime.now().millisecondsSinceEpoch}',
        );
      }
      throw ServerException(
          message: 'Credenciales incorrectas', statusCode: response.statusCode);
    } on DioException catch (e) {
      // Demo offline fallback so the app works without network too
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return AuthModel(
          id:    'offline_${email.hashCode}',
          name:  email.split('@').first,
          email: email,
          role:  'customer',
          token: 'offline_token_${email.hashCode}',
        );
      }
      throw ServerException(
          message: e.message ?? 'Error de autenticación',
          statusCode: e.response?.statusCode);
    }
  }

  @override
  Future<void> logout() async {}
}
