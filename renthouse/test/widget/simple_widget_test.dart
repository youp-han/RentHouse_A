import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  group('Simple Widget Tests', () {
    testWidgets('Material app should render properly', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              appBar: AppBar(title: Text('테스트')),
              body: Center(child: Text('테스트 앱')),
            ),
          ),
        ),
      );

      expect(find.text('테스트'), findsOneWidget);
      expect(find.text('테스트 앱'), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('Text fields should accept input', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: '이름'),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: '전화번호'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('저장'),
                ),
              ],
            ),
          ),
        ),
      );

      // Test text input
      await tester.enterText(find.byType(TextFormField).first, '김테스트');
      await tester.enterText(find.byType(TextFormField).last, '010-1234-5678');
      await tester.pump();

      expect(find.text('김테스트'), findsOneWidget);
      expect(find.text('010-1234-5678'), findsOneWidget);
      expect(find.text('저장'), findsOneWidget);
      
      // Test button tap
      await tester.tap(find.text('저장'));
      await tester.pump();
    });

    testWidgets('ListView should render items', (WidgetTester tester) async {
      final items = ['항목 1', '항목 2', '항목 3'];
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(items[index]),
                );
              },
            ),
          ),
        ),
      );

      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(ListTile), findsNWidgets(3));
      expect(find.text('항목 1'), findsOneWidget);
      expect(find.text('항목 2'), findsOneWidget);
      expect(find.text('항목 3'), findsOneWidget);
    });

    testWidgets('Card widgets should display properly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text('총 자산', style: TextStyle(fontSize: 16)),
                          Text('15개', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text('총 임차인', style: TextStyle(fontSize: 16)),
                          Text('28명', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byType(Card), findsNWidgets(2));
      expect(find.text('총 자산'), findsOneWidget);
      expect(find.text('15개'), findsOneWidget);
      expect(find.text('총 임차인'), findsOneWidget);
      expect(find.text('28명'), findsOneWidget);
    });

    testWidgets('FloatingActionButton should be tappable', (WidgetTester tester) async {
      bool buttonPressed = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(child: Text('메인 화면')),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                buttonPressed = true;
              },
              child: Icon(Icons.add),
            ),
          ),
        ),
      );

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
      
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();
      
      expect(buttonPressed, true);
    });

    testWidgets('Form validation should work', (WidgetTester tester) async {
      final formKey = GlobalKey<FormState>();
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: '필수 필드'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '필수 입력 항목입니다';
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      formKey.currentState?.validate();
                    },
                    child: Text('검증'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Trigger validation on empty field
      await tester.tap(find.text('검증'));
      await tester.pump();
      
      expect(find.text('필수 입력 항목입니다'), findsOneWidget);
      
      // Fill field and validate again
      await tester.enterText(find.byType(TextFormField), '입력된 값');
      await tester.tap(find.text('검증'));
      await tester.pump();
      
      expect(find.text('필수 입력 항목입니다'), findsNothing);
    });

    testWidgets('Dropdown should show options', (WidgetTester tester) async {
      String selectedValue = '옵션 1';
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return DropdownButton<String>(
                  value: selectedValue,
                  items: ['옵션 1', '옵션 2', '옵션 3']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedValue = newValue!;
                    });
                  },
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('옵션 1'), findsOneWidget);
      expect(find.byType(DropdownButton<String>), findsOneWidget);
      
      // Tap dropdown to open
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      
      // Should see all options
      expect(find.text('옵션 2'), findsOneWidget);
      expect(find.text('옵션 3'), findsOneWidget);
    });

    testWidgets('Checkbox should toggle state', (WidgetTester tester) async {
      bool isChecked = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return CheckboxListTile(
                  title: Text('체크박스 옵션'),
                  value: isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      isChecked = value ?? false;
                    });
                  },
                );
              },
            ),
          ),
        ),
      );

      expect(find.byType(CheckboxListTile), findsOneWidget);
      expect(find.text('체크박스 옵션'), findsOneWidget);
      
      // Initial state should be unchecked
      expect(isChecked, false);
      
      // Tap to check
      await tester.tap(find.byType(CheckboxListTile));
      await tester.pump();
      
      expect(isChecked, true);
    });
  });
}