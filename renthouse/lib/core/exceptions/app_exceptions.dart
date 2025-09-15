/// 앱 전용 예외 클래스들
abstract class AppException implements Exception {
  final String message;
  final String? details;
  final String? stackTrace;

  const AppException(this.message, {this.details, this.stackTrace});

  @override
  String toString() {
    if (details != null) {
      return '$runtimeType: $message\nDetails: $details';
    }
    return '$runtimeType: $message';
  }
}

/// 인증 관련 예외
class AuthException extends AppException {
  const AuthException(super.message, {super.details, super.stackTrace});
}

/// 데이터베이스 관련 예외
class DatabaseException extends AppException {
  const DatabaseException(super.message, {super.details, super.stackTrace});
}

/// 네트워크 관련 예외
class NetworkException extends AppException {
  const NetworkException(super.message, {super.details, super.stackTrace});
}

/// 유효성 검사 예외
class ValidationException extends AppException {
  const ValidationException(super.message, {super.details, super.stackTrace});
}

/// 권한 관련 예외
class PermissionException extends AppException {
  const PermissionException(super.message, {super.details, super.stackTrace});
}

/// 비즈니스 로직 예외
class BusinessLogicException extends AppException {
  const BusinessLogicException(super.message, {super.details, super.stackTrace});
}

/// 파일 시스템 관련 예외
class FileSystemException extends AppException {
  const FileSystemException(super.message, {super.details, super.stackTrace});
}