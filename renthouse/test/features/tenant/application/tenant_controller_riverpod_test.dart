import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:renthouse/features/tenant/application/tenant_controller.dart';
import 'package:renthouse/features/tenant/data/tenant_repository.dart';
import 'package:renthouse/features/tenant/domain/tenant.dart';

// Mock TenantRepository for testing
class MockTenantRepository implements TenantRepository {
  List<Tenant> _tenants = [];
  bool _shouldThrowError = false;
  String _errorMessage = 'Test error';

  @override
  Future<List<Tenant>> getTenants() async {
    await Future.delayed(const Duration(milliseconds: 10));
    
    if (_shouldThrowError) {
      throw Exception(_errorMessage);
    }
    
    return List.from(_tenants);
  }

  @override
  Future<Tenant> createTenant(Tenant tenant) async {
    if (_shouldThrowError) {
      throw Exception(_errorMessage);
    }
    _tenants.add(tenant);
    return tenant;
  }

  @override
  Future<Tenant> updateTenant(Tenant tenant) async {
    if (_shouldThrowError) {
      throw Exception(_errorMessage);
    }
    
    final index = _tenants.indexWhere((t) => t.id == tenant.id);
    if (index != -1) {
      _tenants[index] = tenant;
    }
    return tenant;
  }

  @override
  Future<void> deleteTenant(String id) async {
    if (_shouldThrowError) {
      throw Exception(_errorMessage);
    }
    _tenants.removeWhere((t) => t.id == id);
  }

  // Mock 설정 메서드들
  void setTenants(List<Tenant> tenants) {
    _tenants = tenants;
  }

  void setShouldThrowError(bool shouldThrow, [String? message]) {
    _shouldThrowError = shouldThrow;
    if (message != null) {
      _errorMessage = message;
    }
  }

  void clearTenants() {
    _tenants.clear();
  }
}

void main() {
  group('TenantController (Riverpod) 테스트', () {
    late MockTenantRepository mockRepository;
    late ProviderContainer container;

    setUp(() {
      mockRepository = MockTenantRepository();
      container = ProviderContainer(
        overrides: [
          tenantRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('초기 상태에서 빈 리스트를 로드해야 한다', () async {
      // Given: 빈 repository
      mockRepository.setTenants([]);

      // When: Provider 읽기
      final asyncValue = await container.read(tenantControllerProvider.future);

      // Then: 빈 리스트가 반환되어야 함
      expect(asyncValue, isEmpty);
    });

    test('Tenants를 성공적으로 로드해야 한다', () async {
      // Given: Mock repository에 테스트 데이터 설정
      final testTenants = [
        Tenant(
          id: 'tenant1',
          name: '김철수',
          phone: '010-1111-1111',
          email: 'kim@example.com',
          createdAt: DateTime(2023, 1, 1),
        ),
        Tenant(
          id: 'tenant2',
          name: '박영희',
          phone: '010-2222-2222',
          email: 'park@example.com',
          createdAt: DateTime(2023, 1, 2),
        ),
      ];

      mockRepository.setTenants(testTenants);

      // When: Provider 읽기
      final asyncValue = await container.read(tenantControllerProvider.future);

      // Then: 올바른 데이터가 로드되어야 함
      expect(asyncValue.length, 2);
      expect(asyncValue[0].name, '김철수');
      expect(asyncValue[1].name, '박영희');
    });

    test('로드 중 에러가 발생하면 AsyncError 상태가 되어야 한다', () async {
      // Given: Mock repository에서 에러 발생하도록 설정
      mockRepository.setShouldThrowError(true, 'Database connection failed');

      // When: Provider 읽기 시도
      final asyncValue = container.read(tenantControllerProvider);

      // Then: 에러 상태가 되어야 함
      await expectLater(
        asyncValue.value,
        throwsA(isA<Exception>()),
      );
    });

    test('새로운 Tenant를 추가할 수 있어야 한다', () async {
      // Given: 초기 데이터 설정
      final initialTenants = [
        Tenant(
          id: 'existing1',
          name: '기존 임차인',
          phone: '010-1111-1111',
          email: 'existing@example.com',
          createdAt: DateTime(2023, 1, 1),
        ),
      ];

      mockRepository.setTenants(initialTenants);

      // 초기 상태 확인
      var tenants = await container.read(tenantControllerProvider.future);
      expect(tenants.length, 1);

      // When: 새로운 Tenant 추가
      final newTenant = Tenant(
        id: 'new1',
        name: '새로운 임차인',
        phone: '010-2222-2222',
        email: 'new@example.com',
        createdAt: DateTime(2023, 1, 2),
      );

      await container.read(tenantControllerProvider.notifier).addTenant(newTenant);

      // Then: 새로운 Tenant가 추가되어야 함
      tenants = await container.read(tenantControllerProvider.future);
      expect(tenants.length, 2);
      expect(tenants.any((t) => t.name == '새로운 임차인'), isTrue);
    });

    test('Tenant를 수정할 수 있어야 한다', () async {
      // Given: 기존 Tenant 설정
      final existingTenant = Tenant(
        id: 'update_test',
        name: '수정 전 이름',
        phone: '010-1111-1111',
        email: 'before@example.com',
        createdAt: DateTime(2023, 1, 1),
      );

      mockRepository.setTenants([existingTenant]);

      // 초기 상태 확인
      var tenants = await container.read(tenantControllerProvider.future);
      expect(tenants[0].name, '수정 전 이름');

      // When: Tenant 수정
      final updatedTenant = existingTenant.copyWith(
        name: '수정 후 이름',
        phone: '010-9999-9999',
      );

      await container.read(tenantControllerProvider.notifier).updateTenant(updatedTenant);

      // Then: Tenant가 수정되어야 함
      tenants = await container.read(tenantControllerProvider.future);
      final updated = tenants.firstWhere((t) => t.id == 'update_test');
      expect(updated.name, '수정 후 이름');
      expect(updated.phone, '010-9999-9999');
    });

    test('Tenant를 삭제할 수 있어야 한다', () async {
      // Given: 기존 Tenants 설정
      final existingTenants = [
        Tenant(
          id: 'delete_test',
          name: '삭제될 임차인',
          phone: '010-1111-1111',
          email: 'delete@example.com',
          createdAt: DateTime(2023, 1, 1),
        ),
        Tenant(
          id: 'keep_test',
          name: '유지될 임차인',
          phone: '010-2222-2222',
          email: 'keep@example.com',
          createdAt: DateTime(2023, 1, 2),
        ),
      ];

      mockRepository.setTenants(existingTenants);

      // 초기 상태 확인
      var tenants = await container.read(tenantControllerProvider.future);
      expect(tenants.length, 2);

      // When: Tenant 삭제
      await container.read(tenantControllerProvider.notifier).deleteTenant('delete_test');

      // Then: 해당 Tenant가 삭제되어야 함
      tenants = await container.read(tenantControllerProvider.future);
      expect(tenants.length, 1);
      expect(tenants[0].name, '유지될 임차인');
      expect(tenants.any((t) => t.id == 'delete_test'), isFalse);
    });

    test('CRUD 작업 중 에러가 발생하면 AsyncError 상태가 되어야 한다', () async {
      // Given: 초기 데이터 설정 후 에러 상태로 변경
      final initialTenants = [
        Tenant(
          id: 'error_test',
          name: '에러 테스트',
          phone: '010-1111-1111',
          email: 'error@example.com',
          createdAt: DateTime(2023, 1, 1),
        ),
      ];

      mockRepository.setTenants(initialTenants);

      // 초기 로드 성공 확인
      var tenants = await container.read(tenantControllerProvider.future);
      expect(tenants.length, 1);

      // When: 에러 발생 설정 후 작업 수행
      mockRepository.setShouldThrowError(true, 'Operation failed');

      final newTenant = Tenant(
        id: 'new_error',
        name: '에러 발생 임차인',
        phone: '010-2222-2222',
        email: 'error_new@example.com',
        createdAt: DateTime(2023, 1, 2),
      );

      await container.read(tenantControllerProvider.notifier).addTenant(newTenant);

      // Then: AsyncError 상태가 되어야 함
      final asyncValue = container.read(tenantControllerProvider);
      expect(asyncValue.hasError, isTrue);
      expect(asyncValue.error.toString(), contains('Operation failed'));
    });

    test('Provider 상태 변화를 올바르게 추적할 수 있어야 한다', () async {
      // Given: 초기 빈 상태
      mockRepository.setTenants([]);

      final controller = container.read(tenantControllerProvider.notifier);

      // When: 여러 작업 수행
      final tenant1 = Tenant(
        id: 'track1',
        name: '추적 테스트 1',
        phone: '010-1111-1111',
        email: 'track1@example.com',
        createdAt: DateTime(2023, 1, 1),
      );

      await controller.addTenant(tenant1);
      var tenants = await container.read(tenantControllerProvider.future);
      expect(tenants.length, 1);

      final tenant2 = Tenant(
        id: 'track2',
        name: '추적 테스트 2',
        phone: '010-2222-2222',
        email: 'track2@example.com',
        createdAt: DateTime(2023, 1, 2),
      );

      await controller.addTenant(tenant2);
      tenants = await container.read(tenantControllerProvider.future);
      expect(tenants.length, 2);

      await controller.deleteTenant('track1');
      tenants = await container.read(tenantControllerProvider.future);
      expect(tenants.length, 1);
      expect(tenants[0].name, '추적 테스트 2');
    });
  });
}