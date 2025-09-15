import 'package:flutter_test/flutter_test.dart';
import 'package:renthouse/features/tenant/domain/tenant.dart';

void main() {
  group('Tenant Domain Model Tests', () {
    test('Tenant model should create with valid data', () {
      // Arrange
      final tenant = Tenant(
        id: 'tenant_001',
        name: '김테스트',
        phone: '010-1234-5678',
        email: 'test@example.com',
        socialNo: '900101-1234567',
        bday: '900101',
        personalNo: 1,
        currentAddress: '서울시 강남구 테스트로 123',
        createdAt: DateTime(2024, 1, 1),
      );

      // Assert
      expect(tenant.id, 'tenant_001');
      expect(tenant.name, '김테스트');
      expect(tenant.phone, '010-1234-5678');
      expect(tenant.email, 'test@example.com');
      expect(tenant.socialNo, '900101-1234567');
      expect(tenant.bday, '900101');
      expect(tenant.personalNo, 1);
      expect(tenant.currentAddress, '서울시 강남구 테스트로 123');
      expect(tenant.createdAt, DateTime(2024, 1, 1));
    });

    test('parseSocialNo should correctly parse social security number', () {
      // Test case 1: Valid social number with hyphen
      final result1 = Tenant.parseSocialNo('900101-1234567');
      expect(result1['bday'], '900101');
      expect(result1['personalNo'], 1);
      expect(result1['socialNo'], '900101-1234567');

      // Test case 2: Valid social number without hyphen
      final result2 = Tenant.parseSocialNo('9001011234567');
      expect(result2['bday'], '900101');
      expect(result2['personalNo'], 1);
      expect(result2['socialNo'], '9001011234567');

      // Test case 3: Different personal number
      final result3 = Tenant.parseSocialNo('050101-3123456');
      expect(result3['bday'], '050101');
      expect(result3['personalNo'], 3);

      // Test case 4: Invalid format (too short)
      expect(() => Tenant.parseSocialNo('9001'), throwsFormatException);

      // Test case 5: Invalid format (too long)
      expect(() => Tenant.parseSocialNo('900101-12345678'), throwsFormatException);

      // Test case 6: Empty string
      expect(() => Tenant.parseSocialNo(''), throwsFormatException);
    });

    test('maskedSocialNo should mask social security number correctly', () {
      // Arrange
      final tenant = Tenant(
        id: 'tenant_001',
        name: '김테스트',
        phone: '010-1234-5678',
        email: 'test@example.com',
        socialNo: '900101-1234567',
        bday: '900101',
        personalNo: 1,
        currentAddress: '서울시 강남구 테스트로 123',
        createdAt: DateTime(2024, 1, 1),
      );

      // Act
      final maskedNo = tenant.maskedSocialNo;

      // Assert
      expect(maskedNo, '900101-1******');
    });

    test('maskedSocialNo should handle null values correctly', () {
      // Test case 1: bday와 personalNo가 null인 경우
      final tenant1 = Tenant(
        id: 'tenant_001',
        name: '김테스트',
        phone: '010-1234-5678',
        email: 'test@example.com',
        socialNo: '900101-1234567',
        bday: null,
        personalNo: null,
        currentAddress: '서울시 강남구 테스트로 123',
        createdAt: DateTime(2024, 1, 1),
      );

      expect(tenant1.maskedSocialNo, '900101-1******');

      // Test case 2: socialNo도 null인 경우
      final tenant2 = Tenant(
        id: 'tenant_001',
        name: '김테스트',
        phone: '010-1234-5678',
        email: 'test@example.com',
        socialNo: null,
        bday: null,
        personalNo: null,
        currentAddress: '서울시 강남구 테스트로 123',
        createdAt: DateTime(2024, 1, 1),
      );

      expect(tenant2.maskedSocialNo, '정보 없음');
    });

    test('Tenant copyWith should update specified fields', () {
      // Arrange
      final originalTenant = Tenant(
        id: 'tenant_001',
        name: '김테스트',
        phone: '010-1234-5678',
        email: 'test@example.com',
        socialNo: '900101-1234567',
        bday: '900101',
        personalNo: 1,
        currentAddress: '서울시 강남구 테스트로 123',
        createdAt: DateTime(2024, 1, 1),
      );

      // Act
      final updatedTenant = originalTenant.copyWith(
        name: '이테스트',
        phone: '010-9999-9999',
      );

      // Assert
      expect(updatedTenant.name, '이테스트');
      expect(updatedTenant.phone, '010-9999-9999');
      expect(updatedTenant.id, originalTenant.id); // 변경되지 않은 필드는 유지
      expect(updatedTenant.email, originalTenant.email);
    });

    test('Tenant should handle nullable fields correctly', () {
      // Arrange
      final tenant = Tenant(
        id: 'tenant_001',
        name: '김테스트',
        phone: '010-1234-5678',
        email: 'test@example.com',
        socialNo: null,
        bday: null,
        personalNo: null,
        currentAddress: null,
        createdAt: DateTime(2024, 1, 1),
      );

      // Assert
      expect(tenant.socialNo, null);
      expect(tenant.bday, null);
      expect(tenant.personalNo, null);
      expect(tenant.currentAddress, null);
    });
  });
}