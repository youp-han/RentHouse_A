// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'billing_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BillingItemImpl _$$BillingItemImplFromJson(Map<String, dynamic> json) =>
    _$BillingItemImpl(
      id: json['id'] as String,
      billingId: json['billingId'] as String,
      billTemplateId: json['billTemplateId'] as String,
      amount: (json['amount'] as num).toInt(),
      itemName: json['itemName'] as String?,
    );

Map<String, dynamic> _$$BillingItemImplToJson(_$BillingItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'billingId': instance.billingId,
      'billTemplateId': instance.billTemplateId,
      'amount': instance.amount,
      'itemName': instance.itemName,
    };
