import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:renthouse/features/dashboard/presentation/dashboard_screen.dart';

void main() {
  group('Dashboard Screen Widget Tests', () {
    testWidgets('Dashboard screen should render with basic layout', (WidgetTester tester) async {
      // Build the widget inside a ProviderScope for Riverpod
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: DashboardScreen(),
          ),
        ),
      );

      // Verify that dashboard screen renders
      expect(find.byType(DashboardScreen), findsOneWidget);
      
      // Dashboard should have a scaffold
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('Dashboard screen should show app bar with title', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: DashboardScreen(),
          ),
        ),
      );

      // Check for app bar
      expect(find.byType(AppBar), findsOneWidget);
      
      // Check for title or dashboard-related text
      expect(find.text('대시보드'), findsOneWidget);
    });

    testWidgets('Dashboard screen should display metric cards', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: DashboardScreen(),
          ),
        ),
      );

      // Wait for widgets to build
      await tester.pump();

      // Look for cards or containers that would display metrics
      expect(find.byType(Card), findsAtLeast(1));
    });

    testWidgets('Dashboard screen should have navigation elements', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: DashboardScreen(),
          ),
        ),
      );

      await tester.pump();

      // Check for common navigation elements
      // Either bottom navigation or drawer
      final bottomNavFinder = find.byType(BottomNavigationBar);
      final drawerFinder = find.byType(Drawer);
      
      expect(
        bottomNavFinder.evaluate().isNotEmpty || drawerFinder.evaluate().isNotEmpty,
        true,
        reason: 'Dashboard should have either bottom navigation or drawer'
      );
    });

    testWidgets('Dashboard screen should be scrollable if content overflows', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: DashboardScreen(),
          ),
        ),
      );

      await tester.pump();

      // Look for scrollable widgets
      expect(
        find.byType(SingleChildScrollView).evaluate().isNotEmpty ||
        find.byType(ListView).evaluate().isNotEmpty ||
        find.byType(CustomScrollView).evaluate().isNotEmpty,
        true,
        reason: 'Dashboard should be scrollable for better UX'
      );
    });
  });
}