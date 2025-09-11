import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String email,
    required String name,
    required String passwordHash,
    required DateTime createdAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

// 회원가입용 모델 (비밀번호 평문)
@freezed
class RegisterUserRequest with _$RegisterUserRequest {
  const factory RegisterUserRequest({
    required String email,
    required String name,
    required String password,
  }) = _RegisterUserRequest;

  factory RegisterUserRequest.fromJson(Map<String, dynamic> json) => 
    _$RegisterUserRequestFromJson(json);
}

// 로그인용 모델
@freezed
class LoginRequest with _$LoginRequest {
  const factory LoginRequest({
    required String email,
    required String password,
  }) = _LoginRequest;

  factory LoginRequest.fromJson(Map<String, dynamic> json) => 
    _$LoginRequestFromJson(json);
}

// 사용자 프로필 업데이트용 모델
@freezed
class UpdateUserRequest with _$UpdateUserRequest {
  const factory UpdateUserRequest({
    String? name,
    String? currentPassword,
    String? newPassword,
  }) = _UpdateUserRequest;

  factory UpdateUserRequest.fromJson(Map<String, dynamic> json) => 
    _$UpdateUserRequestFromJson(json);
}