import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import ProviderScope
import 'package:renthouse/app/app.dart';
import 'package:renthouse/core/logging/crash_reporting_service.dart';
import 'package:renthouse/core/services/database_backup_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 크래시 보고 시스템 초기화
  await CrashReportingService.initialize();

  // 보류 중인 데이터베이스 복원 확인 및 실행
  await DatabaseBackupService.checkAndPerformPendingRestore();

  // Flutter 프레임워크 오류 핸들링
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    CrashReportingService.logError(
      'Flutter framework error: ${details.summary}',
      details.exception,
      details.stack,
    );
  };

  runApp(const ProviderScope(child: RentHouseApp())); // Wrap with ProviderScope
}
