import 'package:flutter_test/flutter_test.dart';
import 'package:renthouse/features/property/domain/unit.dart';

void main() {
  group('Unit 도메인 모델 테스트', () {
    late Unit testUnit;

    setUp(() {
      testUnit = const Unit(
        id: 'unit1',
        propertyId: 'property1',
        unitNumber: '101',
        rentStatus: '임대중',
        sizeMeter: 84.0,
        sizeKorea: 25.0,
        useType: '주거용',
        description: '남향, 베란다 있음',
      );
    });

    test('Unit 객체 생성이 정상적으로 동작해야 한다', () {
      expect(testUnit.id, 'unit1');
      expect(testUnit.propertyId, 'property1');
      expect(testUnit.unitNumber, '101');
      expect(testUnit.rentStatus, '임대중');
      expect(testUnit.sizeMeter, 84.0);
      expect(testUnit.sizeKorea, 25.0);
      expect(testUnit.useType, '주거용');
      expect(testUnit.description, '남향, 베란다 있음');
    });

    test('Unit description은 nullable이어야 한다', () {
      const unitWithoutDescription = Unit(
        id: 'unit2',
        propertyId: 'property1',
        unitNumber: '102',
        rentStatus: '공실',
        sizeMeter: 74.0,
        sizeKorea: 22.0,
        useType: '주거용',
      );

      expect(unitWithoutDescription.description, isNull);
    });

    test('Unit JSON 직렬화/역직렬화가 올바르게 동작해야 한다', () {
      final json = testUnit.toJson();
      final fromJson = Unit.fromJson(json);

      expect(fromJson, testUnit);
      expect(fromJson.id, testUnit.id);
      expect(fromJson.propertyId, testUnit.propertyId);
      expect(fromJson.unitNumber, testUnit.unitNumber);
      expect(fromJson.sizeMeter, testUnit.sizeMeter);
    });

    test('Unit copyWith가 올바르게 동작해야 한다', () {
      final updatedUnit = testUnit.copyWith(
        rentStatus: '공실',
        description: '수리 완료, 새로 도배',
      );

      expect(updatedUnit.rentStatus, '공실');
      expect(updatedUnit.description, '수리 완료, 새로 도배');
      expect(updatedUnit.id, testUnit.id);
      expect(updatedUnit.unitNumber, testUnit.unitNumber);
      expect(updatedUnit.sizeMeter, testUnit.sizeMeter);
    });

    test('다양한 임대상태를 가질 수 있어야 한다', () {
      const rentedUnit = Unit(
        id: 'unit1',
        propertyId: 'property1',
        unitNumber: '101',
        rentStatus: '임대중',
        sizeMeter: 84.0,
        sizeKorea: 25.0,
        useType: '주거용',
      );

      const vacantUnit = Unit(
        id: 'unit2',
        propertyId: 'property1',
        unitNumber: '102',
        rentStatus: '공실',
        sizeMeter: 84.0,
        sizeKorea: 25.0,
        useType: '주거용',
      );

      expect(rentedUnit.rentStatus, '임대중');
      expect(vacantUnit.rentStatus, '공실');
    });

    test('다양한 용도타입을 가질 수 있어야 한다', () {
      const residentialUnit = Unit(
        id: 'unit1',
        propertyId: 'property1',
        unitNumber: '101',
        rentStatus: '임대중',
        sizeMeter: 84.0,
        sizeKorea: 25.0,
        useType: '주거용',
      );

      const commercialUnit = Unit(
        id: 'unit2',
        propertyId: 'property1',
        unitNumber: '상가1호',
        rentStatus: '임대중',
        sizeMeter: 50.0,
        sizeKorea: 15.0,
        useType: '상업용',
      );

      expect(residentialUnit.useType, '주거용');
      expect(commercialUnit.useType, '상업용');
    });

    test('Unit equality가 올바르게 동작해야 한다', () {
      const unit1 = Unit(
        id: 'same_id',
        propertyId: 'property1',
        unitNumber: '101',
        rentStatus: '임대중',
        sizeMeter: 84.0,
        sizeKorea: 25.0,
        useType: '주거용',
      );

      const unit2 = Unit(
        id: 'same_id',
        propertyId: 'property1',
        unitNumber: '101',
        rentStatus: '임대중',
        sizeMeter: 84.0,
        sizeKorea: 25.0,
        useType: '주거용',
      );

      expect(unit1, unit2);
      expect(unit1.hashCode, unit2.hashCode);
    });

    test('면적 계산이 올바른지 확인해야 한다', () {
      const unit = Unit(
        id: 'unit1',
        propertyId: 'property1',
        unitNumber: '101',
        rentStatus: '임대중',
        sizeMeter: 84.0,
        sizeKorea: 25.4,
        useType: '주거용',
      );

      // 1평 = 약 3.3058㎡
      final expectedKoreaSize = unit.sizeMeter / 3.3058;
      expect(unit.sizeKorea, closeTo(expectedKoreaSize, 1.0));
    });
  });
}