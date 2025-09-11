// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'billing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BillingImpl _$$BillingImplFromJson(Map<String, dynamic> json) =>
    _$BillingImpl(
      id: json['id'] as String,
      leaseId: json['leaseId'] as String,
      yearMonth: json['yearMonth'] as String,
      issueDate: DateTime.parse(json['issueDate'] as String),
      dueDate: DateTime.parse(json['dueDate'] as String),
      paid: json['paid'] as bool? ?? false,
      paidDate: json['paidDate'] == null
          ? null
          : DateTime.parse(json['paidDate'] as String),
      totalAmount: (json['totalAmount'] as num).toInt(),
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => BillingItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      status:
          $enumDecodeNullable(_$BillingStatusEnumMap, json['status']) ??
          BillingStatus.draft,
    );

Map<String, dynamic> _$$BillingImplToJson(_$BillingImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'leaseId': instance.leaseId,
      'yearMonth': instance.yearMonth,
      'issueDate': instance.issueDate.toIso8601String(),
      'dueDate': instance.dueDate.toIso8601String(),
      'paid': instance.paid,
      'paidDate': instance.paidDate?.toIso8601String(),
      'totalAmount': instance.totalAmount,
      'items': instance.items,
      'status': _$BillingStatusEnumMap[instance.status]!,
    };

const _$BillingStatusEnumMap = {
  BillingStatus.draft: 'draft',
  BillingStatus.issued: 'issued',
  BillingStatus.partiallyPaid: 'partiallyPaid',
  BillingStatus.paid: 'paid',
  BillingStatus.overdue: 'overdue',
  BillingStatus.voided: 'voided',
};
