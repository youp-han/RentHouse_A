import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:renthouse/features/property/application/property_controller.dart';
import 'package:renthouse/features/property/data/property_repository.dart';
import 'package:renthouse/features/property\domain\property.dart';

// Mock PropertyRepository for testing
class MockPropertyRepository implements PropertyRepository {
  List<Property> _properties = [];
  bool _shouldThrowError = false;
  String _errorMessage = 'Test error';

  @override
  Future<List<Property>> getProperties() async {
    await Future.delayed(const Duration(milliseconds: 10)); // Simulate async delay
    
    if (_shouldThrowError) {
      throw Exception(_errorMessage);
    }
    
    return List.from(_properties);
  }

  // Mock 설정 메서드들
  void setProperties(List<Property> properties) {
    _properties = properties;
  }

  void setShouldThrowError(bool shouldThrow, [String? message]) {
    _shouldThrowError = shouldThrow;
    if (message != null) {
      _errorMessage = message;
    }
  }

  // 나머지 메서드들은 테스트에서 사용하지 않으므로 기본 구현
  @override
  Future<Property?> getPropertyById(String id) async => null;

  @override
  Future<Property> createProperty(Property property) async => property;

  @override
  Future<Property> updateProperty(Property property) async => property;

  @override
  Future<void> deleteProperty(String id) async {}

  @override
  dynamic addUnit(unit) async => unit;

  @override
  dynamic updateUnit(unit) async => unit;

  @override
  Future<void> deleteUnit(String id) async {}

  @override
  dynamic getUnitById(String id) async => null;

  @override
  dynamic getAllUnits() async => [];
}

void main() {
  group('PropertyListController 테스트', () {
    late MockPropertyRepository mockRepository;
    late ProviderContainer container;

    setUp(() {
      mockRepository = MockPropertyRepository();
      container = ProviderContainer(
        overrides: [
          propertyRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('초기 상태는 loading이어야 한다', () {
      final controller = PropertyListController(mockRepository);
      expect(controller.state, PropertyListState.loading);
    });

    test('Properties를 성공적으로 로드하면 success 상태가 되어야 한다', () async {
      // Given: Mock repository에 테스트 데이터 설정
      final testProperties = [
        const Property(
          id: 'property1',
          name: '테스트 아파트 1',
          address: '서울시 강남구',
          type: '아파트',
          totalFloors: 10,
          totalUnits: 50,
        ),
        const Property(
          id: 'property2',
          name: '테스트 빌라 2',
          address: '서울시 서초구',
          type: '빌라',
          totalFloors: 3,
          totalUnits: 12,
        ),
      ];

      mockRepository.setProperties(testProperties);

      // When: Controller 생성 (자동으로 _loadProperties 호출됨)
      final controller = PropertyListController(mockRepository);

      // 비동기 작업 완료까지 대기
      await Future.delayed(const Duration(milliseconds: 50));

      // Then: 상태가 success이고 properties가 로드되어야 함
      expect(controller.state, PropertyListState.success);
      expect(controller.properties.length, 2);
      expect(controller.properties[0].name, '테스트 아파트 1');
      expect(controller.properties[1].name, '테스트 빌라 2');
      expect(controller.errorMessage, isNull);
    });

    test('Properties 로드 중 에러가 발생하면 error 상태가 되어야 한다', () async {
      // Given: Mock repository에서 에러 발생하도록 설정
      mockRepository.setShouldThrowError(true, 'Network connection failed');

      // When: Controller 생성
      final controller = PropertyListController(mockRepository);

      // 비동기 작업 완료까지 대기
      await Future.delayed(const Duration(milliseconds: 50));

      // Then: 상태가 error이고 에러 메시지가 설정되어야 함
      expect(controller.state, PropertyListState.error);
      expect(controller.errorMessage, contains('Network connection failed'));
      expect(controller.properties, isEmpty);
    });

    test('refreshProperties를 호출하면 데이터를 다시 로드해야 한다', () async {
      // Given: 초기 데이터 설정
      final initialProperties = [
        const Property(
          id: 'initial1',
          name: '초기 아파트',
          address: '초기 주소',
          type: '아파트',
          totalFloors: 5,
          totalUnits: 25,
        ),
      ];

      mockRepository.setProperties(initialProperties);
      final controller = PropertyListController(mockRepository);

      // 초기 로딩 완료까지 대기
      await Future.delayed(const Duration(milliseconds: 50));
      expect(controller.properties.length, 1);
      expect(controller.properties[0].name, '초기 아파트');

      // When: 데이터 변경 후 refresh 호출
      final updatedProperties = [
        const Property(
          id: 'updated1',
          name: '갱신된 아파트',
          address: '갱신된 주소',
          type: '아파트',
          totalFloors: 7,
          totalUnits: 35,
        ),
        const Property(
          id: 'updated2',
          name: '새로운 빌라',
          address: '새로운 주소',
          type: '빌라',
          totalFloors: 2,
          totalUnits: 8,
        ),
      ];

      mockRepository.setProperties(updatedProperties);
      await controller.refreshProperties();

      // Then: 새로운 데이터가 로드되어야 함
      expect(controller.state, PropertyListState.success);
      expect(controller.properties.length, 2);
      expect(controller.properties[0].name, '갱신된 아파트');
      expect(controller.properties[1].name, '새로운 빌라');
    });

    test('refresh 중 에러가 발생하면 error 상태로 변경되어야 한다', () async {
      // Given: 초기에는 성공적으로 로드
      final initialProperties = [
        const Property(
          id: 'success1',
          name: '성공 아파트',
          address: '성공 주소',
          type: '아파트',
          totalFloors: 3,
          totalUnits: 15,
        ),
      ];

      mockRepository.setProperties(initialProperties);
      final controller = PropertyListController(mockRepository);

      // 초기 로딩 완료까지 대기
      await Future.delayed(const Duration(milliseconds: 50));
      expect(controller.state, PropertyListState.success);

      // When: 에러 발생하도록 설정 후 refresh
      mockRepository.setShouldThrowError(true, 'Refresh failed');
      await controller.refreshProperties();

      // Then: 에러 상태로 변경되어야 함
      expect(controller.state, PropertyListState.error);
      expect(controller.errorMessage, contains('Refresh failed'));
    });

    test('빈 리스트도 정상적으로 처리되어야 한다', () async {
      // Given: 빈 리스트 설정
      mockRepository.setProperties([]);

      // When: Controller 생성
      final controller = PropertyListController(mockRepository);

      // 비동기 작업 완료까지 대기
      await Future.delayed(const Duration(milliseconds: 50));

      // Then: 성공 상태이지만 properties는 비어있어야 함
      expect(controller.state, PropertyListState.success);
      expect(controller.properties, isEmpty);
      expect(controller.errorMessage, isNull);
    });

    test('Provider를 통한 상태 관리가 올바르게 동작해야 한다', () async {
      // Given: 테스트 데이터 설정
      final testProperties = [
        const Property(
          id: 'provider1',
          name: 'Provider 테스트',
          address: 'Provider 주소',
          type: '아파트',
          totalFloors: 4,
          totalUnits: 20,
        ),
      ];

      mockRepository.setProperties(testProperties);

      // When: Provider를 통해 controller 접근
      final controller = container.read(propertyListControllerProvider.notifier);

      // 비동기 작업 완료까지 대기
      await Future.delayed(const Duration(milliseconds: 50));

      // Then: Provider를 통한 상태도 올바르게 동작해야 함
      final state = container.read(propertyListControllerProvider);
      expect(state, PropertyListState.success);
      expect(controller.properties.length, 1);
      expect(controller.properties[0].name, 'Provider 테스트');
    });
  });
}