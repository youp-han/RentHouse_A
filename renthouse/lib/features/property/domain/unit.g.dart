// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UnitImpl _$$UnitImplFromJson(Map<String, dynamic> json) => _$UnitImpl(
  id: json['id'] as String,
  propertyId: json['propertyId'] as String,
  unitNumber: json['unitNumber'] as String,
  rentStatus: json['rentStatus'] as String,
  sizeMeter: (json['sizeMeter'] as num).toDouble(),
  sizeKorea: (json['sizeKorea'] as num).toDouble(),
  useType: json['useType'] as String,
  description: json['description'] as String?,
);

Map<String, dynamic> _$$UnitImplToJson(_$UnitImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'propertyId': instance.propertyId,
      'unitNumber': instance.unitNumber,
      'rentStatus': instance.rentStatus,
      'sizeMeter': instance.sizeMeter,
      'sizeKorea': instance.sizeKorea,
      'useType': instance.useType,
      'description': instance.description,
    };
