// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
  id: json['id'] as String,
  email: json['email'] as String,
  name: json['name'] as String,
  passwordHash: json['passwordHash'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'passwordHash': instance.passwordHash,
      'createdAt': instance.createdAt.toIso8601String(),
    };

_$RegisterUserRequestImpl _$$RegisterUserRequestImplFromJson(
  Map<String, dynamic> json,
) => _$RegisterUserRequestImpl(
  email: json['email'] as String,
  name: json['name'] as String,
  password: json['password'] as String,
);

Map<String, dynamic> _$$RegisterUserRequestImplToJson(
  _$RegisterUserRequestImpl instance,
) => <String, dynamic>{
  'email': instance.email,
  'name': instance.name,
  'password': instance.password,
};

_$LoginRequestImpl _$$LoginRequestImplFromJson(Map<String, dynamic> json) =>
    _$LoginRequestImpl(
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$$LoginRequestImplToJson(_$LoginRequestImpl instance) =>
    <String, dynamic>{'email': instance.email, 'password': instance.password};

_$UpdateUserRequestImpl _$$UpdateUserRequestImplFromJson(
  Map<String, dynamic> json,
) => _$UpdateUserRequestImpl(
  name: json['name'] as String?,
  currentPassword: json['currentPassword'] as String?,
  newPassword: json['newPassword'] as String?,
);

Map<String, dynamic> _$$UpdateUserRequestImplToJson(
  _$UpdateUserRequestImpl instance,
) => <String, dynamic>{
  'name': instance.name,
  'currentPassword': instance.currentPassword,
  'newPassword': instance.newPassword,
};
