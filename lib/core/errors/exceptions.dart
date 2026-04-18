class ServerException implements Exception {
  final String message;
  final int? statusCode;
  const ServerException({required this.message, this.statusCode});
  @override
  String toString() => 'ServerException: $message (status: $statusCode)';
}

class NetworkException implements Exception {
  final String message;
  const NetworkException({this.message = 'Sin conexión a internet'});
}

class DatabaseException implements Exception {
  final String message;
  const DatabaseException({required this.message});
}

class UnauthorizedException implements Exception {
  const UnauthorizedException();
}

class CacheException implements Exception {
  final String message;
  const CacheException({this.message = 'Dato no encontrado en caché'});
}
