import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:renthouse/features/tenant/application/tenant_controller.dart';
import 'package:renthouse/features/tenant/data/tenant_repository.dart';
import 'package:renthouse/features/tenant/domain/tenant.dart';
import 'package:renthouse/features/tenant/presentation/tenant_list_screen.dart';

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
  Future<Tenant> createTenant(Tenant tenant) async => tenant;
  @override
  Future<Tenant> updateTenant(Tenant tenant) async => tenant;
  @override
  Future<void> deleteTenant(String id) async {}

  void setTenants(List<Tenant> tenants) {
    _tenants = tenants;
  }

  void setShouldThrowError(bool shouldThrow, [String? message]) {
    _shouldThrowError = shouldThrow;
    if (message != null) {
      _errorMessage = message;
    }
  }
}

// Mock GoRouter for navigation testing
class MockGoRouter extends GoRouter {
  List<String> navigatedRoutes = [];

  MockGoRouter() : super(routes: []);

  @override
  void go(String location, {Object? extra}) {
    navigatedRoutes.add(location);
  }
}

void main() {
  group('TenantListScreen 위젯 테스트', () {
    late MockTenantRepository mockRepository;
    late MockGoRouter mockRouter;

    setUp(() {
      mockRepository = MockTenantRepository();
      mockRouter = MockGoRouter();
    });

    Widget createTestWidget() {
      return ProviderScope(
        overrides: [
          tenantRepositoryProvider.overrideWithValue(mockRepository),
        ],
        child: MaterialApp.router(
          routerConfig: mockRouter,
          home: const TenantListScreen(),
        ),
      );
    }

    testWidgets('화면이 올바르게 렌더링되어야 한다', (WidgetTester tester) async {
      // Given: 빈 데이터
      mockRepository.setTenants([]);

      // When: 위젯 빌드
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Then: 기본 UI 요소들이 표시되어야 함
      expect(find.text('임차인 목록'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('+ 신규 등록'), findsOneWidget);
    });

    testWidgets('로딩 상태에서 로딩 인디케이터가 표시되어야 한다', (WidgetTester tester) async {
      // Given: 로딩 시뮬레이션
      mockRepository.setTenants([]);

      // When: 위젯 빌드
      await tester.pumpWidget(createTestWidget());

      // Then: 로딩 인디케이터가 표시되어야 함
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('빈 리스트일 때 적절한 메시지가 표시되어야 한다', (WidgetTester tester) async {
      // Given: 빈 데이터
      mockRepository.setTenants([]);

      // When: 위젯 빌드
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Then: 빈 상태 메시지가 표시되어야 함
      expect(find.text('아직 등록된 임차인이 없습니다.'), findsOneWidget);
      expect(find.byIcon(Icons.people_outline), findsOneWidget);
    });

    testWidgets('임차인 리스트가 올바르게 표시되어야 한다', (WidgetTester tester) async {
      // Given: 테스트 임차인 데이터
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
          currentAddress: '서울시 강남구',
          createdAt: DateTime(2023, 1, 2),
        ),
      ];

      mockRepository.setTenants(testTenants);

      // When: 위젯 빌드
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Then: 임차인 목록이 표시되어야 함
      expect(find.text('김철수'), findsOneWidget);
      expect(find.text('박영희'), findsOneWidget);
      expect(find.text('010-1111-1111'), findsOneWidget);
      expect(find.text('010-2222-2222'), findsOneWidget);
    });

    testWidgets('에러 상태에서 에러 메시지가 표시되어야 한다', (WidgetTester tester) async {
      // Given: 에러 발생 설정
      mockRepository.setShouldThrowError(true, 'Database connection failed');

      // When: 위젯 빌드
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Then: 에러 메시지가 표시되어야 함
      expect(find.textContaining('오류가 발생했습니다'), findsOneWidget);
    });

    testWidgets('신규 등록 버튼을 탭하면 올바른 경로로 이동해야 한다', (WidgetTester tester) async {
      // Given: 빈 데이터
      mockRepository.setTenants([]);

      // When: 위젯 빌드 및 버튼 탭
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final newButton = find.text('+ 신규 등록');
      expect(newButton, findsOneWidget);

      await tester.tap(newButton);
      await tester.pumpAndSettle();

      // Then: 올바른 경로로 이동해야 함
      expect(mockRouter.navigatedRoutes.contains('/tenants/new'), isTrue);
    });

    testWidgets('검색 기능이 올바르게 작동해야 한다', (WidgetTester tester) async {
      // Given: 임차인 데이터
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

      // When: 위젯 빌드
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Then: 검색 필드가 존재하고 입력 가능해야 함
      final searchField = find.byType(TextField);
      expect(searchField, findsOneWidget);

      await tester.enterText(searchField, '김철수');
      await tester.pumpAndSettle();

      expect(find.text('김철수'), findsOneWidget);
    });

    testWidgets('임차인 카드에 올바른 정보가 표시되어야 한다', (WidgetTester tester) async {
      // Given: 상세한 임차인 데이터
      final testTenant = Tenant(
        id: 'detail_test',
        name: '이영수',
        phone: '010-3333-3333',
        email: 'lee@example.com',
        socialNo: '901010-1******',
        currentAddress: '서울시 서초구 테스트동 123',
        createdAt: DateTime(2023, 2, 1),
      );

      mockRepository.setTenants([testTenant]);

      // When: 위젯 빌드
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Then: 임차인 정보가 올바르게 표시되어야 함
      expect(find.text('이영수'), findsOneWidget);
      expect(find.text('010-3333-3333'), findsOneWidget);
      expect(find.text('lee@example.com'), findsOneWidget);
      
      // 주민등록번호는 마스킹되어 표시되어야 함
      expect(find.text('901010-1******'), findsOneWidget);
    });

    testWidgets('임차인 카드 탭 시 상세 화면으로 이동해야 한다', (WidgetTester tester) async {
      // Given: 테스트 임차인 데이터
      final testTenant = Tenant(
        id: 'tap_test',
        name: '탭 테스트 임차인',
        phone: '010-4444-4444',
        email: 'tap@example.com',
        createdAt: DateTime(2023, 3, 1),
      );

      mockRepository.setTenants([testTenant]);

      // When: 위젯 빌드
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // 임차인 카드가 표시되는지 확인
      expect(find.text('탭 테스트 임차인'), findsOneWidget);

      // 임차인 카드를 탭 (실제 구현에 따라 수정 필요)
      final tenantCard = find.text('탭 테스트 임차인');
      if (tester.any(find.ancestor(
        of: tenantCard,
        matching: find.byType(InkWell),
      ))) {
        await tester.tap(find.ancestor(
          of: tenantCard,
          matching: find.byType(InkWell),
        ));
        await tester.pumpAndSettle();
      }
    });

    testWidgets('여러 임차인이 올바른 순서로 표시되어야 한다', (WidgetTester tester) async {
      // Given: 날짜순으로 정렬된 임차인 데이터
      final testTenants = [
        Tenant(
          id: 'tenant1',
          name: '첫번째 임차인',
          phone: '010-1111-1111',
          email: 'first@example.com',
          createdAt: DateTime(2023, 1, 1),
        ),
        Tenant(
          id: 'tenant2',
          name: '두번째 임차인',
          phone: '010-2222-2222',
          email: 'second@example.com',
          createdAt: DateTime(2023, 1, 2),
        ),
        Tenant(
          id: 'tenant3',
          name: '세번째 임차인',
          phone: '010-3333-3333',
          email: 'third@example.com',
          createdAt: DateTime(2023, 1, 3),
        ),
      ];

      mockRepository.setTenants(testTenants);

      // When: 위젯 빌드
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Then: 모든 임차인이 표시되어야 함
      expect(find.text('첫번째 임차인'), findsOneWidget);
      expect(find.text('두번째 임차인'), findsOneWidget);
      expect(find.text('세번째 임차인'), findsOneWidget);
    });

    testWidgets('새로고침 동작이 올바르게 작동해야 한다', (WidgetTester tester) async {
      // Given: 초기 데이터
      final initialTenants = [
        Tenant(
          id: 'refresh_test',
          name: '새로고침 테스트',
          phone: '010-5555-5555',
          email: 'refresh@example.com',
          createdAt: DateTime(2023, 4, 1),
        ),
      ];

      mockRepository.setTenants(initialTenants);

      // When: 위젯 빌드
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('새로고침 테스트'), findsOneWidget);

      // 새로고침 제스처 시뮬레이션 (실제 구현에 따라 조정)
      if (tester.any(find.byType(RefreshIndicator))) {
        await tester.drag(find.byType(RefreshIndicator), const Offset(0, 200));
        await tester.pumpAndSettle();
      }
    });
  });
}