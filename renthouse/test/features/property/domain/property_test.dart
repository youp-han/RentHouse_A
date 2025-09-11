import 'package:flutter_test/flutter_test.dart';
import 'package:renthouse/features/property/domain/property.dart';
import 'package:renthouse/features/property/domain/unit.dart';

void main() {
  group('Property 도메인 모델 테스트', () {
    late Property testProperty;

    setUp(() {
      testProperty = const Property(
        id: 'property1',
        name: '테스트 아파트',
        address: '서울시 강남구 테스트동 123',
        type: '아파트',
        totalFloors: 10,
        totalUnits: 50,
        rent: 1000000,
        units: [],
      );
    });

    test('Property 객체 생성이 정상적으로 동작해야 한다', () {
      expect(testProperty.id, 'property1');
      expect(testProperty.name, '테스트 아파트');
      expect(testProperty.address, '서울시 강남구 테스트동 123');
      expect(testProperty.type, '아파트');
      expect(testProperty.totalFloors, 10);
      expect(testProperty.totalUnits, 50);
      expect(testProperty.rent, 1000000);
      expect(testProperty.units, isEmpty);
    });

    test('Property 기본값이 올바르게 설정되어야 한다', () {
      const propertyWithDefaults = Property(
        id: 'property2',
        name: '기본값 테스트',
        address: '주소',
        type: '빌라',
        totalFloors: 3,
        totalUnits: 12,
      );

      expect(propertyWithDefaults.rent, 0);
      expect(propertyWithDefaults.units, isEmpty);
    });

    test('Property JSON 직렬화/역직렬화가 올바르게 동작해야 한다', () {
      final json = testProperty.toJson();
      final fromJson = Property.fromJson(json);

      expect(fromJson, testProperty);
      expect(fromJson.id, testProperty.id);
      expect(fromJson.name, testProperty.name);
      expect(fromJson.address, testProperty.address);
    });

    test('Property copyWith가 올바르게 동작해야 한다', () {
      final updatedProperty = testProperty.copyWith(
        name: '수정된 아파트',
        rent: 1200000,
      );

      expect(updatedProperty.name, '수정된 아파트');
      expect(updatedProperty.rent, 1200000);
      expect(updatedProperty.id, testProperty.id);
      expect(updatedProperty.address, testProperty.address);
    });

    test('Property units 리스트가 올바르게 처리되어야 한다', () {
      const unit1 = Unit(
        id: 'unit1',
        propertyId: 'property1',
        unitNumber: '101',
        rentStatus: '임대중',
        sizeMeter: 84.0,
        sizeKorea: 25.0,
        useType: '주거용',
      );

      const unit2 = Unit(
        id: 'unit2',
        propertyId: 'property1',
        unitNumber: '102',
        rentStatus: '공실',
        sizeMeter: 84.0,
        sizeKorea: 25.0,
        useType: '주거용',
      );

      final propertyWithUnits = testProperty.copyWith(
        units: [unit1, unit2],
      );

      expect(propertyWithUnits.units.length, 2);
      expect(propertyWithUnits.units[0].unitNumber, '101');
      expect(propertyWithUnits.units[1].unitNumber, '102');
    });

    test('Property equality가 올바르게 동작해야 한다', () {
      const property1 = Property(
        id: 'same_id',
        name: '같은 이름',
        address: '같은 주소',
        type: '아파트',
        totalFloors: 5,
        totalUnits: 20,
      );

      const property2 = Property(
        id: 'same_id',
        name: '같은 이름',
        address: '같은 주소',
        type: '아파트',
        totalFloors: 5,
        totalUnits: 20,
      );

      expect(property1, property2);
      expect(property1.hashCode, property2.hashCode);
    });
  });
}