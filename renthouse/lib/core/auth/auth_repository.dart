import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:renthouse/core/network/dio_client.dart';

class AuthRepository {
  final DioClient _dioClient;
  final FlutterSecureStorage _secureStorage;

  AuthRepository(this._dioClient, this._secureStorage);

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

    /*
    try {
      final response = await _dioClient.dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      // TODO: 실제 백엔드 응답 구조에 따라 토큰 추출 로직 변경
      final token = response.data['token'] as String;
      await _secureStorage.write(key: 'jwt_token', value: token);
      return token;
    } on DioException catch (e) {
      // TODO: 에러 처리 로직 개선
      if (e.response != null) {
        throw Exception(e.response!.data['message'] ?? '로그인 실패');
      } else {
        throw Exception('네트워크 오류: ${e.message}');
      }
    }
    */
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: 'jwt_token');
    // TODO: 서버 측 로그아웃 API 호출 (선택 사항)
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'jwt_token');
  }
}
