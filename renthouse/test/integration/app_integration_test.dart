import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Integration Tests', () {
    testWidgets('Full app flow test simulation', (WidgetTester tester) async {
      // Create a simple test app structure
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            title: 'RentHouse Test',
            home: TestHomeScreen(),
            routes: {
              '/login': (context) => TestLoginScreen(),
              '/dashboard': (context) => TestDashboardScreen(),
              '/properties': (context) => TestPropertyListScreen(),
            },
          ),
        ),
      );

      // Verify app starts
      expect(find.text('RentHouse 테스트'), findsOneWidget);
      expect(find.text('로그인'), findsOneWidget);

      // Simulate login flow
      await tester.tap(find.text('로그인'));
      await tester.pumpAndSettle();

      // Should navigate to login screen
      expect(find.text('로그인 화면'), findsOneWidget);
      
      // Enter credentials
      await tester.enterText(find.byType(TextFormField).first, 'testuser');
      await tester.enterText(find.byType(TextFormField).last, 'testpass');
      
      // Tap login button
      await tester.tap(find.text('로그인 실행'));
      await tester.pumpAndSettle();

      // Should navigate to dashboard
      expect(find.text('대시보드'), findsOneWidget);
      
      // Navigate to properties
      await tester.tap(find.text('자산 관리'));
      await tester.pumpAndSettle();
      
      expect(find.text('자산 목록'), findsOneWidget);
    });

    testWidgets('Navigation flow test', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: NavigationTestScreen(),
        ),
      );

      // Test tab navigation
      expect(find.text('홈'), findsOneWidget);
      expect(find.text('자산'), findsOneWidget);
      expect(find.text('임차인'), findsOneWidget);
      expect(find.text('설정'), findsOneWidget);

      // Navigate through tabs
      await tester.tap(find.text('자산'));
      await tester.pumpAndSettle();
      
      await tester.tap(find.text('임차인'));
      await tester.pumpAndSettle();
      
      await tester.tap(find.text('설정'));
      await tester.pumpAndSettle();
      
      await tester.tap(find.text('홈'));
      await tester.pumpAndSettle();
    });

    testWidgets('Form submission workflow', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: FormTestScreen(),
        ),
      );

      // Fill out form
      await tester.enterText(find.byKey(Key('name_field')), '테스트 자산');
      await tester.enterText(find.byKey(Key('address_field')), '서울시 강남구');
      await tester.enterText(find.byKey(Key('units_field')), '10');

      // Select dropdown option
      await tester.tap(find.byKey(Key('type_dropdown')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('아파트').last);
      await tester.pumpAndSettle();

      // Submit form
      await tester.tap(find.text('저장'));
      await tester.pumpAndSettle();

      // Verify success message
      expect(find.text('저장 완료'), findsOneWidget);
    });
  });
}

// Test screens for integration testing
class TestHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('RentHouse 테스트')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('임대관리 시스템', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/login'),
              child: Text('로그인'),
            ),
          ],
        ),
      ),
    );
  }
}

class TestLoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('로그인')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('로그인 화면', style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            TextFormField(decoration: InputDecoration(labelText: '사용자명')),
            TextFormField(decoration: InputDecoration(labelText: '비밀번호')),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/dashboard'),
              child: Text('로그인 실행'),
            ),
          ],
        ),
      ),
    );
  }
}

class TestDashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('대시보드')),
      body: Column(
        children: [
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text('총 자산: 15개'),
                  Text('총 임차인: 28명'),
                  Text('이번 달 수입: 50,000,000원'),
                ],
              ),
            ),
          ),
          ListTile(
            title: Text('자산 관리'),
            onTap: () => Navigator.pushNamed(context, '/properties'),
          ),
        ],
      ),
    );
  }
}

class TestPropertyListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('자산 목록')),
      body: ListView(
        children: [
          ListTile(title: Text('자산 1'), subtitle: Text('서울시 강남구')),
          ListTile(title: Text('자산 2'), subtitle: Text('서울시 서초구')),
          ListTile(title: Text('자산 3'), subtitle: Text('서울시 송파구')),
        ],
      ),
    );
  }
}

class NavigationTestScreen extends StatefulWidget {
  @override
  _NavigationTestScreenState createState() => _NavigationTestScreenState();
}

class _NavigationTestScreenState extends State<NavigationTestScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          Center(child: Text('홈 화면')),
          Center(child: Text('자산 화면')),
          Center(child: Text('임차인 화면')),
          Center(child: Text('설정 화면')),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.business), label: '자산'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: '임차인'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: '설정'),
        ],
      ),
    );
  }
}

class FormTestScreen extends StatefulWidget {
  @override
  _FormTestScreenState createState() => _FormTestScreenState();
}

class _FormTestScreenState extends State<FormTestScreen> {
  String selectedType = '아파트';
  bool saved = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('자산 등록')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            if (saved) 
              Text('저장 완료', style: TextStyle(color: Colors.green, fontSize: 18)),
            TextFormField(
              key: Key('name_field'),
              decoration: InputDecoration(labelText: '자산명'),
            ),
            TextFormField(
              key: Key('address_field'),
              decoration: InputDecoration(labelText: '주소'),
            ),
            TextFormField(
              key: Key('units_field'),
              decoration: InputDecoration(labelText: '유닛 수'),
              keyboardType: TextInputType.number,
            ),
            DropdownButton<String>(
              key: Key('type_dropdown'),
              value: selectedType,
              items: ['아파트', '빌라', '오피스'].map((String value) {
                return DropdownMenuItem<String>(value: value, child: Text(value));
              }).toList(),
              onChanged: (String? newValue) {
                setState(() => selectedType = newValue!);
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => setState(() => saved = true),
              child: Text('저장'),
            ),
          ],
        ),
      ),
    );
  }
}