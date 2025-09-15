// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lease.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LeaseImpl _$$LeaseImplFromJson(Map<String, dynamic> json) => _$LeaseImpl(
  id: json['id'] as String,
  tenantId: json['tenantId'] as String,
  unitId: json['unitId'] as String,
  startDate: DateTime.parse(json['startDate'] as String),
  endDate: DateTime.parse(json['endDate'] as String),
  deposit: (json['deposit'] as num).toInt(),
  monthlyRent: (json['monthlyRent'] as num).toInt(),
  leaseType: $enumDecode(_$LeaseTypeEnumMap, json['leaseType']),
  leaseStatus: $enumDecode(_$LeaseStatusEnumMap, json['leaseStatus']),
  contractNotes: json['contractNotes'] as String?,
);

Map<String, dynamic> _$$LeaseImplToJson(_$LeaseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tenantId': instance.tenantId,
      'unitId': instance.unitId,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'deposit': instance.deposit,
      'monthlyRent': instance.monthlyRent,
      'leaseType': _$LeaseTypeEnumMap[instance.leaseType]!,
      'leaseStatus': _$LeaseStatusEnumMap[instance.leaseStatus]!,
      'contractNotes': instance.contractNotes,
    };

const _$LeaseTypeEnumMap = {
  LeaseType.jeonse: 'jeonse',
  LeaseType.monthly: 'monthly',
  LeaseType.yearly: 'yearly',
};

const _$LeaseStatusEnumMap = {
  LeaseStatus.active: 'active',
  LeaseStatus.terminated: 'terminated',
  LeaseStatus.expired: 'expired',
  LeaseStatus.pending: 'pending',
};
