import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

class LoginParams {
  final String email;
  final String password;
  const LoginParams({required this.email, required this.password});
}

class LoginUseCase implements UseCase<AuthEntity, LoginParams> {
  final AuthRepository repository;
  const LoginUseCase({required this.repository});

  @override
  Future<Either<Failure, AuthEntity>> call(LoginParams params) {
    if (params.email.isEmpty || params.password.isEmpty) {
      return Future.value(
          const Left(ValidationFailure(message: 'Email y contraseña requeridos')));
    }
    return repository.login(params.email, params.password);
  }
}

class LogoutUseCase implements UseCase<void, NoParams> {
  final AuthRepository repository;
  const LogoutUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(NoParams params) =>
      repository.logout();
}

class GetCurrentUserUseCase implements UseCase<AuthEntity?, NoParams> {
  final AuthRepository repository;
  const GetCurrentUserUseCase({required this.repository});

  @override
  Future<Either<Failure, AuthEntity?>> call(NoParams params) =>
      repository.getCurrentUser();
}
