import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/usecases/login_usecase.dart';

final authProvider =
    AsyncNotifierProvider<AuthController, AuthEntity?>(AuthController.new);

class AuthController extends AsyncNotifier<AuthEntity?> {
  late final LoginUseCase          _login;
  late final LogoutUseCase         _logout;
  late final GetCurrentUserUseCase _getCurrent;

  @override
  Future<AuthEntity?> build() async {
    _login      = sl<LoginUseCase>();
    _logout     = sl<LogoutUseCase>();
    _getCurrent = sl<GetCurrentUserUseCase>();
    final result = await _getCurrent(NoParams());
    return result.fold((_) => null, (u) => u);
  }

  /// Returns null on success, error message on failure.
  Future<String?> login(String email, String password) async {
    state = const AsyncValue.loading();
    final result = await _login(LoginParams(email: email, password: password));
    return result.fold(
      (failure) {
        state = const AsyncValue.data(null);
        return failure.message;
      },
      (user) {
        state = AsyncValue.data(user);
        return null;
      },
    );
  }

  Future<void> logout() async {
    await _logout(NoParams());
    state = const AsyncValue.data(null);
  }
}
