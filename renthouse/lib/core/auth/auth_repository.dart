import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:crypto/crypto.dart';
import 'package:renthouse/core/database/database_provider.dart';
import 'package:renthouse/features/auth/domain/user.dart' as auth;
import 'package:renthouse/core/database/app_database.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';

class AuthRepository {
  final FlutterSecureStorage _secureStorage;
  final AppDatabase _database;
  final Uuid _uuid = const Uuid();

  AuthRepository(this._secureStorage, this._database);

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<auth.User> register(auth.RegisterUserRequest request) async {
    final existingUser = await _database.getUserByEmail(request.email);
    if (existingUser != null) {
      throw Exception('이미 사용 중인 이메일입니다.');
    }

    final hashedPassword = _hashPassword(request.password);
    final userId = _uuid.v4();
    
    final userCompanion = UsersCompanion.insert(
      id: userId,
      email: request.email,
      name: request.name,
      passwordHash: hashedPassword,
      createdAt: DateTime.now(),
    );

    await _database.insertUser(userCompanion);
    
    return auth.User(
      id: userId,
      email: request.email,
      name: request.name,
      passwordHash: hashedPassword,
      createdAt: DateTime.now(),
    );
  }

  Future<String> login(String email, String password) async {
    final user = await _database.getUserByEmail(email);
    if (user == null) {
      throw Exception('사용자를 찾을 수 없습니다.');
    }

    final hashedPassword = _hashPassword(password);
    
    // 디버깅용 로그 (실제 운영에서는 제거해야 함)
    print('로그인 디버깅:');
    print('이메일: $email');
    print('입력한 비밀번호: $password');
    print('해싱된 비밀번호: $hashedPassword');
    print('저장된 해시: ${user.passwordHash}');
    print('해시 일치 여부: ${user.passwordHash == hashedPassword}');
    
    if (user.passwordHash != hashedPassword) {
      throw Exception('비밀번호가 일치하지 않습니다.');
    }

    const dummyToken = 'dummy_jwt_token_for_testing';
    await _secureStorage.write(key: 'jwt_token', value: dummyToken);
    await _secureStorage.write(key: 'user_id', value: user.id);
    await _secureStorage.write(key: 'user_email', value: user.email);
    
    return dummyToken;
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: 'jwt_token');
    await _secureStorage.delete(key: 'user_id');
    await _secureStorage.delete(key: 'user_email');
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'jwt_token');
  }

  Future<auth.User?> getCurrentUser() async {
    final userId = await _secureStorage.read(key: 'user_id');
    if (userId == null) return null;
    
    final dbUser = await _database.getUserById(userId);
    if (dbUser == null) return null;
    
    return auth.User(
      id: dbUser.id,
      email: dbUser.email,
      name: dbUser.name,
      passwordHash: dbUser.passwordHash,
      createdAt: dbUser.createdAt,
    );
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  final database = ref.watch(appDatabaseProvider);
  return AuthRepository(secureStorage, database);
});

final secureStorageProvider = Provider((ref) => const FlutterSecureStorage());
