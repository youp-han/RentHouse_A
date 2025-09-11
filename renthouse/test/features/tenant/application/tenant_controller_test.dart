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
  group('TenantListController 테스트', () {
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

    test('초기 상태는 loading이어야 한다', () {
      final controller = TenantListController(mockRepository);
      expect(controller.state, TenantListState.loading);
    });

    test('Tenants를 성공적으로 로드하면 success 상태가 되어야 한다', () async {
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
          socialNo: '850101-2******',
          createdAt: DateTime(2023, 1, 2),
        ),
      ];

      mockRepository.setTenants(testTenants);

      // When: Controller 생성
      final controller = TenantListController(mockRepository);

      // 비동기 작업 완료까지 대기
      await Future.delayed(const Duration(milliseconds: 50));

      // Then: 상태가 success이고 tenants가 로드되어야 함
      expect(controller.state, TenantListState.success);
      expect(controller.tenants.length, 2);
      expect(controller.tenants[0].name, '김철수');
      expect(controller.tenants[1].name, '박영희');
      expect(controller.errorMessage, isNull);
    });

    test('Tenants 로드 중 에러가 발생하면 error 상태가 되어야 한다', () async {
      // Given: Mock repository에서 에러 발생하도록 설정
      mockRepository.setShouldThrowError(true, 'Database connection failed');

      // When: Controller 생성
      final controller = TenantListController(mockRepository);

      // 비동기 작업 완료까지 대기
      await Future.delayed(const Duration(milliseconds: 50));

      // Then: 상태가 error이고 에러 메시지가 설정되어야 함
      expect(controller.state, TenantListState.error);
      expect(controller.errorMessage, contains('Database connection failed'));
      expect(controller.tenants, isEmpty);
    });

    test('refreshTenants를 호출하면 데이터를 다시 로드해야 한다', () async {
      // Given: 초기 데이터 설정
      final initialTenants = [
        Tenant(
          id: 'initial1',
          name: '초기 임차인',
          phone: '010-1111-1111',
          email: 'initial@example.com',
          createdAt: DateTime(2023, 1, 1),
        ),
      ];

      mockRepository.setTenants(initialTenants);
      final controller = TenantListController(mockRepository);

      // 초기 로딩 완료까지 대기
      await Future.delayed(const Duration(milliseconds: 50));
      expect(controller.tenants.length, 1);
      expect(controller.tenants[0].name, '초기 임차인');

      // When: 데이터 변경 후 refresh 호출
      final updatedTenants = [
        Tenant(
          id: 'updated1',
          name: '갱신된 임차인',
          phone: '010-3333-3333',
          email: 'updated@example.com',
          createdAt: DateTime(2023, 2, 1),
        ),
        Tenant(
          id: 'updated2',
          name: '새로운 임차인',
          phone: '010-4444-4444',
          email: 'new@example.com',
          createdAt: DateTime(2023, 2, 2),
        ),
      ];

      mockRepository.setTenants(updatedTenants);
      await controller.refreshTenants();

      // Then: 새로운 데이터가 로드되어야 함
      expect(controller.state, TenantListState.success);
      expect(controller.tenants.length, 2);
      expect(controller.tenants[0].name, '갱신된 임차인');
      expect(controller.tenants[1].name, '새로운 임차인');
    });

    test('빈 리스트도 정상적으로 처리되어야 한다', () async {
      // Given: 빈 리스트 설정
      mockRepository.setTenants([]);

      // When: Controller 생성
      final controller = TenantListController(mockRepository);

      // 비동기 작업 완료까지 대기
      await Future.delayed(const Duration(milliseconds: 50));

      // Then: 성공 상태이지만 tenants는 비어있어야 함
      expect(controller.state, TenantListState.success);
      expect(controller.tenants, isEmpty);
      expect(controller.errorMessage, isNull);
    });
  });

  group('TenantFormController 테스트', () {
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

    test('초기 상태는 idle이어야 한다', () {
      final controller = TenantFormController(mockRepository);
      expect(controller.state, TenantFormState.idle);
    });

    test('Tenant를 성공적으로 생성할 수 있어야 한다', () async {
      // Given: Form controller 생성
      final controller = TenantFormController(mockRepository);

      final newTenant = Tenant(
        id: 'new_tenant_1',
        name: '새로운 임차인',
        phone: '010-5555-5555',
        email: 'new@example.com',
        createdAt: DateTime(2023, 3, 1),
      );

      // When: Tenant 생성
      await controller.createTenant(newTenant);

      // Then: 성공 상태가 되어야 함
      expect(controller.state, TenantFormState.success);
      expect(controller.errorMessage, isNull);

      // Repository에 추가되었는지 확인
      final tenants = await mockRepository.getTenants();
      expect(tenants.length, 1);
      expect(tenants[0].name, '새로운 임차인');
    });

    test('Tenant 생성 중 에러가 발생하면 error 상태가 되어야 한다', () async {
      // Given: Form controller와 에러 설정
      final controller = TenantFormController(mockRepository);
      mockRepository.setShouldThrowError(true, 'Validation failed');

      final newTenant = Tenant(
        id: 'error_tenant',
        name: '에러 임차인',
        phone: '010-6666-6666',
        email: 'error@example.com',
        createdAt: DateTime(2023, 3, 2),
      );

      // When: Tenant 생성 시도
      await controller.createTenant(newTenant);

      // Then: 에러 상태가 되어야 함
      expect(controller.state, TenantFormState.error);
      expect(controller.errorMessage, contains('Validation failed'));
    });

    test('Tenant를 성공적으로 수정할 수 있어야 한다', () async {
      // Given: 기존 Tenant 설정
      final existingTenant = Tenant(
        id: 'update_tenant',
        name: '수정 전 이름',
        phone: '010-7777-7777',
        email: 'before@example.com',
        createdAt: DateTime(2023, 3, 3),
      );

      mockRepository.setTenants([existingTenant]);
      final controller = TenantFormController(mockRepository);

      // When: Tenant 수정
      final updatedTenant = existingTenant.copyWith(
        name: '수정 후 이름',
        phone: '010-8888-8888',
      );

      await controller.updateTenant(updatedTenant);

      // Then: 성공 상태가 되어야 함
      expect(controller.state, TenantFormState.success);
      expect(controller.errorMessage, isNull);

      // Repository에서 수정되었는지 확인
      final tenants = await mockRepository.getTenants();
      final updated = tenants.firstWhere((t) => t.id == 'update_tenant');
      expect(updated.name, '수정 후 이름');
      expect(updated.phone, '010-8888-8888');
    });

    test('Tenant를 성공적으로 삭제할 수 있어야 한다', () async {
      // Given: 기존 Tenant 설정
      final existingTenant = Tenant(
        id: 'delete_tenant',
        name: '삭제될 임차인',
        phone: '010-9999-9999',
        email: 'delete@example.com',
        createdAt: DateTime(2023, 3, 4),
      );

      mockRepository.setTenants([existingTenant]);
      final controller = TenantFormController(mockRepository);

      // When: Tenant 삭제
      await controller.deleteTenant('delete_tenant');

      // Then: 성공 상태가 되어야 함
      expect(controller.state, TenantFormState.success);
      expect(controller.errorMessage, isNull);

      // Repository에서 삭제되었는지 확인
      final tenants = await mockRepository.getTenants();
      expect(tenants.isEmpty, isTrue);
    });

    test('로딩 상태가 올바르게 관리되어야 한다', () async {
      // Given: Form controller 생성
      final controller = TenantFormController(mockRepository);

      final newTenant = Tenant(
        id: 'loading_test',
        name: '로딩 테스트',
        phone: '010-0000-0000',
        email: 'loading@example.com',
        createdAt: DateTime(2023, 3, 5),
      );

      // When: 비동기 작업 시작 (상태 변화 확인)
      expect(controller.state, TenantFormState.idle);

      final future = controller.createTenant(newTenant);
      
      // 로딩 상태 확인을 위한 짧은 대기
      await Future.delayed(const Duration(milliseconds: 5));
      expect(controller.state, TenantFormState.loading);

      // 작업 완료까지 대기
      await future;
      expect(controller.state, TenantFormState.success);
    });

    test('상태를 리셋할 수 있어야 한다', () async {
      // Given: 에러 상태인 controller
      final controller = TenantFormController(mockRepository);
      mockRepository.setShouldThrowError(true, 'Some error');

      final newTenant = Tenant(
        id: 'reset_test',
        name: '리셋 테스트',
        phone: '010-1010-1010',
        email: 'reset@example.com',
        createdAt: DateTime(2023, 3, 6),
      );

      await controller.createTenant(newTenant);
      expect(controller.state, TenantFormState.error);

      // When: 상태 리셋
      controller.resetState();

      // Then: idle 상태로 돌아가야 함
      expect(controller.state, TenantFormState.idle);
      expect(controller.errorMessage, isNull);
    });
  });
}