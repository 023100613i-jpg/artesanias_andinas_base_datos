import 'package:equatable/equatable.dart';

enum UserRole { customer, artisan, admin }

class AuthEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String token;

  const AuthEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.token,
  });

  bool get isAuthenticated => token.isNotEmpty;

  @override
  List<Object?> get props => [id, name, email, role, token];
}
