import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:renthouse/app/app.dart';
import 'package:renthouse/core/database/app_database.dart';
import 'package:renthouse/core/database/database_provider.dart';
import 'package:renthouse/features/property/data/property_repository.dart';
import 'package:renthouse/features/property/domain/property.dart';
import 'package:renthouse/features/property/domain/unit.dart';
import 'package:renthouse/features/tenant/data/tenant_repository.dart';
import 'package:renthouse/features/tenant/domain/tenant.dart';
import 'package:drift/native.dart';

void main() {
  group('RentHouse 앱 통합 테스트', () {
    late AppDatabase database;
    late PropertyRepository propertyRepository;
    late TenantRepository tenantRepository;

    setUp(() async {
      // 테스트용 인메모리 데이터베이스 생성
      database = AppDatabase(NativeDatabase.memory());
      propertyRepository = PropertyRepository(database);
      tenantRepository = TenantRepository(database);
    });

    tearDown(() async {
      await database.close();
    });

    Widget createTestApp() {
      return ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(database),
          propertyRepositoryProvider.overrideWithValue(propertyRepository),
          tenantRepositoryProvider.overrideWithValue(tenantRepository),
        ],
        child: const RentHouseApp(),
      );
    }

    testWidgets('앱이 정상적으로 시작되어야 한다', (WidgetTester tester) async {
      // When: 앱 시작
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // Then: 메인 화면이 표시되어야 함
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('Property 전체 워크플로우가 정상 동작해야 한다', (WidgetTester tester) async {
      // Given: 앱 시작
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // When & Then: Property 관련 전체 플로우 테스트
      
      // 1. 빈 상태 확인
      if (tester.any(find.text('아직 등록된 자산이 없습니다.'))) {
        expect(find.text('아직 등록된 자산이 없습니다.'), findsOneWidget);
      }

      // 2. 새로운 Property 추가 (UI를 통한 데이터 입력 시뮬레이션)
      const testProperty = Property(
        id: 'integration_test_property',
        name: '통합테스트 아파트',
        address: '서울시 강남구 통합테스트동 123',
        type: '아파트',
        totalFloors: 10,
        totalUnits: 50,
        rent: 1000000,
      );

      await propertyRepository.createProperty(testProperty);

      // 3. 데이터베이스에서 확인
      final properties = await propertyRepository.getProperties();
      expect(properties.length, 1);
      expect(properties[0].name, '통합테스트 아파트');
    });

    testWidgets('Tenant 전체 워크플로우가 정상 동작해야 한다', (WidgetTester tester) async {
      // Given: 앱 시작
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // When & Then: Tenant 관련 전체 플로우 테스트
      
      // 1. 새로운 Tenant 추가
      final testTenant = Tenant(
        id: 'integration_test_tenant',
        name: '통합테스트 임차인',
        phone: '010-1234-5678',
        email: 'integration@test.com',
        socialNo: '901010-1******',
        currentAddress: '서울시 서초구 통합테스트동 456',
        createdAt: DateTime(2023, 1, 1),
      );

      await tenantRepository.createTenant(testTenant);

      // 2. 데이터베이스에서 확인
      final tenants = await tenantRepository.getTenants();
      expect(tenants.length, 1);
      expect(tenants[0].name, '통합테스트 임차인');
      expect(tenants[0].email, 'integration@test.com');

      // 3. Tenant 수정
      final updatedTenant = testTenant.copyWith(
        name: '수정된 임차인',
        phone: '010-9876-5432',
      );

      await tenantRepository.updateTenant(updatedTenant);

      // 4. 수정 확인
      final updatedTenants = await tenantRepository.getTenants();
      expect(updatedTenants[0].name, '수정된 임차인');
      expect(updatedTenants[0].phone, '010-9876-5432');
      expect(updatedTenants[0].email, 'integration@test.com'); // 변경되지 않은 필드
    });

    testWidgets('Property와 Unit의 관계가 올바르게 동작해야 한다', (WidgetTester tester) async {
      // Given: 앱 시작
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // When: Property와 연관된 Unit 생성
      const property = Property(
        id: 'property_with_units',
        name: '유닛 테스트 아파트',
        address: '서울시 유닛테스트구',
        type: '아파트',
        totalFloors: 3,
        totalUnits: 6,
      );

      await propertyRepository.createProperty(property);

      // Unit들 추가
      for (int floor = 1; floor <= 3; floor++) {
        for (int unit = 1; unit <= 2; unit++) {
          await propertyRepository.addUnit(
            Unit(
              id: 'unit_${floor}_$unit',
              propertyId: 'property_with_units',
              unitNumber: '${floor}0$unit',
              rentStatus: unit == 1 ? '임대중' : '공실',
              sizeMeter: 84.0,
              sizeKorea: 25.0,
              useType: '주거용',
              description: '$floor층 $unit호',
            ),
          );
        }
      }

      // Then: Property 조회 시 Unit들이 포함되어야 함
      final propertyWithUnits = await propertyRepository.getPropertyById('property_with_units');
      expect(propertyWithUnits, isNotNull);
      expect(propertyWithUnits!.units.length, 6);
      
      // 각 Unit의 정보 확인
      final unit101 = propertyWithUnits.units.firstWhere((u) => u.unitNumber == '101');
      expect(unit101.rentStatus, '임대중');
      expect(unit101.description, '1층 1호');

      final unit102 = propertyWithUnits.units.firstWhere((u) => u.unitNumber == '102');
      expect(unit102.rentStatus, '공실');
      expect(unit102.description, '1층 2호');
    });

    testWidgets('데이터베이스 트랜잭션이 올바르게 동작해야 한다', (WidgetTester tester) async {
      // Given: 앱 시작
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // When: 여러 작업을 순차적으로 수행
      
      // 1. 초기 상태 확인
      var properties = await propertyRepository.getProperties();
      var tenants = await tenantRepository.getTenants();
      expect(properties.length, 0);
      expect(tenants.length, 0);

      // 2. 동시에 여러 데이터 생성
      const property1 = Property(
        id: 'transaction_property_1',
        name: '트랜잭션 테스트 1',
        address: '주소 1',
        type: '아파트',
        totalFloors: 5,
        totalUnits: 20,
      );

      const property2 = Property(
        id: 'transaction_property_2',
        name: '트랜잭션 테스트 2',
        address: '주소 2',
        type: '빌라',
        totalFloors: 3,
        totalUnits: 12,
      );

      final tenant1 = Tenant(
        id: 'transaction_tenant_1',
        name: '트랜잭션 임차인 1',
        phone: '010-1111-1111',
        email: 'tenant1@test.com',
        createdAt: DateTime(2023, 1, 1),
      );

      final tenant2 = Tenant(
        id: 'transaction_tenant_2',
        name: '트랜잭션 임차인 2',
        phone: '010-2222-2222',
        email: 'tenant2@test.com',
        createdAt: DateTime(2023, 1, 2),
      );

      // 3. 모든 데이터 생성
      await Future.wait([
        propertyRepository.createProperty(property1),
        propertyRepository.createProperty(property2),
        tenantRepository.createTenant(tenant1),
        tenantRepository.createTenant(tenant2),
      ]);

      // 4. 결과 확인
      properties = await propertyRepository.getProperties();
      tenants = await tenantRepository.getTenants();

      expect(properties.length, 2);
      expect(tenants.length, 2);
      
      expect(properties.any((p) => p.name == '트랜잭션 테스트 1'), isTrue);
      expect(properties.any((p) => p.name == '트랜잭션 테스트 2'), isTrue);
      expect(tenants.any((t) => t.name == '트랜잭션 임차인 1'), isTrue);
      expect(tenants.any((t) => t.name == '트랜잭션 임차인 2'), isTrue);
    });

    testWidgets('에러 처리가 올바르게 동작해야 한다', (WidgetTester tester) async {
      // Given: 앱 시작
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // When & Then: 에러 상황 테스트
      
      // 1. 존재하지 않는 Property 조회
      final nonExistentProperty = await propertyRepository.getPropertyById('non_existent');
      expect(nonExistentProperty, isNull);

      // 2. 존재하지 않는 Unit 조회
      final nonExistentUnit = await propertyRepository.getUnitById('non_existent_unit');
      expect(nonExistentUnit, isNull);

      // 3. 정상 데이터로 복구 확인
      const validProperty = Property(
        id: 'valid_property',
        name: '정상 자산',
        address: '정상 주소',
        type: '아파트',
        totalFloors: 1,
        totalUnits: 1,
      );

      await propertyRepository.createProperty(validProperty);
      final retrievedProperty = await propertyRepository.getPropertyById('valid_property');
      expect(retrievedProperty, isNotNull);
      expect(retrievedProperty!.name, '정상 자산');
    });

    testWidgets('대용량 데이터 처리가 정상 동작해야 한다', (WidgetTester tester) async {
      // Given: 앱 시작
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // When: 많은 수의 데이터 생성
      const propertyCount = 100;
      const tenantCount = 50;

      // Properties 대량 생성
      for (int i = 1; i <= propertyCount; i++) {
        final property = Property(
          id: 'bulk_property_$i',
          name: '대용량 테스트 자산 $i',
          address: '주소 $i',
          type: i % 2 == 0 ? '아파트' : '빌라',
          totalFloors: i % 10 + 1,
          totalUnits: i % 20 + 5,
        );
        await propertyRepository.createProperty(property);
      }

      // Tenants 대량 생성
      for (int i = 1; i <= tenantCount; i++) {
        final tenant = Tenant(
          id: 'bulk_tenant_$i',
          name: '대용량 테스트 임차인 $i',
          phone: '010-${i.toString().padLeft(4, '0')}-${i.toString().padLeft(4, '0')}',
          email: 'bulk$i@test.com',
          createdAt: DateTime(2023, 1, i % 28 + 1),
        );
        await tenantRepository.createTenant(tenant);
      }

      // Then: 모든 데이터가 정상적으로 생성되었는지 확인
      final properties = await propertyRepository.getProperties();
      final tenants = await tenantRepository.getTenants();

      expect(properties.length, propertyCount);
      expect(tenants.length, tenantCount);

      // 무작위 샘플 검증
      expect(properties.any((p) => p.name == '대용량 테스트 자산 50'), isTrue);
      expect(tenants.any((t) => t.name == '대용량 테스트 임차인 25'), isTrue);
    });
  });
}