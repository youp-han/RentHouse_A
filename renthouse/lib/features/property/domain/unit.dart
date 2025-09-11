import 'package:freezed_annotation/freezed_annotation.dart';

part 'unit.freezed.dart';
part 'unit.g.dart';

// 임대 상태 enum
enum RentStatus {
  rented,    // 임대 중
  vacant     // 공실
}

// RentStatus extension for display names
extension RentStatusExtension on RentStatus {
  String get displayName {
    switch (this) {
      case RentStatus.rented:
        return '임대 중';
      case RentStatus.vacant:
        return '공실';
    }
  }
  
  String get value {
    switch (this) {
      case RentStatus.rented:
        return 'RENTED';
      case RentStatus.vacant:
        return 'VACANT';
    }
  }

  static RentStatus fromString(String value) {
    switch (value.toUpperCase()) {
      case 'RENTED':
        return RentStatus.rented;
      case 'VACANT':
        return RentStatus.vacant;
      default:
        return RentStatus.vacant; // 기본값
    }
  }
}

@freezed
class Unit with _$Unit {
  const factory Unit({
    required String id,
    required String propertyId,
    required String unitNumber,
    required RentStatus rentStatus,
    required double sizeMeter,
    required double sizeKorea,
    required String useType,
    String? description,
  }) = _Unit;

  factory Unit.fromJson(Map<String, dynamic> json) => _$UnitFromJson(json);
}
