// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ActivityLogImpl _$$ActivityLogImplFromJson(Map<String, dynamic> json) =>
    _$ActivityLogImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      activityType: $enumDecode(_$ActivityTypeEnumMap, json['activityType']),
      description: json['description'] as String,
      entityType: json['entityType'] as String,
      entityId: json['entityId'] as String,
      entityName: json['entityName'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$ActivityLogImplToJson(_$ActivityLogImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'activityType': _$ActivityTypeEnumMap[instance.activityType]!,
      'description': instance.description,
      'entityType': instance.entityType,
      'entityId': instance.entityId,
      'entityName': instance.entityName,
      'metadata': instance.metadata,
      'timestamp': instance.timestamp.toIso8601String(),
    };

const _$ActivityTypeEnumMap = {
  ActivityType.create: 'create',
  ActivityType.update: 'update',
  ActivityType.delete: 'delete',
  ActivityType.login: 'login',
  ActivityType.logout: 'logout',
  ActivityType.payment: 'payment',
  ActivityType.billing: 'billing',
  ActivityType.other: 'other',
};
