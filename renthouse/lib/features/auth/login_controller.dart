import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:renthouse/core/auth/auth_repository.dart';
import 'package:renthouse/core/auth/auth_state.dart'; // AuthState for updating login status

part 'login_controller.g.dart';

@riverpod
class LoginController extends _$LoginController {
  String? errorMessage;

  @override
  LoginState build() {
    return LoginState.initial;
  }

  Future<void> login(String email, String password) async {
    state = LoginState.loading;
    try {
      await ref.read(authRepositoryProvider).login(email, password);
      AuthState.instance.login(roles: ['ADMIN']); // TODO: 실제 역할은 토큰에서 파싱하거나 서버에서 받아와야 함
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

enum LoginState {
  initial,
  loading,
  success,
  error,
}
