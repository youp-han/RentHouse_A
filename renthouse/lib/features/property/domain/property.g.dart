// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PropertyImpl _$$PropertyImplFromJson(Map<String, dynamic> json) =>
    _$PropertyImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      type: json['type'] as String,
      totalFloors: (json['totalFloors'] as num).toInt(),
      totalUnits: (json['totalUnits'] as num).toInt(),
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
      'address': instance.address,
      'type': instance.type,
      'totalFloors': instance.totalFloors,
      'totalUnits': instance.totalUnits,
      'units': instance.units,
    };
