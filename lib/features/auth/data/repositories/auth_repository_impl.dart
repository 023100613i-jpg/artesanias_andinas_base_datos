import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

// In-memory session (replaced by SecureStorage in Lab 12)
AuthEntity? _session;

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  const AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, AuthEntity>> login(
      String email, String password) async {
    try {
      final model  = await remoteDataSource.login(email, password);
      final entity = model.toEntity();
      _session = entity;
      return Right(entity);
    } on ServerException catch (e) {
      return Left(AuthFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    await remoteDataSource.logout();
    _session = null;
    return const Right(null);
  }

  @override
  Future<Either<Failure, AuthEntity?>> getCurrentUser() async =>
      Right(_session);
}
