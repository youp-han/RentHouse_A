import 'dart:async';
import 'dart:io';

import 'package:renthouse/core/database/connection.dart' as db_connection;
import 'package:renthouse/core/services/database_backup_service.dart';
import 'package:renthouse/core/logging/crash_reporting_service.dart';

/// 앱 시작 후 백그라운드에서 실행할 초기화 작업들을 관리하는 서비스
class BackgroundInitializationService {
  static bool _isInitialized = false;
  static bool _isInitializing = false;

  /// 백그라운드 초기화 작업들을 시작합니다.
  /// 이 메서드는 비동기적으로 실행되며 앱 시작을 블로킹하지 않습니다.
  static void startBackgroundInitialization() {
    if (_isInitialized || _isInitializing) {
      return;
    }

    _isInitializing = true;

    // 백그라운드에서 실행 (메인 스레드 블로킹 방지)
    Timer.run(() async {
      try {
        await _performBackgroundTasks();
        _isInitialized = true;
        print('✅ 백그라운드 초기화 완료');
      } catch (e, stackTrace) {
        print('❌ 백그라운드 초기화 오류: $e');
        CrashReportingService.logError(
          'Background initialization failed',
          e,
          stackTrace,
        );
      } finally {
        _isInitializing = false;
      }
    });
  }

  /// 백그라운드에서 실행할 초기화 작업들
  static Future<void> _performBackgroundTasks() async {
    print('🚀 백그라운드 초기화 시작...');

    // 1. 데이터베이스 백그라운드 작업 (마이그레이션, 디버깅 정보 등)
    await _initializeDatabaseBackgroundTasks();

    // 2. 데이터베이스 복원 작업 (시간이 많이 걸릴 수 있음)
    await _initializeDatabaseRestore();

    // 3. 기타 백그라운드 작업들 (향후 추가 가능)
    await _initializeOtherServices();
  }

  /// 데이터베이스 관련 백그라운드 작업
  static Future<void> _initializeDatabaseBackgroundTasks() async {
    try {
      // connection.native.dart에서 추가한 백그라운드 작업 실행
      if (Platform.isAndroid || Platform.isIOS || Platform.isWindows || Platform.isLinux) {
        await db_connection.performBackgroundDatabaseTasks();
      }
    } catch (e) {
      print('데이터베이스 백그라운드 작업 오류: $e');
    }
  }

  /// 데이터베이스 복원 작업
  static Future<void> _initializeDatabaseRestore() async {
    try {
      // 보류 중인 데이터베이스 복원 확인 및 실행
      await DatabaseBackupService.checkAndPerformPendingRestore();
    } catch (e) {
      print('데이터베이스 복원 작업 오류: $e');
    }
  }

  /// 기타 서비스 초기화
  static Future<void> _initializeOtherServices() async {
    try {
      // 향후 추가할 백그라운드 초기화 작업들
      // 예: 캐시 정리, 로그 정리, 업데이트 확인 등

      // 의도적으로 짧은 지연을 추가하여 UI 스레드에 CPU 시간 양보
      await Future.delayed(const Duration(milliseconds: 100));
    } catch (e) {
      print('기타 서비스 초기화 오류: $e');
    }
  }

  /// 백그라운드 초기화가 완료되었는지 확인
  static bool get isInitialized => _isInitialized;

  /// 백그라운드 초기화가 진행 중인지 확인
  static bool get isInitializing => _isInitializing;
}