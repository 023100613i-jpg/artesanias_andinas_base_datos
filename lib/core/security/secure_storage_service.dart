// lib/core/security/secure_storage_service.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const String _keyAuthToken = 'auth_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyUserId = 'user_id';
  static const String _keyUserEmail = 'user_email';
  
  // NUEVA CONSTANTE - Tarea 4
  static const String _keyLastLogin = 'last_login_timestamp';

  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  // ==================== TOKEN METHODS ====================
  
  /// Guardar token JWT
  Future<void> saveAuthToken(String token) => 
      _storage.write(key: _keyAuthToken, value: token);

  /// Leer token JWT
  Future<String?> getUserToken() => _storage.read(key: _keyAuthToken);

  /// Verificar sesión activa
  Future<bool> hasActiveSession() async {
    final token = await getUserToken();
    return token != null && token.isNotEmpty;
  }

  // ==================== USER INFO METHODS ====================
  
  /// Guardar ID de usuario
  Future<void> saveUserId(String userId) => 
      _storage.write(key: _keyUserId, value: userId);
  
  /// Leer ID de usuario
  Future<String?> getUserId() => _storage.read(key: _keyUserId);
  
  /// Guardar email de usuario
  Future<void> saveUserEmail(String email) => 
      _storage.write(key: _keyUserEmail, value: email);
  
  /// Leer email de usuario
  Future<String?> getUserEmail() => _storage.read(key: _keyUserEmail);

  // ====================  NUEVOS MÉTODOS - Tarea 4 ====================
  
  /// Guarda la fecha y hora del último login como string ISO8601
  /// 
  /// El formato ISO8601 es: '2024-04-16T15:30:00.000Z'
  /// Este formato es estándar, fácil de parsear y ordenable cronológicamente
  Future<void> saveLastLoginTimestamp() async {
    final timestamp = DateTime.now().toIso8601String();
    await _storage.write(key: _keyLastLogin, value: timestamp);
  }
  
  /// Lee la fecha y hora del último login
  /// 
  /// Retorna el timestamp como String ISO8601 si existe, null si nunca se ha guardado
  Future<String?> getLastLoginTimestamp() async {
    return await _storage.read(key: _keyLastLogin);
  }
  
  /// Lee y parsea el último login como DateTime
  /// 
  /// Retorna un objeto DateTime si existe, null si nunca se ha guardado
  Future<DateTime?> getLastLoginDateTime() async {
    final timestampStr = await getLastLoginTimestamp();
    if (timestampStr == null) return null;
    
    try {
      return DateTime.parse(timestampStr);
    } catch (e) {
      // ignore: avoid_print
      print('Error parseando timestamp: $e');
      return null;
    }
  }
  
  /// Verifica si el usuario ha iniciado sesión antes
  Future<bool> hasPreviousLogin() async {
    final timestamp = await getLastLoginTimestamp();
    return timestamp != null && timestamp.isNotEmpty;
  }
  
  /// Obtiene el tiempo transcurrido desde el último login
  /// 
  /// Retorna un Duration con el tiempo transcurrido, o null si nunca ha iniciado sesión
  Future<Duration?> getTimeSinceLastLogin() async {
    final lastLogin = await getLastLoginDateTime();
    if (lastLogin == null) return null;
    
    return DateTime.now().difference(lastLogin);
  }

  // ==================== CLEAR SESSION ====================
  
  /// Borrar TODOS los datos al logout
  Future<void> clearSession() async {
    await Future.wait([
      _storage.delete(key: _keyAuthToken),
      _storage.delete(key: _keyRefreshToken),
      _storage.delete(key: _keyUserId),
      _storage.delete(key: _keyUserEmail),
      _storage.delete(key: _keyLastLogin),  // También borrar timestamp
    ]);
  }
}