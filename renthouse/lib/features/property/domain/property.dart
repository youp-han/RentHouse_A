import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:renthouse/features/property/domain/unit.dart';

part 'property.freezed.dart';
part 'property.g.dart';

@freezed
class Property with _$Property {
  const factory Property({
    required String id,
    required String name,
    required String address,
    required String type,
    required int totalFloors,
    required int totalUnits,
    @Default(0) int rent,
    @Default([]) List<Unit> units,
  }) = _Property;

  factory Property.fromJson(Map<String, dynamic> json) => _$PropertyFromJson(json);
}
