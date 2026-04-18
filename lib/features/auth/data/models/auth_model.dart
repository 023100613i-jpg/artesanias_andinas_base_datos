import '../../domain/entities/auth_entity.dart';

class AuthModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String token;

  const AuthModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.token,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) => AuthModel(
    id:    json['id']?.toString() ?? '',
    name:  json['username'] as String? ?? json['name'] as String? ?? '',
    email: json['email'] as String? ?? '',
    role:  json['role'] as String? ?? 'customer',
    token: json['token'] as String? ?? '',
  );

  AuthEntity toEntity() => AuthEntity(
    id:    id,
    name:  name,
    email: email,
    role:  _parseRole(role),
    token: token,
  );

  static UserRole _parseRole(String r) {
    switch (r) {
      case 'admin':   return UserRole.admin;
      case 'artisan': return UserRole.artisan;
      default:        return UserRole.customer;
    }
  }
}
