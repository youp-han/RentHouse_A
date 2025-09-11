import 'package:flutter_test/flutter_test.dart';
import 'package:renthouse/core/database/app_database.dart';
import 'package:renthouse/features/tenant/data/tenant_repository.dart';
import 'package:renthouse/features/tenant/domain/tenant.dart';
import 'package:drift/native.dart';

void main() {
  group('TenantRepository 테스트', () {
    late AppDatabase database;
    late TenantRepository repository;

    setUp(() async {
      // 테스트용 인메모리 데이터베이스 생성
      database = AppDatabase(NativeDatabase.memory());
      repository = TenantRepository(database);
    });

    tearDown(() async {
      await database.close();
    });

    group('Tenant CRUD 테스트', () {
      test('새로운 Tenant를 생성할 수 있어야 한다', () async {
        final createdAt = DateTime(2023, 1, 15, 10, 30);
        final tenant = Tenant(
          id: 'test_tenant_1',
          name: '김철수',
          phone: '010-1234-5678',
          email: 'kimcs@example.com',
          socialNo: '750331-1******',
          currentAddress: '서울시 강남구 테스트동 456',
          createdAt: createdAt,
        );

        final result = await repository.createTenant(tenant);

        expect(result.id, tenant.id);
        expect(result.name, tenant.name);
        expect(result.phone, tenant.phone);
        expect(result.email, tenant.email);
        expect(result.socialNo, tenant.socialNo);
        expect(result.currentAddress, tenant.currentAddress);
      });

      test('모든 Tenant 목록을 조회할 수 있어야 한다', () async {
        // Given: 여러 Tenant 생성
        final createdAt = DateTime(2023, 1, 15);
        
        final tenant1 = Tenant(
          id: 'tenant_1',
          name: '김철수',
          phone: '010-1111-1111',
          email: 'kim@example.com',
          createdAt: createdAt,
        );

        final tenant2 = Tenant(
          id: 'tenant_2',
          name: '박영희',
          phone: '010-2222-2222',
          email: 'park@example.com',
          socialNo: '850215-2******',
          createdAt: createdAt,
        );

        await repository.createTenant(tenant1);
        await repository.createTenant(tenant2);

        // When: 모든 Tenant 조회
        final tenants = await repository.getTenants();

        // Then: 2개의 Tenant가 조회되어야 함
        expect(tenants.length, 2);
        expect(tenants.any((t) => t.id == 'tenant_1'), isTrue);
        expect(tenants.any((t) => t.id == 'tenant_2'), isTrue);
      });

      test('ID로 특정 Tenant를 조회할 수 있어야 한다', () async {
        // Given: Tenant 생성
        final tenant = Tenant(
          id: 'specific_tenant',
          name: '이영수',
          phone: '010-3333-3333',
          email: 'lee@example.com',
          currentAddress: '부산시 해운대구 특정동 789',
          createdAt: DateTime(2023, 2, 1),
        );

        await repository.createTenant(tenant);

        // When: 모든 Tenant 조회 후 ID로 찾기
        final tenants = await repository.getTenants();
        final foundTenant = tenants.where((t) => t.id == 'specific_tenant').firstOrNull;

        // Then: 해당 Tenant가 조회되어야 함
        expect(foundTenant, isNotNull);
        expect(foundTenant!.id, 'specific_tenant');
        expect(foundTenant.name, '이영수');
        expect(foundTenant.currentAddress, '부산시 해운대구 특정동 789');
      });

      test('존재하지 않는 ID로 조회하면 찾을 수 없어야 한다', () async {
        final tenants = await repository.getTenants();
        final foundTenant = tenants.where((t) => t.id == 'non_existent_tenant').firstOrNull;
        expect(foundTenant, isNull);
      });

      test('Tenant를 수정할 수 있어야 한다', () async {
        // Given: Tenant 생성
        final originalTenant = Tenant(
          id: 'update_test_tenant',
          name: '원본 이름',
          phone: '010-1111-1111',
          email: 'original@example.com',
          createdAt: DateTime(2023, 3, 1),
        );

        await repository.createTenant(originalTenant);

        // When: Tenant 수정
        final updatedTenant = originalTenant.copyWith(
          name: '수정된 이름',
          phone: '010-9999-9999',
          currentAddress: '새로운 주소',
          socialNo: '901010-1******',
        );

        await repository.updateTenant(updatedTenant);

        // Then: 수정된 내용이 반영되어야 함
        final tenants = await repository.getTenants();
        final result = tenants.where((t) => t.id == 'update_test_tenant').first;
        expect(result.name, '수정된 이름');
        expect(result.phone, '010-9999-9999');
        expect(result.currentAddress, '새로운 주소');
        expect(result.socialNo, '901010-1******');
        expect(result.email, originalTenant.email); // 변경되지 않은 필드
      });

      test('Tenant를 삭제할 수 있어야 한다', () async {
        // Given: Tenant 생성
        final tenant = Tenant(
          id: 'delete_test_tenant',
          name: '삭제될 임차인',
          phone: '010-4444-4444',
          email: 'delete@example.com',
          createdAt: DateTime(2023, 4, 1),
        );

        await repository.createTenant(tenant);

        // 생성 확인
        var tenants = await repository.getTenants();
        var foundTenant = tenants.where((t) => t.id == 'delete_test_tenant').firstOrNull;
        expect(foundTenant, isNotNull);

        // When: Tenant 삭제
        await repository.deleteTenant('delete_test_tenant');

        // Then: 더 이상 조회되지 않아야 함
        tenants = await repository.getTenants();
        foundTenant = tenants.where((t) => t.id == 'delete_test_tenant').firstOrNull;
        expect(foundTenant, isNull);
      });
    });

    group('Tenant 데이터 검증 테스트', () {
      test('필수 필드만으로 Tenant를 생성할 수 있어야 한다', () async {
        final tenant = Tenant(
          id: 'minimal_tenant',
          name: '최소 정보',
          phone: '010-5555-5555',
          email: 'minimal@example.com',
          createdAt: DateTime(2023, 5, 1),
        );

        final result = await repository.createTenant(tenant);

        expect(result.socialNo, isNull);
        expect(result.currentAddress, isNull);
        expect(result.name, '최소 정보');
        expect(result.phone, '010-5555-5555');
        expect(result.email, 'minimal@example.com');
      });

      test('모든 필드를 포함한 Tenant를 생성할 수 있어야 한다', () async {
        final tenant = Tenant(
          id: 'full_tenant',
          name: '전체 정보',
          phone: '010-6666-6666',
          email: 'full@example.com',
          socialNo: '920505-2******',
          currentAddress: '대전시 유성구 전체정보동 123-45',
          createdAt: DateTime(2023, 6, 1),
        );

        final result = await repository.createTenant(tenant);

        expect(result.socialNo, '920505-2******');
        expect(result.currentAddress, '대전시 유성구 전체정보동 123-45');
        expect(result.name, '전체 정보');
      });

      test('주민등록번호 마스킹이 올바르게 저장되어야 한다', () async {
        final tenant = Tenant(
          id: 'masked_social_tenant',
          name: '마스킹 테스트',
          phone: '010-7777-7777',
          email: 'masked@example.com',
          socialNo: '881225-1******',
          createdAt: DateTime(2023, 7, 1),
        );

        await repository.createTenant(tenant);
        final tenants = await repository.getTenants();
        final result = tenants.where((t) => t.id == 'masked_social_tenant').first;

        expect(result.socialNo, '881225-1******');
        expect(result.socialNo!.contains('*'), isTrue);
        expect(result.socialNo!.length, 14);
      });

      test('이메일 주소가 올바르게 저장되어야 한다', () async {
        final validEmails = [
          'test@example.com',
          'user.name@domain.co.kr',
          'test123@test-domain.org',
        ];

        for (int i = 0; i < validEmails.length; i++) {
          final tenant = Tenant(
            id: 'email_test_$i',
            name: '이메일 테스트 $i',
            phone: '010-8888-888$i',
            email: validEmails[i],
            createdAt: DateTime(2023, 8, i + 1),
          );

          await repository.createTenant(tenant);
          final tenants = await repository.getTenants();
          final result = tenants.where((t) => t.id == 'email_test_$i').first;

          expect(result.email, validEmails[i]);
        }
      });

      test('전화번호 형식이 올바르게 저장되어야 한다', () async {
        final phoneFormats = [
          '010-1234-5678',
          '011-123-4567',
          '010.1234.5678',
          '01012345678',
        ];

        for (int i = 0; i < phoneFormats.length; i++) {
          final tenant = Tenant(
            id: 'phone_test_$i',
            name: '전화번호 테스트 $i',
            phone: phoneFormats[i],
            email: 'phone$i@example.com',
            createdAt: DateTime(2023, 9, i + 1),
          );

          await repository.createTenant(tenant);
          final tenants = await repository.getTenants();
          final result = tenants.where((t) => t.id == 'phone_test_$i').first;

          expect(result.phone, phoneFormats[i]);
        }
      });
    });

    group('Tenant 검색 및 필터링 테스트', () {
      test('여러 Tenant 중 특정 조건으로 필터링할 수 있어야 한다', () async {
        // Given: 여러 Tenant 생성
        final tenants = [
          Tenant(
            id: 'filter_1',
            name: '김철수',
            phone: '010-1111-1111',
            email: 'kim@example.com',
            currentAddress: '서울시 강남구',
            createdAt: DateTime(2023, 1, 1),
          ),
          Tenant(
            id: 'filter_2',
            name: '박영희',
            phone: '010-2222-2222',
            email: 'park@example.com',
            currentAddress: '서울시 서초구',
            createdAt: DateTime(2023, 1, 2),
          ),
          Tenant(
            id: 'filter_3',
            name: '이영수',
            phone: '010-3333-3333',
            email: 'lee@example.com',
            currentAddress: '부산시 해운대구',
            createdAt: DateTime(2023, 1, 3),
          ),
        ];

        for (final tenant in tenants) {
          await repository.createTenant(tenant);
        }

        // When: 모든 Tenant 조회 후 메모리에서 필터링
        final allTenants = await repository.getTenants();
        final seoulTenants = allTenants
            .where((t) => t.currentAddress?.contains('서울') == true)
            .toList();

        // Then: 서울 거주자만 필터링되어야 함
        expect(seoulTenants.length, 2);
        expect(seoulTenants.any((t) => t.name == '김철수'), isTrue);
        expect(seoulTenants.any((t) => t.name == '박영희'), isTrue);
        expect(seoulTenants.any((t) => t.name == '이영수'), isFalse);
      });

      test('생성일자 순으로 정렬할 수 있어야 한다', () async {
        // Given: 날짜가 다른 Tenant들 생성
        final tenant1 = Tenant(
          id: 'sort_1',
          name: '첫번째',
          phone: '010-1111-1111',
          email: 'first@example.com',
          createdAt: DateTime(2023, 3, 1),
        );

        final tenant2 = Tenant(
          id: 'sort_2',
          name: '두번째',
          phone: '010-2222-2222',
          email: 'second@example.com',
          createdAt: DateTime(2023, 1, 1),
        );

        final tenant3 = Tenant(
          id: 'sort_3',
          name: '세번째',
          phone: '010-3333-3333',
          email: 'third@example.com',
          createdAt: DateTime(2023, 2, 1),
        );

        await repository.createTenant(tenant1);
        await repository.createTenant(tenant2);
        await repository.createTenant(tenant3);

        // When: 모든 Tenant 조회 후 생성일자 순 정렬
        final allTenants = await repository.getTenants();
        allTenants.sort((a, b) => a.createdAt.compareTo(b.createdAt));

        // Then: 생성일자 순으로 정렬되어야 함
        expect(allTenants[0].name, '두번째'); // 2023-01-01
        expect(allTenants[1].name, '세번째'); // 2023-02-01
        expect(allTenants[2].name, '첫번째'); // 2023-03-01
      });
    });
  });
}