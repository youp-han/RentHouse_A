import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CrashReportingService {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 3,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  static const String _consentKey = 'crash_reporting_consent';
  static const String _deviceIdKey = 'anonymous_device_id';
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  
  static bool _isInitialized = false;
  static bool _hasUserConsent = false;

  /// Sentry DSN - 실제 프로젝트에서는 환경변수나 설정 파일에서 관리
  static const String _sentryDsn = 'YOUR_SENTRY_DSN_HERE';

  /// 초기화 - 앱 시작 시 호출
  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // 사용자 동의 확인
      final consentString = await _storage.read(key: _consentKey);
      _hasUserConsent = consentString == 'true';

      if (_hasUserConsent) {
        await _initializeSentry();
      }

      _isInitialized = true;
      _logger.i('CrashReportingService initialized. User consent: $_hasUserConsent');
    } catch (e) {
      _logger.e('Failed to initialize CrashReportingService', error: e);
    }
  }

  /// Sentry 초기화
  static Future<void> _initializeSentry() async {
    await SentryFlutter.init(
      (options) {
        options.dsn = _sentryDsn;
        options.debug = kDebugMode;
        options.environment = kDebugMode ? 'development' : 'production';
        options.tracesSampleRate = kDebugMode ? 1.0 : 0.1;
        
        // 개인정보 필터링
        options.beforeSend = _beforeSendFilter;
        
        // 릴리스 정보 설정
        options.release = 'renthouse@1.0.0'; // 실제 버전으로 교체
      },
    );

    // 디바이스 정보 및 사용자 컨텍스트 설정
    await _setUserContext();
  }

  /// 사용자 동의 요청 및 저장
  static Future<void> setUserConsent(bool hasConsent) async {
    _hasUserConsent = hasConsent;
    await _storage.write(key: _consentKey, value: hasConsent.toString());

    if (hasConsent && !_isInitialized) {
      await _initializeSentry();
    } else if (!hasConsent) {
      await Sentry.close();
    }

    _logger.i('User consent updated: $hasConsent');
  }

  /// 사용자 동의 상태 확인
  static Future<bool> getUserConsent() async {
    if (!_isInitialized) {
      final consentString = await _storage.read(key: _consentKey);
      return consentString == 'true';
    }
    return _hasUserConsent;
  }

  /// 사용자 동의를 받았는지 확인 (최초 실행 체크)
  static Future<bool> hasAskedForConsent() async {
    final consentString = await _storage.read(key: _consentKey);
    return consentString != null;
  }

  /// 사용자 컨텍스트 설정
  static Future<void> _setUserContext() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      final packageInfo = await PackageInfo.fromPlatform();
      
      // 익명 디바이스 ID 생성 또는 조회
      String? deviceId = await _storage.read(key: _deviceIdKey);
      if (deviceId == null) {
        deviceId = DateTime.now().millisecondsSinceEpoch.toString();
        await _storage.write(key: _deviceIdKey, value: deviceId);
      }

      // 플랫폼별 디바이스 정보
      Map<String, dynamic> deviceData = {};
      
      if (Platform.isWindows) {
        final windowsInfo = await deviceInfo.windowsInfo;
        deviceData = {
          'platform': 'Windows',
          'version': windowsInfo.displayVersion,
          'build': windowsInfo.buildNumber.toString(),
          'machine': windowsInfo.computerName,
        };
      } else if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        deviceData = {
          'platform': 'Android',
          'version': androidInfo.version.release,
          'model': androidInfo.model,
          'manufacturer': androidInfo.manufacturer,
        };
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        deviceData = {
          'platform': 'iOS',
          'version': iosInfo.systemVersion,
          'model': iosInfo.model,
        };
      }

      // Sentry 사용자 컨텍스트 설정
      Sentry.configureScope((scope) {
        scope.setUser(SentryUser(
          id: deviceId,
          data: deviceData,
        ));
        
        scope.setTag('app.version', packageInfo.version);
        scope.setTag('app.build', packageInfo.buildNumber);
        scope.setTag('flutter.debug', kDebugMode.toString());
      });

    } catch (e) {
      _logger.e('Failed to set user context', error: e);
    }
  }

  /// 개인정보 필터링
  static SentryEvent? _beforeSendFilter(SentryEvent event, Hint hint) {
    // 민감한 정보가 포함된 경우 필터링
    if (event.message?.formatted != null && 
        (event.message!.formatted!.contains('password') || 
         event.message!.formatted!.contains('token'))) {
      return null; // 이벤트를 전송하지 않음
    }

    // 개발자 이메일 추가
    event = event.copyWith(
      contexts: event.contexts?.copyWith(
        app: event.contexts!.app?.copyWith(
          name: 'RentHouse',
        ),
      ),
      tags: {
        ...event.tags ?? {},
        'developer.email': 'youp.han+uk@gmail.com',
      },
    );

    return event;
  }

  /// 로그 레벨별 메서드들
  static void logDebug(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  static void logInfo(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  static void logWarning(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
    
    if (_hasUserConsent) {
      Sentry.addBreadcrumb(Breadcrumb(
        message: message,
        level: SentryLevel.warning,
        timestamp: DateTime.now().toUtc(),
      ));
    }
  }

  static void logError(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
    
    if (_hasUserConsent && error != null) {
      Sentry.captureException(
        error,
        stackTrace: stackTrace,
        withScope: (scope) {
          scope.level = SentryLevel.error;
          scope.setTag('custom.message', message);
        },
      );
    }
  }

  static void logFatal(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);
    
    if (_hasUserConsent) {
      Sentry.captureException(
        error ?? Exception(message),
        stackTrace: stackTrace,
        withScope: (scope) {
          scope.level = SentryLevel.fatal;
          scope.setTag('custom.message', message);
        },
      );
    }
  }

  /// 수동으로 예외 보고
  static Future<void> reportException(
    dynamic exception, 
    StackTrace? stackTrace, {
    String? context,
    Map<String, dynamic>? extra,
  }) async {
    if (!_hasUserConsent) return;

    await Sentry.captureException(
      exception,
      stackTrace: stackTrace,
      withScope: (scope) {
        if (context != null) {
          scope.setTag('context', context);
        }
        if (extra != null) {
          for (final entry in extra.entries) {
            scope.setExtra(entry.key, entry.value);
          }
        }
      },
    );
  }

  /// 사용자 액션 추적 (Breadcrumb)
  static void recordUserAction(String action, {Map<String, dynamic>? data}) {
    _logger.d('User action: $action', error: data);
    
    if (_hasUserConsent) {
      Sentry.addBreadcrumb(Breadcrumb(
        message: action,
        category: 'user_action',
        data: data,
        timestamp: DateTime.now().toUtc(),
      ));
    }
  }

  /// 앱 성능 측정 시작
  static ISentrySpan? startTransaction(String operation, String description) {
    if (!_hasUserConsent) return null;
    
    return Sentry.startTransaction(
      operation,
      description,
      autoFinishAfter: const Duration(seconds: 30),
    );
  }
}