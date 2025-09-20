import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import ProviderScope
import 'package:renthouse/app/app.dart';
import 'package:renthouse/core/logging/crash_reporting_service.dart';
import 'package:renthouse/core/services/background_initialization_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 필수 초기화만 동기적으로 실행
  await _initializeEssentialServices();

  // 앱 시작 후 백그라운드에서 비필수 초기화 실행
  BackgroundInitializationService.startBackgroundInitialization();

  runApp(const ProviderScope(child: RentHouseApp()));
}

/// 앱 시작에 반드시 필요한 필수 서비스들만 초기화
Future<void> _initializeEssentialServices() async {
  try {
    // 크래시 보고 시스템 초기화 (필수)
    await CrashReportingService.initialize();

    // Flutter 프레임워크 오류 핸들링 설정
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      CrashReportingService.logError(
        'Flutter framework error: ${details.summary}',
        details.exception,
        details.stack,
      );
    };

    print('✅ 필수 서비스 초기화 완료');
  } catch (e, stackTrace) {
    print('❌ 필수 서비스 초기화 오류: $e');
    // 크래시 보고가 초기화되지 않았을 수 있으므로 print만 사용
  }
}
