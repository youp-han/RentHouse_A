// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tenant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TenantImpl _$$TenantImplFromJson(Map<String, dynamic> json) => _$TenantImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  phone: json['phone'] as String,
  email: json['email'] as String,
  socialNo: json['socialNo'] as String?,
  bday: json['bday'] as String?,
  personalNo: (json['personalNo'] as num?)?.toInt(),
  currentAddress: json['currentAddress'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$TenantImplToJson(_$TenantImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'email': instance.email,
      'socialNo': instance.socialNo,
      'bday': instance.bday,
      'personalNo': instance.personalNo,
      'currentAddress': instance.currentAddress,
      'createdAt': instance.createdAt.toIso8601String(),
    };
