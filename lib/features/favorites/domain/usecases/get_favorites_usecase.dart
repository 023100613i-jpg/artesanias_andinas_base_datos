import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/favorite_entity.dart';
import '../repositories/favorite_repository.dart';

class GetFavoritesUseCase implements UseCase<List<FavoriteEntity>, NoParams> {
  final FavoriteRepository repository;
  const GetFavoritesUseCase({required this.repository});

  @override
  Future<Either<Failure, List<FavoriteEntity>>> call(NoParams params) =>
      repository.getFavorites();
}

// ── Add ───────────────────────────────────────────────────────────────────
class AddFavoriteParams {
  final int productId;
  final String productName;
  const AddFavoriteParams({required this.productId, required this.productName});
}

class AddFavoriteUseCase implements UseCase<void, AddFavoriteParams> {
  final FavoriteRepository repository;
  const AddFavoriteUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(AddFavoriteParams params) =>
      repository.addFavorite(params.productId, params.productName);
}

// ── Remove ────────────────────────────────────────────────────────────────
class RemoveFavoriteParams {
  final int productId;
  const RemoveFavoriteParams({required this.productId});
}

class RemoveFavoriteUseCase implements UseCase<void, RemoveFavoriteParams> {
  final FavoriteRepository repository;
  const RemoveFavoriteUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(RemoveFavoriteParams params) =>
      repository.removeFavorite(params.productId);
}
