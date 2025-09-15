import 'package:flutter_test/flutter_test.dart';
import 'package:renthouse/features/property/domain/unit.dart';

void main() {
  group('Unit Domain Model Tests', () {
    test('Unit model should create with valid data', () {
      // Arrange
      const unit = Unit(
        id: 'unit_001',
        propertyId: 'prop_001',
        unitNumber: '101',
        rentStatus: RentStatus.rented,
        sizeMeter: 84.5,
        sizeKorea: 25.5,
        useType: '주거용',
        description: '남향, 발코니 확장',
      );

      // Assert
      expect(unit.id, 'unit_001');
      expect(unit.propertyId, 'prop_001');
      expect(unit.unitNumber, '101');
      expect(unit.rentStatus, RentStatus.rented);
      expect(unit.sizeMeter, 84.5);
      expect(unit.sizeKorea, 25.5);
      expect(unit.useType, '주거용');
      expect(unit.description, '남향, 발코니 확장');
    });

    test('RentStatus enum should have correct values and display names', () {
      expect(RentStatus.rented.value, 'RENTED');
      expect(RentStatus.rented.displayName, '임대 중');
      
      expect(RentStatus.vacant.value, 'VACANT');
      expect(RentStatus.vacant.displayName, '공실');
    });

    test('RentStatusExtension fromString should work correctly', () {
      expect(RentStatusExtension.fromString('RENTED'), RentStatus.rented);
      expect(RentStatusExtension.fromString('VACANT'), RentStatus.vacant);
      expect(RentStatusExtension.fromString('invalid'), RentStatus.vacant); // default
    });

    test('Unit copyWith should update specified fields', () {
      // Arrange
      const originalUnit = Unit(
        id: 'unit_001',
        propertyId: 'prop_001',
        unitNumber: '101',
        rentStatus: RentStatus.vacant,
        sizeMeter: 84.5,
        sizeKorea: 25.5,
        useType: '주거용',
        description: '남향, 발코니 확장',
      );

      // Act
      final updatedUnit = originalUnit.copyWith(
        rentStatus: RentStatus.rented,
        description: '남향, 발코니 확장, 리모델링 완료',
      );

      // Assert
      expect(updatedUnit.rentStatus, RentStatus.rented);
      expect(updatedUnit.description, '남향, 발코니 확장, 리모델링 완료');
      expect(updatedUnit.id, originalUnit.id); // 변경되지 않은 필드는 유지
      expect(updatedUnit.unitNumber, originalUnit.unitNumber);
    });

    test('Unit with null description should handle properly', () {
      // Arrange
      const unit = Unit(
        id: 'unit_001',
        propertyId: 'prop_001',
        unitNumber: '101',
        rentStatus: RentStatus.rented,
        sizeMeter: 84.5,
        sizeKorea: 25.5,
        useType: '주거용',
        description: null,
      );

      // Assert
      expect(unit.description, null);
    });
  });
}