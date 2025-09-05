import 'package:freezed_annotation/freezed_annotation.dart';

part 'unit.freezed.dart';
part 'unit.g.dart';

@freezed
class Unit with _$Unit {
  const factory Unit({
    required String id,
    required String propertyId,
    required String unitNumber,
    required String rentStatus,
    required double sizeMeter,
    required double sizeKorea,
    required String useType,
    String? description,
  }) = _Unit;

  factory Unit.fromJson(Map<String, dynamic> json) => _$UnitFromJson(json);
}
