// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill_template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BillTemplateImpl _$$BillTemplateImplFromJson(Map<String, dynamic> json) =>
    _$BillTemplateImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      amount: (json['amount'] as num).toInt(),
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$BillTemplateImplToJson(_$BillTemplateImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': instance.category,
      'amount': instance.amount,
      'description': instance.description,
    };
