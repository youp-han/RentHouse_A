class AuthState {
  static final AuthState instance = AuthState._();
  AuthState._();

  bool isLoggedIn = false;
  List<String> roles = []; // ['ADMIN', 'MANAGER', ...]

  void login({required List<String> roles}) {
    isLoggedIn = true;
    this.roles = roles;
  }

  void logout() {
    isLoggedIn = false;
    roles = [];
  }
}
