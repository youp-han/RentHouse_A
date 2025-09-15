import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:renthouse/features/auth/presentation/login_screen.dart';

void main() {
  group('Login Screen Widget Tests', () {
    testWidgets('Login screen should render with basic layout', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      // Verify that login screen renders
      expect(find.byType(LoginScreen), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('Login screen should have username and password fields', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      await tester.pump();

      // Check for text form fields or text fields
      expect(find.byType(TextFormField), findsAtLeast(2));
      
      // Check for common field labels
      expect(
        find.text('사용자명').evaluate().isNotEmpty ||
        find.text('아이디').evaluate().isNotEmpty ||
        find.text('이메일').evaluate().isNotEmpty,
        true,
        reason: 'Should have username/email field'
      );
      
      expect(
        find.text('비밀번호').evaluate().isNotEmpty ||
        find.text('패스워드').evaluate().isNotEmpty,
        true,
        reason: 'Should have password field'
      );
    });

    testWidgets('Login screen should have login button', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      await tester.pump();

      // Look for login button
      expect(
        find.text('로그인').evaluate().isNotEmpty ||
        find.text('LOGIN').evaluate().isNotEmpty ||
        find.byType(ElevatedButton).evaluate().isNotEmpty,
        true,
        reason: 'Should have login button'
      );
    });

    testWidgets('Login button should be tappable', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      await tester.pump();

      // Find and tap login button
      final loginButton = find.text('로그인').first;
      if (loginButton.evaluate().isNotEmpty) {
        await tester.tap(loginButton);
        await tester.pump();
        // No exceptions should be thrown
      }
    });

    testWidgets('Login screen should handle text input', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      await tester.pump();

      // Find text fields and enter text
      final textFields = find.byType(TextFormField);
      if (textFields.evaluate().length >= 2) {
        await tester.enterText(textFields.first, 'testuser');
        await tester.enterText(textFields.at(1), 'testpass');
        await tester.pump();

        // Verify text was entered
        expect(find.text('testuser'), findsOneWidget);
        expect(find.text('testpass'), findsOneWidget);
      }
    });

    testWidgets('Login screen should show app branding or title', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      await tester.pump();

      // Look for app title or branding
      expect(
        find.text('RentHouse').evaluate().isNotEmpty ||
        find.text('임대관리').evaluate().isNotEmpty ||
        find.text('로그인').evaluate().isNotEmpty ||
        find.byType(Image).evaluate().isNotEmpty,
        true,
        reason: 'Should show app branding or title'
      );
    });

    testWidgets('Login screen should be responsive to keyboard', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      // Pump and settle to ensure layout is complete
      await tester.pumpAndSettle();

      // The screen should be scrollable or responsive to keyboard
      expect(
        find.byType(SingleChildScrollView).evaluate().isNotEmpty ||
        find.byType(ListView).evaluate().isNotEmpty,
        true,
        reason: 'Login screen should be scrollable for keyboard handling'
      );
    });
  });
}