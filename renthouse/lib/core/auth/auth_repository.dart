import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepository {
  final FlutterSecureStorage _secureStorage;

  AuthRepository(this._secureStorage);

  Future<String> login(String email, String password) async {
    // TODO: REMOVE AFTER BACKEND INTEGRATION - START SIMULATED LOGIN
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    if (email == 'test@example.com' && password == 'password') {
      const dummyToken = 'dummy_jwt_token_for_testing';
      await _secureStorage.write(key: 'jwt_token', value: dummyToken);
      return dummyToken;
    } else {
      throw Exception('Invalid credentials (simulated)');
    }
    // TODO: REMOVE AFTER BACKEND INTEGRATION - END SIMULATED LOGIN
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: 'jwt_token');
    // TODO: 서버 측 로그아웃 API 호출 (선택 사항)
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'jwt_token');
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  // final dioClient = ref.watch(dioClientProvider); // Re-enable when backend is integrated
  final secureStorage = ref.watch(secureStorageProvider);
  return AuthRepository(secureStorage);
});

final secureStorageProvider = Provider((ref) => const FlutterSecureStorage());
