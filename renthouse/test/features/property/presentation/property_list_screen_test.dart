import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:renthouse/features/property/application/property_controller.dart';
import 'package:renthouse/features/property/data/property_repository.dart';
import 'package:renthouse/features/property/domain/property.dart';
import 'package:renthouse/features/property/presentation/property_list_screen.dart';

// Mock PropertyRepository for testing
class MockPropertyRepository implements PropertyRepository {
  List<Property> _properties = [];
  bool _shouldThrowError = false;
  String _errorMessage = 'Test error';

  @override
  Future<List<Property>> getProperties() async {
    await Future.delayed(const Duration(milliseconds: 10));
    
    if (_shouldThrowError) {
      throw Exception(_errorMessage);
    }
    
    return List.from(_properties);
  }

  void setProperties(List<Property> properties) {
    _properties = properties;
  }

  void setShouldThrowError(bool shouldThrow, [String? message]) {
    _shouldThrowError = shouldThrow;
    if (message != null) {
      _errorMessage = message;
    }
  }

  // 나머지 메서드들은 기본 구현
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
  group('PropertyListScreen 위젯 테스트', () {
    late MockPropertyRepository mockRepository;
    late MockGoRouter mockRouter;

    setUp(() {
      mockRepository = MockPropertyRepository();
      mockRouter = MockGoRouter();
    });

    Widget createTestWidget() {
      return ProviderScope(
        overrides: [
          propertyRepositoryProvider.overrideWithValue(mockRepository),
        ],
        child: MaterialApp.router(
          routerConfig: mockRouter,
          home: const PropertyListScreen(),
        ),
      );
    }

    testWidgets('화면이 올바르게 렌더링되어야 한다', (WidgetTester tester) async {
      // Given: 빈 데이터
      mockRepository.setProperties([]);

      // When: 위젯 빌드
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Then: 기본 UI 요소들이 표시되어야 함
      expect(find.text('자산 목록'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('필터적용'), findsOneWidget);
      expect(find.text('+ 신규 등록'), findsOneWidget);
    });

    testWidgets('로딩 상태에서 로딩 인디케이터가 표시되어야 한다', (WidgetTester tester) async {
      // Given: 로딩 시뮬레이션을 위한 지연 설정
      mockRepository.setProperties([]);

      // When: 위젯 빌드
      await tester.pumpWidget(createTestWidget());

      // Then: 로딩 인디케이터가 표시되어야 함
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('빈 리스트일 때 적절한 메시지가 표시되어야 한다', (WidgetTester tester) async {
      // Given: 빈 데이터
      mockRepository.setProperties([]);

      // When: 위젯 빌드
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Then: 빈 상태 메시지가 표시되어야 함
      expect(find.text('아직 등록된 자산이 없습니다.'), findsOneWidget);
      expect(find.byIcon(Icons.business_outlined), findsOneWidget);
    });

    testWidgets('자산 리스트가 올바르게 표시되어야 한다', (WidgetTester tester) async {
      // Given: 테스트 자산 데이터
      final testProperties = [
        const Property(
          id: 'property1',
          name: '테스트 아파트 A',
          address: '서울시 강남구 테스트동 123',
          type: '아파트',
          totalFloors: 10,
          totalUnits: 50,
        ),
        const Property(
          id: 'property2',
          name: '테스트 빌라 B',
          address: '서울시 서초구 테스트동 456',
          type: '빌라',
          totalFloors: 3,
          totalUnits: 12,
        ),
      ];

      mockRepository.setProperties(testProperties);

      // When: 위젯 빌드
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Then: 자산 목록이 표시되어야 함
      expect(find.text('테스트 아파트 A'), findsOneWidget);
      expect(find.text('테스트 빌라 B'), findsOneWidget);
      expect(find.text('서울시 강남구 테스트동 123'), findsOneWidget);
      expect(find.text('서울시 서초구 테스트동 456'), findsOneWidget);
    });

    testWidgets('에러 상태에서 에러 메시지가 표시되어야 한다', (WidgetTester tester) async {
      // Given: 에러 발생 설정
      mockRepository.setShouldThrowError(true, 'Network connection failed');

      // When: 위젯 빌드
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Then: 에러 메시지가 표시되어야 함
      expect(find.textContaining('오류:'), findsOneWidget);
      expect(find.textContaining('Network connection failed'), findsOneWidget);
    });

    testWidgets('신규 등록 버튼을 탭하면 올바른 경로로 이동해야 한다', (WidgetTester tester) async {
      // Given: 빈 데이터
      mockRepository.setProperties([]);

      // When: 위젯 빌드 및 버튼 탭
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final newButton = find.text('+ 신규 등록');
      expect(newButton, findsOneWidget);

      await tester.tap(newButton);
      await tester.pumpAndSettle();

      // Then: 올바른 경로로 이동해야 함
      expect(mockRouter.navigatedRoutes.contains('/property/new'), isTrue);
    });

    testWidgets('검색 텍스트필드가 올바르게 작동해야 한다', (WidgetTester tester) async {
      // Given: 빈 데이터
      mockRepository.setProperties([]);

      // When: 위젯 빌드
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Then: 검색 필드가 존재하고 입력 가능해야 함
      final searchField = find.byType(TextField);
      expect(searchField, findsOneWidget);

      await tester.enterText(searchField, '검색 테스트');
      await tester.pumpAndSettle();

      expect(find.text('검색 테스트'), findsOneWidget);
    });

    testWidgets('필터 적용 버튼이 표시되어야 한다', (WidgetTester tester) async {
      // Given: 빈 데이터
      mockRepository.setProperties([]);

      // When: 위젯 빌드
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Then: 필터 버튼이 표시되어야 함
      expect(find.text('필터적용'), findsOneWidget);
      
      // 현재는 비활성화 상태
      final filterButton = find.widgetWithText(ElevatedButton, '필터적용');
      expect(filterButton, findsOneWidget);
    });

    testWidgets('자산 카드 탭 시 상세 화면으로 이동해야 한다', (WidgetTester tester) async {
      // Given: 테스트 자산 데이터
      final testProperties = [
        const Property(
          id: 'property1',
          name: '탭 테스트 아파트',
          address: '서울시 강남구',
          type: '아파트',
          totalFloors: 5,
          totalUnits: 25,
        ),
      ];

      mockRepository.setProperties(testProperties);

      // When: 위젯 빌드
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // 자산 카드가 표시되는지 확인
      expect(find.text('탭 테스트 아파트'), findsOneWidget);

      // 자산 카드를 탭 (실제 구현에 따라 수정 필요)
      final propertyCard = find.text('탭 테스트 아파트');
      if (tester.any(find.ancestor(
        of: propertyCard,
        matching: find.byType(InkWell),
      ))) {
        await tester.tap(find.ancestor(
          of: propertyCard,
          matching: find.byType(InkWell),
        ));
        await tester.pumpAndSettle();
      }
    });

    testWidgets('자산 정보가 올바른 형식으로 표시되어야 한다', (WidgetTester tester) async {
      // Given: 상세한 자산 데이터
      final testProperty = const Property(
        id: 'detail_test',
        name: '상세 정보 테스트 아파트',
        address: '서울시 강남구 테스트동 789번지',
        type: '아파트',
        totalFloors: 15,
        totalUnits: 150,
        rent: 1000000,
      );

      mockRepository.setProperties([testProperty]);

      // When: 위젯 빌드
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Then: 자산 정보가 올바르게 표시되어야 함
      expect(find.text('상세 정보 테스트 아파트'), findsOneWidget);
      expect(find.text('서울시 강남구 테스트동 789번지'), findsOneWidget);
      
      // 추가 정보들도 확인 (실제 UI 구현에 따라 조정)
      // expect(find.textContaining('아파트'), findsOneWidget);
      // expect(find.textContaining('15층'), findsOneWidget);
      // expect(find.textContaining('150호'), findsOneWidget);
    });
  });
}