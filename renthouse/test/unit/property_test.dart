import 'package:flutter_test/flutter_test.dart';
import 'package:renthouse/features/property/domain/property.dart';

void main() {
  group('Property Domain Model Tests', () {
    test('Property model should create with valid data', () {
      // Arrange
      const property = Property(
        id: 'prop_001',
        name: '테스트 빌딩',
        zipCode: '12345',
        address1: '서울시 강남구 테스트로 123',
        address2: '101호',
        address: '서울시 강남구 테스트로 123 101호',
        propertyType: PropertyType.apartment,
        contractType: ContractType.wolse,
        rent: 1000000,
        totalUnits: 10,
        ownerName: '김테스트',
        ownerPhone: '010-1234-5678',
        ownerEmail: 'test@example.com',
        defaultBillingItems: [],
        units: [],
      );

      // Assert
      expect(property.id, 'prop_001');
      expect(property.name, '테스트 빌딩');
      expect(property.propertyType, PropertyType.apartment);
      expect(property.contractType, ContractType.wolse);
      expect(property.totalUnits, 10);
    });

    test('Property fullAddress should combine address1 and address2', () {
      // Arrange
      const property = Property(
        id: 'prop_001',
        name: '테스트 빌딩',
        zipCode: '12345',
        address1: '서울시 강남구 테스트로 123',
        address2: '101호',
        address: '서울시 강남구 테스트로 123 101호',
        propertyType: PropertyType.apartment,
        contractType: ContractType.wolse,
        rent: 1000000,
        totalUnits: 10,
        ownerName: '김테스트',
        ownerPhone: '010-1234-5678',
        ownerEmail: 'test@example.com',
        defaultBillingItems: [],
        units: [],
      );

      // Act
      final fullAddress = property.fullAddress;

      // Assert
      expect(fullAddress, '서울시 강남구 테스트로 123 101호');
    });

    test('PropertyType enum should have correct display names', () {
      expect(PropertyType.villa.displayName, '다가구 (빌라)');
      expect(PropertyType.apartment.displayName, '아파트');
      expect(PropertyType.office.displayName, '오피스');
      expect(PropertyType.house.displayName, '주택');
      expect(PropertyType.commercial.displayName, '상가');
      expect(PropertyType.land.displayName, '토지');
    });

    test('ContractType enum should have correct display names', () {
      expect(ContractType.jeonse.displayName, '전세');
      expect(ContractType.wolse.displayName, '월세');
      expect(ContractType.banJeonse.displayName, '반전세');
    });

    test('BillingItem should create with valid data', () {
      // Arrange
      const billingItem = BillingItem(
        name: '관리비',
        amount: 50000,
        isEnabled: true,
      );

      // Assert
      expect(billingItem.name, '관리비');
      expect(billingItem.amount, 50000);
      expect(billingItem.isEnabled, true);
    });

    test('Property copyWith should update specified fields', () {
      // Arrange
      const originalProperty = Property(
        id: 'prop_001',
        name: '원본 빌딩',
        zipCode: '12345',
        address1: '서울시 강남구 테스트로 123',
        address2: '101호',
        address: '서울시 강남구 테스트로 123 101호',
        propertyType: PropertyType.apartment,
        contractType: ContractType.wolse,
        rent: 1000000,
        totalUnits: 10,
        ownerName: '김테스트',
        ownerPhone: '010-1234-5678',
        ownerEmail: 'test@example.com',
        defaultBillingItems: [],
        units: [],
      );

      // Act
      final updatedProperty = originalProperty.copyWith(
        name: '수정된 빌딩',
        totalUnits: 15,
      );

      // Assert
      expect(updatedProperty.name, '수정된 빌딩');
      expect(updatedProperty.totalUnits, 15);
      expect(updatedProperty.id, originalProperty.id); // 변경되지 않은 필드는 유지
      expect(updatedProperty.propertyType, originalProperty.propertyType);
    });
  });
}