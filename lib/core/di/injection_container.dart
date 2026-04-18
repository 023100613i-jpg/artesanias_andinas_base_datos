import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../database/app_database.dart';
import '../network/dio_client.dart';

// ── PRODUCTS ─────────────────────────────
import '../../features/products/data/datasources/product_local_datasource.dart';
import '../../features/products/data/datasources/product_remote_datasource.dart';
import '../../features/products/data/repositories/product_repository_impl.dart';
import '../../features/products/domain/repositories/product_repository.dart';
import '../../features/products/domain/usecases/get_products_usecase.dart';
import '../../features/products/domain/usecases/get_product_detail_usecase.dart';
import '../../features/products/domain/usecases/search_products_usecase.dart';

// ── FAVORITES ─────────────────────────────
import '../../features/favorites/data/datasources/favorite_local_datasource.dart';
import '../../features/favorites/data/repositories/favorite_repository_impl.dart';
import '../../features/favorites/domain/repositories/favorite_repository.dart';
import '../../features/favorites/domain/usecases/get_favorites_usecase.dart';
import '../../features/favorites/domain/usecases/add_favorite_usecase.dart';
import '../../features/favorites/domain/usecases/remove_favorite_usecase.dart';

// ── AUTH ─────────────────────────────
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/get_current_user_usecase.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ── DATABASE ─────────────────────────────
  final db = AppDatabase();
  sl.registerSingleton<AppDatabase>(db);

  // ── EXTERNAL ─────────────────────────────
  sl.registerLazySingleton<Dio>(() => DioClient.createDio());

  // ── PRODUCTS ─────────────────────────────
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<ProductLocalDataSource>(
    () => ProductLocalDataSourceImpl(database: sl()),
  );

  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  sl.registerFactory(() => GetProductsUseCase(repository: sl()));
  sl.registerFactory(() => GetProductDetailUseCase(repository: sl()));
  sl.registerFactory(() => SearchProductsUseCase(repository: sl()));

  // ── FAVORITES ─────────────────────────────
  sl.registerLazySingleton<FavoriteLocalDataSource>(
    () => FavoriteLocalDataSourceImpl(database: sl()),
  );

  sl.registerLazySingleton<FavoriteRepository>(
    () => FavoriteRepositoryImpl(
      localDataSource: sl(),
    ),
  );

  sl.registerFactory(() => GetFavoritesUseCase(repository: sl()));
  sl.registerFactory(() => AddFavoriteUseCase(repository: sl()));
  sl.registerFactory(() => RemoveFavoriteUseCase(repository: sl()));

  // ── AUTH ─────────────────────────────
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  sl.registerFactory(() => LoginUseCase(repository: sl()));
  sl.registerFactory(() => LogoutUseCase(repository: sl()));
  sl.registerFactory(() => GetCurrentUserUseCase(repository: sl()));
}