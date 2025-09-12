import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:renthouse/features/property/domain/unit.dart';

part 'property.freezed.dart';
part 'property.g.dart';

enum PropertyType {
  villa('다가구 (빌라)'),
  apartment('아파트'),
  office('오피스'),
  house('주택'),
  commercial('상가'),
  land('토지');

  const PropertyType(this.displayName);
  final String displayName;
}

enum ContractType {
  jeonse('전세'),
  wolse('월세'),
  banJeonse('반전세');

  const ContractType(this.displayName);
  final String displayName;
}

@freezed
class BillingItem with _$BillingItem {
  const factory BillingItem({
    required String name,
    required int amount,
    @Default(true) bool isEnabled,
  }) = _BillingItem;

  factory BillingItem.fromJson(Map<String, dynamic> json) => _$BillingItemFromJson(json);
}

@freezed
class Property with _$Property {
  const factory Property({
    required String id,
    required String name,
    // 주소 구조 변경 (task136)
    String? zipCode,        // 우편번호
    String? address1,       // 주소1
    String? address2,       // 상세주소
    @Deprecated('Use fullAddress getter instead') String? address, // 기존 호환성을 위해 유지
    // 자산 유형을 enum으로 변경 (task132)
    @Default(PropertyType.villa) PropertyType propertyType,
    // 계약 종류 추가 (task135)
    @Default(ContractType.wolse) ContractType contractType,
    // 층수 필드 제거됨 (task133)
    required int totalUnits,
    @Default(0) int rent,
    // 소유자 정보 추가 (task134) - 고객관리 기능과 연동 예정
    String? ownerId,
    String? ownerName,
    String? ownerPhone,
    String? ownerEmail,
    // 청구 목록 선택 기능 (추가 요구사항)
    @Default([]) List<BillingItem> defaultBillingItems,
    @Default([]) List<Unit> units,
  }) = _Property;

  factory Property.fromJson(Map<String, dynamic> json) => _$PropertyFromJson(json);
  
  const Property._();
  
  // 편의 메서드들
  String get fullAddress {
    if (address1 != null && address2 != null) {
      return '$address1 $address2';
    } else if (address1 != null) {
      return address1!;
    } else {
      return address ?? '';
    }
  }
  
  // 기본 청구 항목 중 활성화된 것만 반환
  List<BillingItem> get activeBillingItems {
    return defaultBillingItems.where((item) => item.isEnabled).toList();
  }
}
