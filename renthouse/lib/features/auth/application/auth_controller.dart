import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:renthouse/core/auth/auth_repository.dart';
import 'package:renthouse/features/auth/domain/user.dart' as auth;
import 'package:renthouse/core/auth/auth_state.dart';
import 'package:renthouse/core/logging/crash_reporting_service.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  AsyncValue<auth.User?> build() {
    _checkAuthState();
    return const AsyncValue.loading();
  }

  Future<void> _checkAuthState() async {
    try {
      final authRepository = ref.read(authRepositoryProvider);
      final currentUser = await authRepository.getCurrentUser();
      state = AsyncValue.data(currentUser);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> register(auth.RegisterUserRequest request) async {
    state = const AsyncValue.loading();
    CrashReportingService.recordUserAction('register_attempt', data: {'email': request.email});
    
    try {
      final authRepository = ref.read(authRepositoryProvider);
      final user = await authRepository.register(request);
      
      // 회원가입 후 자동 로그인
      await authRepository.login(request.email, request.password);
      
      // 기존 AuthState도 업데이트 (라우터 호환성을 위해)
      AuthState.instance.login(roles: ['USER']);
      
      state = AsyncValue.data(user);
      CrashReportingService.logInfo('User registration successful');
      CrashReportingService.recordUserAction('register_success', data: {'email': request.email});
    } catch (e) {
      CrashReportingService.logError('User registration failed', e, StackTrace.current);
      CrashReportingService.recordUserAction('register_failed', data: {'email': request.email, 'error': e.toString()});
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    CrashReportingService.recordUserAction('login_attempt', data: {'email': email});
    
    try {
      final authRepository = ref.read(authRepositoryProvider);
      await authRepository.login(email, password);
      final user = await authRepository.getCurrentUser();
      
      // 기존 AuthState도 업데이트 (라우터 호환성을 위해)
      AuthState.instance.login(roles: ['USER']);
      
      state = AsyncValue.data(user);
      CrashReportingService.logInfo('User login successful');
      CrashReportingService.recordUserAction('login_success', data: {'email': email});
    } catch (e) {
      CrashReportingService.logError('User login failed', e, StackTrace.current);
      CrashReportingService.recordUserAction('login_failed', data: {'email': email, 'error': e.toString()});
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      final authRepository = ref.read(authRepositoryProvider);
      await authRepository.logout();
      
      // 기존 AuthState도 업데이트 (라우터 호환성을 위해)
      AuthState.instance.logout();
      
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  bool get isLoggedIn => state.value != null;

  Future<void> updateUserProfile(auth.UpdateUserRequest request) async {
    try {
      final authRepository = ref.read(authRepositoryProvider);
      await authRepository.updateUserProfile(request);
      
      // 사용자 정보 새로고침
      await _checkAuthState();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }
}

// 로그인 상태를 감시하는 별도 provider
@riverpod
Future<bool> isAuthenticated(Ref ref) async {
  final authRepository = ref.watch(authRepositoryProvider);
  return await authRepository.isLoggedIn();
}