import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:crypto/crypto.dart';
import 'package:renthouse/core/database/database_provider.dart';
import 'package:renthouse/features/auth/domain/user.dart' as auth;
import 'package:renthouse/core/database/app_database.dart';
import 'package:renthouse/core/exceptions/app_exceptions.dart';
import 'package:renthouse/core/logging/app_logger.dart';
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

  /// 임시 세션 토큰 생성 (프로덕션에서는 실제 JWT 구현 필요)
  String _generateSessionToken(String userId) {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final tokenData = '$userId:$timestamp:${_uuid.v4()}';
    final bytes = utf8.encode(tokenData);
    final digest = sha256.convert(bytes);
    return 'session_${digest.toString().substring(0, 32)}';
  }

  Future<auth.User> register(auth.RegisterUserRequest request) async {
    try {
      AppLogger.info('회원가입 시도', tag: 'Auth');
      
      final existingUser = await _database.getUserByEmail(request.email);
      if (existingUser != null) {
        AppLogger.warning('이미 사용 중인 이메일로 회원가입 시도', tag: 'Auth');
        throw const AuthException('이미 사용 중인 이메일입니다.');
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
      
      AppLogger.logAuthOperation('회원가입 완료', userId: userId, success: true);
      
      return auth.User(
        id: userId,
        email: request.email,
        name: request.name,
        passwordHash: hashedPassword,
        createdAt: DateTime.now(),
      );
    } catch (e, stackTrace) {
      if (e is AuthException) {
        rethrow;
      }
      AppLogger.error('회원가입 중 오류 발생', tag: 'Auth', error: e, stackTrace: stackTrace);
      throw AuthException('회원가입 처리 중 오류가 발생했습니다.', details: e.toString(), stackTrace: stackTrace.toString());
    }
  }

  Future<String> login(String email, String password) async {
    try {
      AppLogger.info('로그인 시도', tag: 'Auth');
      
      final user = await _database.getUserByEmail(email);
      if (user == null) {
        AppLogger.warning('존재하지 않는 이메일로 로그인 시도', tag: 'Auth');
        throw const AuthException('사용자를 찾을 수 없습니다.');
      }

      final hashedPassword = _hashPassword(password);
      
      AppLogger.logAuthOperation('로그인 시도', userId: user.id);
      
      if (user.passwordHash != hashedPassword) {
        AppLogger.warning('잘못된 비밀번호로 로그인 시도', tag: 'Auth');
        AppLogger.logAuthOperation('로그인 실패 (비밀번호 불일치)', userId: user.id, success: false);
        throw const AuthException('비밀번호가 일치하지 않습니다.');
      }

      // TODO: 실제 JWT 토큰 구현 필요 (프로덕션에서는 백엔드에서 발급)
      final sessionToken = _generateSessionToken(user.id);
      await _secureStorage.write(key: 'jwt_token', value: sessionToken);
      await _secureStorage.write(key: 'user_id', value: user.id);
      await _secureStorage.write(key: 'user_email', value: user.email);
      
      AppLogger.logAuthOperation('로그인 성공', userId: user.id, success: true);
      
      return sessionToken;
    } catch (e, stackTrace) {
      if (e is AuthException) {
        rethrow;
      }
      AppLogger.warning('로그인 중 오류 발생', tag: 'Auth', details: e);
      throw AuthException('로그인 처리 중 오류가 발생했습니다.', details: e.toString(), stackTrace: stackTrace.toString());
    }
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

  /// 등록된 첫 번째 사용자의 이메일을 가져옵니다 (단일 사용자 로컬 앱용)
  Future<String?> getFirstUserEmail() async {
    try {
      final user = await _database.getFirstUser();
      return user?.email;
    } catch (e) {
      AppLogger.warning('첫 번째 사용자 이메일 조회 실패', tag: 'Auth', details: e);
      return null;
    }
  }

  Future<void> updateUserProfile(auth.UpdateUserRequest request) async {
    final currentUser = await getCurrentUser();
    if (currentUser == null) {
      throw Exception('로그인이 필요합니다.');
    }

    // 현재 비밀번호가 제공된 경우 (비밀번호 변경)
    if (request.currentPassword != null && request.newPassword != null) {
      // 현재 비밀번호 검증
      final currentPasswordHash = _hashPassword(request.currentPassword!);
      if (currentUser.passwordHash != currentPasswordHash) {
        throw Exception('현재 비밀번호가 일치하지 않습니다.');
      }
      
      // 새 비밀번호로 업데이트
      final newPasswordHash = _hashPassword(request.newPassword!);
      await _database.updateUserPassword(currentUser.id, newPasswordHash);
      
      // 보안이 강화된 로그
      if (kDebugMode) {
        print('비밀번호 변경 완료: 사용자 ${currentUser.id.substring(0, 8)}***');
      }
    }

    // 이름 업데이트
    if (request.name != null) {
      await _database.updateUserName(currentUser.id, request.name!);
    }
  }

  /// 회원 탈퇴
  Future<void> deleteAccount(String password) async {
    final currentUser = await getCurrentUser();
    if (currentUser == null) {
      throw Exception('로그인이 필요합니다.');
    }

    // 비밀번호 확인
    final passwordHash = _hashPassword(password);
    if (currentUser.passwordHash != passwordHash) {
      throw Exception('비밀번호가 일치하지 않습니다.');
    }

    try {
      // 1. 사용자와 연관된 모든 데이터 삭제 (자산, 유닛, 계약, 청구서, 수납 등)
      await _database.deleteAllUserData(currentUser.id);
      
      // 2. 로컬 저장소에서 인증 정보 삭제는 logout() 메서드에서 별도로 처리합니다.
      // await logout();
      
      if (kDebugMode) {
        final maskedEmail = currentUser.email.length > 3 ? 
            '${currentUser.email.substring(0, 3)}***@${currentUser.email.split('@').last}' : '***';
        print('회원 탈퇴 완료: $maskedEmail - 모든 연관 데이터 삭제됨');
      }
    } catch (e) {
      print('회원 탈퇴 실패: $e');
      throw Exception('회원 탈퇴 처리 중 오류가 발생했습니다.');
    }
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  final database = ref.watch(appDatabaseProvider);
  return AuthRepository(secureStorage, database);
});

final secureStorageProvider = Provider((ref) => const FlutterSecureStorage());
