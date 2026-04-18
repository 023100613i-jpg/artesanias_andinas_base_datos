import 'package:dio/dio.dart';

class DioClient {
  static const String _baseUrl = 'https://fakestoreapi.com';

  static Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    dio.interceptors.add(
      LogInterceptor(requestBody: false, responseBody: false, error: true),
    );
    return dio;
  }
}
