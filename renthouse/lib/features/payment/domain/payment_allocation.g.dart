// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_allocation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentAllocationImpl _$$PaymentAllocationImplFromJson(
  Map<String, dynamic> json,
) => _$PaymentAllocationImpl(
  id: json['id'] as String,
  paymentId: json['paymentId'] as String,
  billingId: json['billingId'] as String,
  amount: (json['amount'] as num).toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$PaymentAllocationImplToJson(
  _$PaymentAllocationImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'paymentId': instance.paymentId,
  'billingId': instance.billingId,
  'amount': instance.amount,
  'createdAt': instance.createdAt.toIso8601String(),
};

_$PaymentAllocationPreviewImpl _$$PaymentAllocationPreviewImplFromJson(
  Map<String, dynamic> json,
) => _$PaymentAllocationPreviewImpl(
  billingId: json['billingId'] as String,
  yearMonth: json['yearMonth'] as String,
  billingAmount: (json['billingAmount'] as num).toInt(),
  paidAmount: (json['paidAmount'] as num).toInt(),
  allocationAmount: (json['allocationAmount'] as num).toInt(),
  remainingAmount: (json['remainingAmount'] as num).toInt(),
);

Map<String, dynamic> _$$PaymentAllocationPreviewImplToJson(
  _$PaymentAllocationPreviewImpl instance,
) => <String, dynamic>{
  'billingId': instance.billingId,
  'yearMonth': instance.yearMonth,
  'billingAmount': instance.billingAmount,
  'paidAmount': instance.paidAmount,
  'allocationAmount': instance.allocationAmount,
  'remainingAmount': instance.remainingAmount,
};

_$AutoAllocationResultImpl _$$AutoAllocationResultImplFromJson(
  Map<String, dynamic> json,
) => _$AutoAllocationResultImpl(
  totalAmount: (json['totalAmount'] as num).toInt(),
  allocatedAmount: (json['allocatedAmount'] as num).toInt(),
  remainingAmount: (json['remainingAmount'] as num).toInt(),
  allocations: (json['allocations'] as List<dynamic>)
      .map((e) => PaymentAllocationPreview.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$AutoAllocationResultImplToJson(
  _$AutoAllocationResultImpl instance,
) => <String, dynamic>{
  'totalAmount': instance.totalAmount,
  'allocatedAmount': instance.allocatedAmount,
  'remainingAmount': instance.remainingAmount,
  'allocations': instance.allocations,
};
