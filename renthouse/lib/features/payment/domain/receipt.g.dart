// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReceiptImpl _$$ReceiptImplFromJson(Map<String, dynamic> json) =>
    _$ReceiptImpl(
      id: json['id'] as String,
      paymentId: json['paymentId'] as String,
      tenantId: json['tenantId'] as String,
      tenantName: json['tenantName'] as String,
      tenantPhone: json['tenantPhone'] as String,
      paymentMethod: $enumDecode(_$PaymentMethodEnumMap, json['paymentMethod']),
      totalAmount: (json['totalAmount'] as num).toInt(),
      paidDate: DateTime.parse(json['paidDate'] as String),
      issuedDate: DateTime.parse(json['issuedDate'] as String),
      memo: json['memo'] as String?,
      items: (json['items'] as List<dynamic>)
          .map((e) => ReceiptItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ReceiptImplToJson(_$ReceiptImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'paymentId': instance.paymentId,
      'tenantId': instance.tenantId,
      'tenantName': instance.tenantName,
      'tenantPhone': instance.tenantPhone,
      'paymentMethod': _$PaymentMethodEnumMap[instance.paymentMethod]!,
      'totalAmount': instance.totalAmount,
      'paidDate': instance.paidDate.toIso8601String(),
      'issuedDate': instance.issuedDate.toIso8601String(),
      'memo': instance.memo,
      'items': instance.items,
    };

const _$PaymentMethodEnumMap = {
  PaymentMethod.cash: 'cash',
  PaymentMethod.transfer: 'transfer',
  PaymentMethod.card: 'card',
  PaymentMethod.check: 'check',
  PaymentMethod.other: 'other',
};

_$ReceiptItemImpl _$$ReceiptItemImplFromJson(Map<String, dynamic> json) =>
    _$ReceiptItemImpl(
      billingId: json['billingId'] as String,
      yearMonth: json['yearMonth'] as String,
      propertyName: json['propertyName'] as String,
      unitNumber: json['unitNumber'] as String,
      amount: (json['amount'] as num).toInt(),
      description: json['description'] as String,
    );

Map<String, dynamic> _$$ReceiptItemImplToJson(_$ReceiptItemImpl instance) =>
    <String, dynamic>{
      'billingId': instance.billingId,
      'yearMonth': instance.yearMonth,
      'propertyName': instance.propertyName,
      'unitNumber': instance.unitNumber,
      'amount': instance.amount,
      'description': instance.description,
    };
