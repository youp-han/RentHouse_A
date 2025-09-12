// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BillingItemImpl _$$BillingItemImplFromJson(Map<String, dynamic> json) =>
    _$BillingItemImpl(
      name: json['name'] as String,
      amount: (json['amount'] as num).toInt(),
      isEnabled: json['isEnabled'] as bool? ?? true,
    );

Map<String, dynamic> _$$BillingItemImplToJson(_$BillingItemImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'amount': instance.amount,
      'isEnabled': instance.isEnabled,
    };

_$PropertyImpl _$$PropertyImplFromJson(Map<String, dynamic> json) =>
    _$PropertyImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      zipCode: json['zipCode'] as String?,
      address1: json['address1'] as String?,
      address2: json['address2'] as String?,
      address: json['address'] as String?,
      propertyType:
          $enumDecodeNullable(_$PropertyTypeEnumMap, json['propertyType']) ??
          PropertyType.villa,
      contractType:
          $enumDecodeNullable(_$ContractTypeEnumMap, json['contractType']) ??
          ContractType.wolse,
      totalUnits: (json['totalUnits'] as num).toInt(),
      rent: (json['rent'] as num?)?.toInt() ?? 0,
      ownerId: json['ownerId'] as String?,
      ownerName: json['ownerName'] as String?,
      ownerPhone: json['ownerPhone'] as String?,
      ownerEmail: json['ownerEmail'] as String?,
      defaultBillingItems:
          (json['defaultBillingItems'] as List<dynamic>?)
              ?.map((e) => BillingItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      units:
          (json['units'] as List<dynamic>?)
              ?.map((e) => Unit.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$PropertyImplToJson(_$PropertyImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'zipCode': instance.zipCode,
      'address1': instance.address1,
      'address2': instance.address2,
      'address': instance.address,
      'propertyType': _$PropertyTypeEnumMap[instance.propertyType]!,
      'contractType': _$ContractTypeEnumMap[instance.contractType]!,
      'totalUnits': instance.totalUnits,
      'rent': instance.rent,
      'ownerId': instance.ownerId,
      'ownerName': instance.ownerName,
      'ownerPhone': instance.ownerPhone,
      'ownerEmail': instance.ownerEmail,
      'defaultBillingItems': instance.defaultBillingItems,
      'units': instance.units,
    };

const _$PropertyTypeEnumMap = {
  PropertyType.villa: 'villa',
  PropertyType.apartment: 'apartment',
  PropertyType.office: 'office',
  PropertyType.house: 'house',
  PropertyType.commercial: 'commercial',
  PropertyType.land: 'land',
};

const _$ContractTypeEnumMap = {
  ContractType.jeonse: 'jeonse',
  ContractType.wolse: 'wolse',
  ContractType.banJeonse: 'banJeonse',
};
