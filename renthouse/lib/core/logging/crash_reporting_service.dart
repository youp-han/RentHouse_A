import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';

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
  static const String _crashLogKey = 'pending_crash_logs';
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  
  static bool _isInitialized = false;
  static bool _hasUserConsent = false;
  static List<Map<String, dynamic>> _pendingCrashLogs = [];
  static Map<String, dynamic>? _deviceInfo;

  /// 개발자 이메일
  static const String _developerEmail = 'youp.han+uk@gmail.com';

  /// 초기화 - 앱 시작 시 호출
  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // 사용자 동의 확인
      final consentString = await _storage.read(key: _consentKey);
      _hasUserConsent = consentString == 'true';

      if (_hasUserConsent) {
        await _initializeDeviceInfo();
        await _loadPendingCrashLogs();
      } else {
        // 동의하지 않았어도 기존 로그가 있다면 정리
        await _loadPendingCrashLogs();
      }

      _isInitialized = true;
      _logger.i('CrashReportingService initialized. User consent: $_hasUserConsent, Pending logs: ${_pendingCrashLogs.length}');
    } catch (e) {
      _logger.e('Failed to initialize CrashReportingService', error: e);
    }
  }

  /// 디바이스 정보 초기화
  static Future<void> _initializeDeviceInfo() async {
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
      Map<String, dynamic> deviceData = {
        'device_id': deviceId,
        'app_version': packageInfo.version,
        'app_build': packageInfo.buildNumber,
        'flutter_debug': kDebugMode,
        'timestamp': DateTime.now().toIso8601String(),
      };
      
      if (Platform.isWindows) {
        final windowsInfo = await deviceInfo.windowsInfo;
        deviceData.addAll({
          'platform': 'Windows',
          'version': windowsInfo.displayVersion,
          'build': windowsInfo.buildNumber.toString(),
          'machine': windowsInfo.computerName,
        });
      } else if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        deviceData.addAll({
          'platform': 'Android',
          'version': androidInfo.version.release,
          'model': androidInfo.model,
          'manufacturer': androidInfo.manufacturer,
        });
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        deviceData.addAll({
          'platform': 'iOS',
          'version': iosInfo.systemVersion,
          'model': iosInfo.model,
        });
      }

      _deviceInfo = deviceData;
    } catch (e) {
      _logger.e('Failed to initialize device info', error: e);
    }
  }

  /// 저장된 크래시 로그 불러오기
  static Future<void> _loadPendingCrashLogs() async {
    try {
      final logsString = await _storage.read(key: _crashLogKey);
      if (logsString != null) {
        final List<dynamic> logs = jsonDecode(logsString);
        _pendingCrashLogs = logs.cast<Map<String, dynamic>>();
        
        // 7일 자동 정리 정책 적용
        await _cleanupOldLogs();
      }
    } catch (e) {
      _logger.e('Failed to load pending crash logs', error: e);
      _pendingCrashLogs = [];
    }
  }

  /// 7일이 지난 오래된 로그 자동 정리
  static Future<void> _cleanupOldLogs() async {
    final now = DateTime.now();
    final cutoffDate = now.subtract(const Duration(days: 7));
    
    final originalCount = _pendingCrashLogs.length;
    
    _pendingCrashLogs.removeWhere((log) {
      try {
        final timestampString = log['timestamp'] as String;
        final logDate = DateTime.parse(timestampString);
        return logDate.isBefore(cutoffDate);
      } catch (e) {
        // 파싱 실패한 로그는 삭제
        return true;
      }
    });
    
    final removedCount = originalCount - _pendingCrashLogs.length;
    
    if (removedCount > 0) {
      await _savePendingCrashLogs();
      _logger.i('Cleaned up $removedCount old crash logs (older than 7 days)');
    }
  }

  /// 크래시 로그 저장
  static Future<void> _savePendingCrashLogs() async {
    try {
      final logsString = jsonEncode(_pendingCrashLogs);
      await _storage.write(key: _crashLogKey, value: logsString);
    } catch (e) {
      _logger.e('Failed to save pending crash logs', error: e);
    }
  }

  /// 사용자 동의 요청 및 저장
  static Future<void> setUserConsent(bool hasConsent) async {
    _hasUserConsent = hasConsent;
    await _storage.write(key: _consentKey, value: hasConsent.toString());

    if (hasConsent && !_isInitialized) {
      await _initializeDeviceInfo();
      await _loadPendingCrashLogs();
    } else if (!hasConsent) {
      // 동의 철회 시 저장된 로그 삭제
      await _storage.delete(key: _crashLogKey);
      _pendingCrashLogs.clear();
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
      _addCrashLog('WARNING', message, error, stackTrace);
    }
  }

  static void logError(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
    
    if (_hasUserConsent && error != null) {
      _addCrashLog('ERROR', message, error, stackTrace);
    }
  }

  static void logFatal(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);
    
    if (_hasUserConsent) {
      _addCrashLog('FATAL', message, error ?? Exception(message), stackTrace);
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

    _addCrashLog('EXCEPTION', context ?? 'Manual exception report', exception, stackTrace, extra);
  }

  /// 사용자 액션 추적 (Breadcrumb)
  static void recordUserAction(String action, {Map<String, dynamic>? data}) {
    _logger.d('User action: $action', error: data);
  }

  /// 크래시 로그 추가
  static void _addCrashLog(
    String level, 
    String message, 
    dynamic error, 
    StackTrace? stackTrace, [
    Map<String, dynamic>? extra,
  ]) {
    if (!_hasUserConsent) return;

    final crashLog = {
      'timestamp': DateTime.now().toIso8601String(),
      'level': level,
      'message': message,
      'error': error?.toString(),
      'stack_trace': stackTrace?.toString(),
      'device_info': _deviceInfo,
      'extra': extra,
    };

    _pendingCrashLogs.add(crashLog);
    _savePendingCrashLogs();

    // 즉시 이메일 전송 시도 (중요한 오류의 경우)
    if (level == 'FATAL' || level == 'ERROR') {
      _trySendEmail(crashLog);
    }
  }

  /// 이메일 전송 시도
  static Future<void> _trySendEmail(Map<String, dynamic> crashLog) async {
    try {
      final subject = '🚨 RentHouse 앱 ${crashLog['level']} 리포트';
      final body = _generateEmailBody(crashLog);
      
      // 기본 메일 앱으로 이메일 작성 창 열기
      final emailUri = Uri(
        scheme: 'mailto',
        path: _developerEmail,
        query: _encodeQueryParameters({
          'subject': subject,
          'body': body,
        }),
      );

      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
        _logger.i('Email client opened for crash report');
      } else {
        _logger.w('Cannot open email client');
      }
    } catch (e) {
      _logger.e('Failed to send email', error: e);
    }
  }

  /// 이메일 본문 생성
  static String _generateEmailBody(Map<String, dynamic> crashLog) {
    final buffer = StringBuffer();
    
    buffer.writeln('RentHouse 앱에서 ${crashLog['level']} 레벨의 오류가 발생했습니다.\n');
    buffer.writeln('발생 시각: ${crashLog['timestamp']}');
    buffer.writeln('메시지: ${crashLog['message']}\n');
    
    if (crashLog['error'] != null) {
      buffer.writeln('오류 내용:');
      buffer.writeln('${crashLog['error']}\n');
    }
    
    if (crashLog['stack_trace'] != null) {
      buffer.writeln('스택 트레이스:');
      buffer.writeln('${crashLog['stack_trace']}\n');
    }
    
    if (crashLog['device_info'] != null) {
      buffer.writeln('디바이스 정보:');
      final deviceInfo = crashLog['device_info'] as Map<String, dynamic>;
      deviceInfo.forEach((key, value) {
        buffer.writeln('- $key: $value');
      });
      buffer.writeln();
    }
    
    if (crashLog['extra'] != null) {
      buffer.writeln('추가 정보:');
      final extra = crashLog['extra'] as Map<String, dynamic>;
      extra.forEach((key, value) {
        buffer.writeln('- $key: $value');
      });
    }
    
    return buffer.toString();
  }

  /// URL 쿼리 파라미터 인코딩
  static String _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  /// 수동으로 저장된 모든 크래시 로그 이메일 전송
  static Future<void> sendAllPendingLogs() async {
    if (!_hasUserConsent || _pendingCrashLogs.isEmpty) return;

    try {
      final subject = '📋 RentHouse 앱 누적 로그 리포트 (${_pendingCrashLogs.length}건)';
      final body = _generateAllLogsEmailBody();
      
      final emailUri = Uri(
        scheme: 'mailto',
        path: _developerEmail,
        query: _encodeQueryParameters({
          'subject': subject,
          'body': body,
        }),
      );

      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
        
        // 전송 후 로그 클리어
        _pendingCrashLogs.clear();
        await _storage.delete(key: _crashLogKey);
        
        _logger.i('All pending logs sent via email');
      } else {
        _logger.w('Cannot open email client');
      }
    } catch (e) {
      _logger.e('Failed to send all logs', error: e);
    }
  }

  /// 모든 로그의 이메일 본문 생성
  static String _generateAllLogsEmailBody() {
    final buffer = StringBuffer();
    
    buffer.writeln('RentHouse 앱에서 발생한 전체 로그 리포트입니다.\n');
    buffer.writeln('총 ${_pendingCrashLogs.length}건의 로그가 있습니다.');
    buffer.writeln('(7일이 지난 오래된 로그는 자동으로 정리되었습니다)\n');
    buffer.writeln('=' * 50);
    
    for (int i = 0; i < _pendingCrashLogs.length; i++) {
      final log = _pendingCrashLogs[i];
      buffer.writeln('\n${i + 1}. ${log['level']} - ${log['timestamp']}');
      buffer.writeln('메시지: ${log['message']}');
      
      if (log['error'] != null) {
        buffer.writeln('오류: ${log['error']}');
      }
      
      if (log['extra'] != null) {
        buffer.writeln('추가정보: ${log['extra']}');
      }
      
      buffer.writeln('-' * 30);
    }
    
    // 디바이스 정보는 한 번만 추가
    if (_deviceInfo != null) {
      buffer.writeln('\n디바이스 정보:');
      _deviceInfo!.forEach((key, value) {
        buffer.writeln('- $key: $value');
      });
    }
    
    return buffer.toString();
  }

  /// 저장된 로그 개수 확인
  static int getPendingLogCount() {
    return _pendingCrashLogs.length;
  }

  /// 저장된 로그 목록 확인
  static List<Map<String, dynamic>> getPendingLogs() {
    return List.unmodifiable(_pendingCrashLogs);
  }
}