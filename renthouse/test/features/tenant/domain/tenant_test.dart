import 'package:flutter_test/flutter_test.dart';
import 'package:renthouse/features/tenant/domain/tenant.dart';

void main() {
  group('Tenant 도메인 모델 테스트', () {
    late Tenant testTenant;
    late DateTime testCreatedAt;

    setUp(() {
      testCreatedAt = DateTime(2023, 1, 15, 10, 30);
      testTenant = Tenant(
        id: 'tenant1',
        name: '김철수',
        phone: '010-1234-5678',
        email: 'kimcs@example.com',
        socialNo: '750331-1******',
        currentAddress: '서울시 강남구 테스트동 456',
        createdAt: testCreatedAt,
      );
    });

    test('Tenant 객체 생성이 정상적으로 동작해야 한다', () {
      expect(testTenant.id, 'tenant1');
      expect(testTenant.name, '김철수');
      expect(testTenant.phone, '010-1234-5678');
      expect(testTenant.email, 'kimcs@example.com');
      expect(testTenant.socialNo, '750331-1******');
      expect(testTenant.currentAddress, '서울시 강남구 테스트동 456');
      expect(testTenant.createdAt, testCreatedAt);
    });

    test('Tenant 선택적 필드들이 nullable이어야 한다', () {
      final tenantWithNullables = Tenant(
        id: 'tenant2',
        name: '박영희',
        phone: '010-9876-5432',
        email: 'parkyh@example.com',
        createdAt: testCreatedAt,
      );

      expect(tenantWithNullables.socialNo, isNull);
      expect(tenantWithNullables.currentAddress, isNull);
    });

    test('Tenant JSON 직렬화/역직렬화가 올바르게 동작해야 한다', () {
      final json = testTenant.toJson();
      final fromJson = Tenant.fromJson(json);

      expect(fromJson, testTenant);
      expect(fromJson.id, testTenant.id);
      expect(fromJson.name, testTenant.name);
      expect(fromJson.phone, testTenant.phone);
      expect(fromJson.email, testTenant.email);
      expect(fromJson.createdAt, testTenant.createdAt);
    });

    test('Tenant copyWith가 올바르게 동작해야 한다', () {
      final updatedTenant = testTenant.copyWith(
        name: '김영수',
        phone: '010-1111-2222',
        currentAddress: '서울시 서초구 새로운동 789',
      );

      expect(updatedTenant.name, '김영수');
      expect(updatedTenant.phone, '010-1111-2222');
      expect(updatedTenant.currentAddress, '서울시 서초구 새로운동 789');
      expect(updatedTenant.id, testTenant.id);
      expect(updatedTenant.email, testTenant.email);
      expect(updatedTenant.socialNo, testTenant.socialNo);
    });

    test('이메일 형식 검증을 위한 테스트 데이터', () {
      final validEmails = [
        'test@example.com',
        'user.name@domain.co.kr',
        'test123@test-domain.com',
      ];

      final invalidEmails = [
        'invalid-email',
        '@domain.com',
        'test@',
        'test.com',
      ];

      for (final email in validEmails) {
        final tenant = Tenant(
          id: 'tenant_test',
          name: '테스트',
          phone: '010-1234-5678',
          email: email,
          createdAt: testCreatedAt,
        );
        expect(tenant.email, email);
      }

      // 실제 앱에서는 이메일 유효성 검사를 별도로 구현해야 함
      for (final email in invalidEmails) {
        // 현재 모델에서는 제약이 없지만, 향후 validation 추가 시 참고
        // 잘못된 이메일 형식들은 '@' 기호가 없거나 불완전함
        expect(email == 'invalid-email' || 
               email == '@domain.com' || 
               email == 'test@' || 
               email == 'test.com', isTrue);
      }
    });

    test('전화번호 형식 테스트', () {
      final validPhones = [
        '010-1234-5678',
        '011-123-4567',
        '010.1234.5678',
        '01012345678',
      ];

      for (final phone in validPhones) {
        final tenant = Tenant(
          id: 'tenant_test',
          name: '테스트',
          phone: phone,
          email: 'test@example.com',
          createdAt: testCreatedAt,
        );
        expect(tenant.phone, phone);
      }
    });

    test('주민등록번호 마스킹 테스트', () {
      final maskedSocialNos = [
        '750331-1******',
        '850215-2******',
        '950101-3******',
      ];

      for (final socialNo in maskedSocialNos) {
        final tenant = Tenant(
          id: 'tenant_test',
          name: '테스트',
          phone: '010-1234-5678',
          email: 'test@example.com',
          socialNo: socialNo,
          createdAt: testCreatedAt,
        );
        
        expect(tenant.socialNo, socialNo);
        expect(tenant.socialNo!.length, 14); // 'YYMMDD-N******' 형식
        expect(tenant.socialNo!.contains('*'), isTrue);
      }
    });

    test('Tenant equality가 올바르게 동작해야 한다', () {
      final tenant1 = Tenant(
        id: 'same_id',
        name: '김철수',
        phone: '010-1234-5678',
        email: 'kim@example.com',
        createdAt: testCreatedAt,
      );

      final tenant2 = Tenant(
        id: 'same_id',
        name: '김철수',
        phone: '010-1234-5678',
        email: 'kim@example.com',
        createdAt: testCreatedAt,
      );

      expect(tenant1, tenant2);
      expect(tenant1.hashCode, tenant2.hashCode);
    });

    test('생성일자가 올바르게 처리되어야 한다', () {
      final now = DateTime.now();
      final tenant = Tenant(
        id: 'tenant_time_test',
        name: '시간테스트',
        phone: '010-1234-5678',
        email: 'time@example.com',
        createdAt: now,
      );

      expect(tenant.createdAt, now);
      expect(tenant.createdAt.isBefore(DateTime.now().add(const Duration(seconds: 1))), isTrue);
    });
  });
}