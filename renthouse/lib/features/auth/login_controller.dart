import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:renthouse/core/auth/auth_repository.dart';
import 'package:renthouse/core/auth/auth_state.dart'; // AuthState for updating login status

enum LoginState {
  initial,
  loading,
  success,
  error,
}

class LoginController extends StateNotifier<LoginState> {
  final AuthRepository _authRepository;
  final AuthState _authState; // To update the global AuthState

  String? errorMessage;

  LoginController(this._authRepository, this._authState) : super(LoginState.initial);

  Future<void> login(String email, String password) async {
    state = LoginState.loading;
    try {
      await _authRepository.login(email, password);
      _authState.login(roles: ['ADMIN']); // TODO: 실제 역할은 토큰에서 파싱하거나 서버에서 받아와야 함
      state = LoginState.success;
    } catch (e) {
      errorMessage = e.toString();
      state = LoginState.error;
    }
  }

  void resetState() {
    state = LoginState.initial;
    errorMessage = null;
  }
}

// Riverpod Providers

final loginControllerProvider = StateNotifierProvider<LoginController, LoginState>((ref) {
  return LoginController(
    ref.read(authRepositoryProvider),
    AuthState.instance, // Using the global AuthState singleton
  );
});
