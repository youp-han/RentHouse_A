import 'package:flutter/foundation.dart';
import 'package:renthouse/core/exceptions/app_exceptions.dart';

enum LogLevel {
  debug,
  info,
  warning,
  error,
  fatal,
}

/// 앱 전용 로거 클래스
class AppLogger {
  static const String _appTag = 'RentHouse';
  
  static void debug(String message, {String? tag, Object? details}) {
    _log(LogLevel.debug, message, tag: tag, details: details);
  }
  
  static void info(String message, {String? tag, Object? details}) {
    _log(LogLevel.info, message, tag: tag, details: details);
  }
  
  static void warning(String message, {String? tag, Object? details}) {
    _log(LogLevel.warning, message, tag: tag, details: details);
  }
  
  static void error(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.error, message, tag: tag, details: error, stackTrace: stackTrace);
  }
  
  static void fatal(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.fatal, message, tag: tag, details: error, stackTrace: stackTrace);
  }

  /// 예외 전용 로깅 메서드
  static void logException(AppException exception, {String? tag, StackTrace? stackTrace}) {
    final effectiveTag = tag ?? exception.runtimeType.toString();
    error(
      exception.message,
      tag: effectiveTag,
      error: exception.details,
      stackTrace: stackTrace,
    );
  }

  /// 데이터베이스 작업 로깅
  static void logDatabaseOperation(String operation, {String? table, Map<String, dynamic>? data}) {
    if (kDebugMode) {
      final details = {
        'operation': operation,
        if (table != null) 'table': table,
        if (data != null) 'data': _sanitizeData(data),
      };
      debug('Database operation: $operation', tag: 'Database', details: details);
    }
  }

  /// 인증 작업 로깅 (민감 정보 제거)
  static void logAuthOperation(String operation, {String? userId, bool success = true}) {
    if (kDebugMode) {
      final maskedUserId = userId != null && userId.length > 8 
          ? '${userId.substring(0, 8)}***' 
          : '***';
      final status = success ? 'SUCCESS' : 'FAILED';
      info('Auth operation: $operation - $status', tag: 'Auth', details: {'userId': maskedUserId});
    }
  }

  /// API 요청 로깅
  static void logApiRequest(String method, String url, {int? statusCode, Duration? duration}) {
    if (kDebugMode) {
      final details = {
        'method': method,
        'url': url,
        if (statusCode != null) 'statusCode': statusCode,
        if (duration != null) 'duration': '${duration.inMilliseconds}ms',
      };
      info('API request: $method $url', tag: 'API', details: details);
    }
  }

  static void _log(
    LogLevel level, 
    String message, {
    String? tag, 
    Object? details, 
    StackTrace? stackTrace
  }) {
    if (!kDebugMode && level == LogLevel.debug) return;

    final effectiveTag = tag ?? _appTag;
    final timestamp = DateTime.now().toIso8601String();
    final levelStr = level.name.toUpperCase().padRight(7);
    
    String logMessage = '[$timestamp] $levelStr [$effectiveTag] $message';
    
    if (details != null) {
      logMessage += '\n  Details: $details';
    }
    
    if (stackTrace != null) {
      logMessage += '\n  StackTrace: $stackTrace';
    }

    // 개발 모드에서는 print 사용, 프로덕션에서는 실제 로깅 서비스 사용
    if (kDebugMode) {
      print(logMessage);
    } else {
      // TODO: 프로덕션 로깅 서비스 통합 (Firebase Crashlytics, Sentry 등)
      _sendToLoggingService(level, message, effectiveTag, details, stackTrace);
    }
  }

  /// 민감한 데이터 제거
  static Map<String, dynamic> _sanitizeData(Map<String, dynamic> data) {
    final sanitized = <String, dynamic>{};
    final sensitiveKeys = ['password', 'token', 'secret', 'key', 'auth', 'credential'];
    
    for (final entry in data.entries) {
      final key = entry.key.toLowerCase();
      if (sensitiveKeys.any((sensitive) => key.contains(sensitive))) {
        sanitized[entry.key] = '***';
      } else {
        sanitized[entry.key] = entry.value;
      }
    }
    
    return sanitized;
  }

  static void _sendToLoggingService(
    LogLevel level, 
    String message, 
    String tag, 
    Object? details, 
    StackTrace? stackTrace
  ) {
    // TODO: 실제 로깅 서비스로 전송 구현
    // 예: Firebase Crashlytics, Sentry, CloudWatch 등
  }
}

/// 성능 측정용 유틸리티
class PerformanceLogger {
  static final Map<String, DateTime> _startTimes = {};

  static void startTimer(String operation) {
    _startTimes[operation] = DateTime.now();
    AppLogger.debug('Performance timer started for: $operation', tag: 'Performance');
  }

  static void endTimer(String operation, {Map<String, dynamic>? additionalData}) {
    final startTime = _startTimes.remove(operation);
    if (startTime != null) {
      final duration = DateTime.now().difference(startTime);
      final details = {
        'duration': '${duration.inMilliseconds}ms',
        if (additionalData != null) ...additionalData,
      };
      AppLogger.info('Performance: $operation completed', tag: 'Performance', details: details);
    }
  }
}