// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentImpl _$$PaymentImplFromJson(Map<String, dynamic> json) =>
    _$PaymentImpl(
      id: json['id'] as String,
      tenantId: json['tenantId'] as String,
      method: $enumDecode(_$PaymentMethodEnumMap, json['method']),
      amount: (json['amount'] as num).toInt(),
      paidDate: DateTime.parse(json['paidDate'] as String),
      memo: json['memo'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$PaymentImplToJson(_$PaymentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tenantId': instance.tenantId,
      'method': _$PaymentMethodEnumMap[instance.method]!,
      'amount': instance.amount,
      'paidDate': instance.paidDate.toIso8601String(),
      'memo': instance.memo,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$PaymentMethodEnumMap = {
  PaymentMethod.cash: 'cash',
  PaymentMethod.transfer: 'transfer',
  PaymentMethod.card: 'card',
  PaymentMethod.check: 'check',
  PaymentMethod.other: 'other',
};

_$CreatePaymentRequestImpl _$$CreatePaymentRequestImplFromJson(
  Map<String, dynamic> json,
) => _$CreatePaymentRequestImpl(
  tenantId: json['tenantId'] as String,
  method: $enumDecode(_$PaymentMethodEnumMap, json['method']),
  amount: (json['amount'] as num).toInt(),
  paidDate: DateTime.parse(json['paidDate'] as String),
  memo: json['memo'] as String?,
  manualAllocations: (json['manualAllocations'] as List<dynamic>?)
      ?.map((e) => PaymentAllocationRequest.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$CreatePaymentRequestImplToJson(
  _$CreatePaymentRequestImpl instance,
) => <String, dynamic>{
  'tenantId': instance.tenantId,
  'method': _$PaymentMethodEnumMap[instance.method]!,
  'amount': instance.amount,
  'paidDate': instance.paidDate.toIso8601String(),
  'memo': instance.memo,
  'manualAllocations': instance.manualAllocations,
};

_$PaymentAllocationRequestImpl _$$PaymentAllocationRequestImplFromJson(
  Map<String, dynamic> json,
) => _$PaymentAllocationRequestImpl(
  billingId: json['billingId'] as String,
  amount: (json['amount'] as num).toInt(),
);

Map<String, dynamic> _$$PaymentAllocationRequestImplToJson(
  _$PaymentAllocationRequestImpl instance,
) => <String, dynamic>{
  'billingId': instance.billingId,
  'amount': instance.amount,
};
