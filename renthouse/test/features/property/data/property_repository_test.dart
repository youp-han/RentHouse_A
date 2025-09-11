import 'package:flutter_test/flutter_test.dart';
import 'package:renthouse/core/database/app_database.dart';
import 'package:renthouse/features/property/data/property_repository.dart';
import 'package:renthouse/features/property/domain/property.dart';
import 'package:renthouse/features/property/domain/unit.dart';
import 'package:drift/native.dart';

void main() {
  group('PropertyRepository 테스트', () {
    late AppDatabase database;
    late PropertyRepository repository;

    setUp(() async {
      // 테스트용 인메모리 데이터베이스 생성
      database = AppDatabase(NativeDatabase.memory());
      repository = PropertyRepository(database);
    });

    tearDown(() async {
      await database.close();
    });

    group('Property CRUD 테스트', () {
      test('새로운 Property를 생성할 수 있어야 한다', () async {
        const property = Property(
          id: 'test_property_1',
          name: '테스트 아파트',
          address: '서울시 강남구 테스트동 123',
          type: '아파트',
          totalFloors: 10,
          totalUnits: 50,
          rent: 1000000,
        );

        final result = await repository.createProperty(property);

        expect(result.id, property.id);
        expect(result.name, property.name);
        expect(result.address, property.address);
        expect(result.type, property.type);
      });

      test('모든 Property 목록을 조회할 수 있어야 한다', () async {
        // Given: 여러 Property 생성
        const property1 = Property(
          id: 'property_1',
          name: '아파트 A',
          address: '주소 A',
          type: '아파트',
          totalFloors: 5,
          totalUnits: 20,
        );

        const property2 = Property(
          id: 'property_2',
          name: '빌라 B',
          address: '주소 B',
          type: '빌라',
          totalFloors: 3,
          totalUnits: 12,
        );

        await repository.createProperty(property1);
        await repository.createProperty(property2);

        // When: 모든 Property 조회
        final properties = await repository.getProperties();

        // Then: 2개의 Property가 조회되어야 함
        expect(properties.length, 2);
        expect(properties.any((p) => p.id == 'property_1'), isTrue);
        expect(properties.any((p) => p.id == 'property_2'), isTrue);
      });

      test('ID로 특정 Property를 조회할 수 있어야 한다', () async {
        // Given: Property 생성
        const property = Property(
          id: 'specific_property',
          name: '특정 아파트',
          address: '특정 주소',
          type: '아파트',
          totalFloors: 15,
          totalUnits: 100,
        );

        await repository.createProperty(property);

        // When: ID로 Property 조회
        final foundProperty = await repository.getPropertyById('specific_property');

        // Then: 해당 Property가 조회되어야 함
        expect(foundProperty, isNotNull);
        expect(foundProperty!.id, 'specific_property');
        expect(foundProperty.name, '특정 아파트');
      });

      test('존재하지 않는 ID로 조회하면 null을 반환해야 한다', () async {
        final foundProperty = await repository.getPropertyById('non_existent_id');
        expect(foundProperty, isNull);
      });

      test('Property를 수정할 수 있어야 한다', () async {
        // Given: Property 생성
        const originalProperty = Property(
          id: 'update_test',
          name: '원본 이름',
          address: '원본 주소',
          type: '아파트',
          totalFloors: 5,
          totalUnits: 20,
        );

        await repository.createProperty(originalProperty);

        // When: Property 수정
        final updatedProperty = originalProperty.copyWith(
          name: '수정된 이름',
          address: '수정된 주소',
          rent: 1500000,
        );

        await repository.updateProperty(updatedProperty);

        // Then: 수정된 내용이 반영되어야 함
        final result = await repository.getPropertyById('update_test');
        expect(result!.name, '수정된 이름');
        expect(result.address, '수정된 주소');
        expect(result.rent, 1500000);
        expect(result.type, originalProperty.type); // 변경되지 않은 필드
      });

      test('Property를 삭제할 수 있어야 한다', () async {
        // Given: Property 생성
        const property = Property(
          id: 'delete_test',
          name: '삭제될 아파트',
          address: '삭제될 주소',
          type: '아파트',
          totalFloors: 3,
          totalUnits: 10,
        );

        await repository.createProperty(property);

        // 생성 확인
        var foundProperty = await repository.getPropertyById('delete_test');
        expect(foundProperty, isNotNull);

        // When: Property 삭제
        await repository.deleteProperty('delete_test');

        // Then: 더 이상 조회되지 않아야 함
        foundProperty = await repository.getPropertyById('delete_test');
        expect(foundProperty, isNull);
      });
    });

    group('Unit CRUD 테스트', () {
      test('새로운 Unit을 추가할 수 있어야 한다', () async {
        // Given: Property 먼저 생성
        const property = Property(
          id: 'property_for_unit',
          name: '유닛 테스트 아파트',
          address: '유닛 테스트 주소',
          type: '아파트',
          totalFloors: 5,
          totalUnits: 20,
        );

        await repository.createProperty(property);

        // When: Unit 추가
        const unit = Unit(
          id: 'unit_test_1',
          propertyId: 'property_for_unit',
          unitNumber: '101',
          rentStatus: '공실',
          sizeMeter: 84.0,
          sizeKorea: 25.0,
          useType: '주거용',
          description: '남향, 베란다 있음',
        );

        final result = await repository.addUnit(unit);

        // Then: Unit이 정상적으로 추가되어야 함
        expect(result.id, unit.id);
        expect(result.propertyId, unit.propertyId);
        expect(result.unitNumber, unit.unitNumber);
      });

      test('ID로 특정 Unit을 조회할 수 있어야 한다', () async {
        // Given: Property와 Unit 생성
        const property = Property(
          id: 'property_for_unit_get',
          name: '조회 테스트 아파트',
          address: '조회 테스트 주소',
          type: '아파트',
          totalFloors: 3,
          totalUnits: 9,
        );

        const unit = Unit(
          id: 'unit_get_test',
          propertyId: 'property_for_unit_get',
          unitNumber: '201',
          rentStatus: '임대중',
          sizeMeter: 74.0,
          sizeKorea: 22.0,
          useType: '주거용',
        );

        await repository.createProperty(property);
        await repository.addUnit(unit);

        // When: Unit 조회
        final foundUnit = await repository.getUnitById('unit_get_test');

        // Then: 해당 Unit이 조회되어야 함
        expect(foundUnit, isNotNull);
        expect(foundUnit!.id, 'unit_get_test');
        expect(foundUnit.unitNumber, '201');
        expect(foundUnit.rentStatus, '임대중');
      });

      test('모든 Unit 목록을 조회할 수 있어야 한다', () async {
        // Given: Property와 여러 Unit 생성
        const property = Property(
          id: 'property_for_all_units',
          name: '전체 유닛 테스트',
          address: '전체 유닛 주소',
          type: '빌라',
          totalFloors: 2,
          totalUnits: 4,
        );

        const unit1 = Unit(
          id: 'unit_all_1',
          propertyId: 'property_for_all_units',
          unitNumber: '101',
          rentStatus: '임대중',
          sizeMeter: 50.0,
          sizeKorea: 15.0,
          useType: '주거용',
        );

        const unit2 = Unit(
          id: 'unit_all_2',
          propertyId: 'property_for_all_units',
          unitNumber: '102',
          rentStatus: '공실',
          sizeMeter: 50.0,
          sizeKorea: 15.0,
          useType: '주거용',
        );

        await repository.createProperty(property);
        await repository.addUnit(unit1);
        await repository.addUnit(unit2);

        // When: 모든 Unit 조회
        final allUnits = await repository.getAllUnits();

        // Then: 2개의 Unit이 조회되어야 함
        expect(allUnits.length, 2);
        expect(allUnits.any((u) => u.id == 'unit_all_1'), isTrue);
        expect(allUnits.any((u) => u.id == 'unit_all_2'), isTrue);
      });

      test('Unit을 수정할 수 있어야 한다', () async {
        // Given: Property와 Unit 생성
        const property = Property(
          id: 'property_for_unit_update',
          name: '유닛 수정 테스트',
          address: '유닛 수정 주소',
          type: '아파트',
          totalFloors: 1,
          totalUnits: 1,
        );

        const originalUnit = Unit(
          id: 'unit_update_test',
          propertyId: 'property_for_unit_update',
          unitNumber: '101',
          rentStatus: '공실',
          sizeMeter: 60.0,
          sizeKorea: 18.0,
          useType: '주거용',
        );

        await repository.createProperty(property);
        await repository.addUnit(originalUnit);

        // When: Unit 수정
        final updatedUnit = originalUnit.copyWith(
          rentStatus: '임대중',
          description: '수리 완료',
        );

        await repository.updateUnit(updatedUnit);

        // Then: 수정된 내용이 반영되어야 함
        final result = await repository.getUnitById('unit_update_test');
        expect(result!.rentStatus, '임대중');
        expect(result.description, '수리 완료');
        expect(result.unitNumber, originalUnit.unitNumber); // 변경되지 않은 필드
      });

      test('Unit을 삭제할 수 있어야 한다', () async {
        // Given: Property와 Unit 생성
        const property = Property(
          id: 'property_for_unit_delete',
          name: '유닛 삭제 테스트',
          address: '유닛 삭제 주소',
          type: '빌라',
          totalFloors: 1,
          totalUnits: 1,
        );

        const unit = Unit(
          id: 'unit_delete_test',
          propertyId: 'property_for_unit_delete',
          unitNumber: '101',
          rentStatus: '공실',
          sizeMeter: 40.0,
          sizeKorea: 12.0,
          useType: '주거용',
        );

        await repository.createProperty(property);
        await repository.addUnit(unit);

        // 생성 확인
        var foundUnit = await repository.getUnitById('unit_delete_test');
        expect(foundUnit, isNotNull);

        // When: Unit 삭제
        await repository.deleteUnit('unit_delete_test');

        // Then: 더 이상 조회되지 않아야 함
        foundUnit = await repository.getUnitById('unit_delete_test');
        expect(foundUnit, isNull);
      });
    });

    group('Property-Unit 관계 테스트', () {
      test('Property를 조회할 때 해당 Property의 Unit들도 함께 조회되어야 한다', () async {
        // Given: Property와 여러 Unit 생성
        const property = Property(
          id: 'property_with_units',
          name: '유닛 포함 아파트',
          address: '유닛 포함 주소',
          type: '아파트',
          totalFloors: 2,
          totalUnits: 4,
        );

        const units = [
          Unit(
            id: 'unit_rel_1',
            propertyId: 'property_with_units',
            unitNumber: '101',
            rentStatus: '임대중',
            sizeMeter: 84.0,
            sizeKorea: 25.0,
            useType: '주거용',
          ),
          Unit(
            id: 'unit_rel_2',
            propertyId: 'property_with_units',
            unitNumber: '102',
            rentStatus: '공실',
            sizeMeter: 84.0,
            sizeKorea: 25.0,
            useType: '주거용',
          ),
        ];

        await repository.createProperty(property);
        for (final unit in units) {
          await repository.addUnit(unit);
        }

        // When: Property 조회
        final foundProperty = await repository.getPropertyById('property_with_units');

        // Then: Property의 units 리스트에 Unit들이 포함되어야 함
        expect(foundProperty, isNotNull);
        expect(foundProperty!.units.length, 2);
        expect(foundProperty.units.any((u) => u.unitNumber == '101'), isTrue);
        expect(foundProperty.units.any((u) => u.unitNumber == '102'), isTrue);
      });
    });
  });
}