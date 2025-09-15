import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:renthouse/features/property/presentation/property_list_screen.dart';

void main() {
  group('Property List Screen Widget Tests', () {
    testWidgets('Property list screen should render with basic layout', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: PropertyListScreen(),
          ),
        ),
      );

      // Verify that property list screen renders
      expect(find.byType(PropertyListScreen), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('Property list screen should have app bar with title', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: PropertyListScreen(),
          ),
        ),
      );

      await tester.pump();

      // Check for app bar
      expect(find.byType(AppBar), findsOneWidget);
      
      // Check for property-related title
      expect(
        find.text('자산').evaluate().isNotEmpty ||
        find.text('부동산').evaluate().isNotEmpty ||
        find.text('자산 목록').evaluate().isNotEmpty ||
        find.text('부동산 목록').evaluate().isNotEmpty,
        true,
        reason: 'Should have property-related title'
      );
    });

    testWidgets('Property list screen should have add button or FAB', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: PropertyListScreen(),
          ),
        ),
      );

      await tester.pump();

      // Look for floating action button or add button
      expect(
        find.byType(FloatingActionButton).evaluate().isNotEmpty ||
        find.byIcon(Icons.add).evaluate().isNotEmpty ||
        find.text('추가').evaluate().isNotEmpty,
        true,
        reason: 'Should have add button for new properties'
      );
    });

    testWidgets('Property list screen should display list view or grid', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: PropertyListScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check for list view or grid view
      expect(
        find.byType(ListView).evaluate().isNotEmpty ||
        find.byType(GridView).evaluate().isNotEmpty ||
        find.byType(CustomScrollView).evaluate().isNotEmpty,
        true,
        reason: 'Should have list or grid view for properties'
      );
    });

    testWidgets('Property list screen should handle empty state', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: PropertyListScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should either show properties or empty state message
      expect(
        find.text('자산이 없습니다').evaluate().isNotEmpty ||
        find.text('등록된 자산이 없습니다').evaluate().isNotEmpty ||
        find.text('자산을 추가하세요').evaluate().isNotEmpty ||
        find.byType(Card).evaluate().isNotEmpty ||
        find.byType(ListTile).evaluate().isNotEmpty,
        true,
        reason: 'Should show either properties or empty state'
      );
    });

    testWidgets('Property list screen should show loading indicator initially', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: PropertyListScreen(),
          ),
        ),
      );

      // Check for loading indicator before pumping
      expect(
        find.byType(CircularProgressIndicator).evaluate().isNotEmpty ||
        find.byType(LinearProgressIndicator).evaluate().isNotEmpty,
        true,
        reason: 'Should show loading indicator while fetching data'
      );
    });

    testWidgets('Add button should be tappable', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: PropertyListScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find and tap add button if present
      final fabFinder = find.byType(FloatingActionButton);
      final addIconFinder = find.byIcon(Icons.add);
      
      if (fabFinder.evaluate().isNotEmpty) {
        await tester.tap(fabFinder.first);
        await tester.pump();
      } else if (addIconFinder.evaluate().isNotEmpty) {
        await tester.tap(addIconFinder.first);
        await tester.pump();
      }
      
      // No exceptions should be thrown
    });

    testWidgets('Property list should be scrollable', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: PropertyListScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check for scrollable widgets
      expect(
        find.byType(ListView).evaluate().isNotEmpty ||
        find.byType(GridView).evaluate().isNotEmpty ||
        find.byType(CustomScrollView).evaluate().isNotEmpty ||
        find.byType(SingleChildScrollView).evaluate().isNotEmpty,
        true,
        reason: 'Property list should be scrollable'
      );
    });
  });
}