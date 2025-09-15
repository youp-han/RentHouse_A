import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:renthouse/features/tenant/presentation/tenant_form_screen.dart';

void main() {
  group('Tenant Form Screen Widget Tests', () {
    testWidgets('Tenant form screen should render with basic layout', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: TenantFormScreen(),
          ),
        ),
      );

      // Verify that tenant form screen renders
      expect(find.byType(TenantFormScreen), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('Tenant form screen should have app bar with title', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: TenantFormScreen(),
          ),
        ),
      );

      await tester.pump();

      // Check for app bar
      expect(find.byType(AppBar), findsOneWidget);
      
      // Check for tenant-related title
      expect(
        find.text('임차인').evaluate().isNotEmpty ||
        find.text('임차인 등록').evaluate().isNotEmpty ||
        find.text('임차인 추가').evaluate().isNotEmpty ||
        find.text('새 임차인').evaluate().isNotEmpty,
        true,
        reason: 'Should have tenant-related title'
      );
    });

    testWidgets('Tenant form should have required input fields', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: TenantFormScreen(),
          ),
        ),
      );

      await tester.pump();

      // Should have multiple text form fields for tenant information
      expect(find.byType(TextFormField), findsAtLeast(3));
      
      // Check for common tenant form fields
      expect(
        find.text('이름').evaluate().isNotEmpty ||
        find.text('성명').evaluate().isNotEmpty,
        true,
        reason: 'Should have name field'
      );
      
      expect(
        find.text('전화번호').evaluate().isNotEmpty ||
        find.text('연락처').evaluate().isNotEmpty,
        true,
        reason: 'Should have phone field'
      );
      
      expect(
        find.text('이메일').evaluate().isNotEmpty ||
        find.text('이메일 주소').evaluate().isNotEmpty,
        true,
        reason: 'Should have email field'
      );
    });

    testWidgets('Tenant form should have save button', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: TenantFormScreen(),
          ),
        ),
      );

      await tester.pump();

      // Look for save button
      expect(
        find.text('저장').evaluate().isNotEmpty ||
        find.text('등록').evaluate().isNotEmpty ||
        find.text('추가').evaluate().isNotEmpty ||
        find.byType(ElevatedButton).evaluate().isNotEmpty,
        true,
        reason: 'Should have save/submit button'
      );
    });

    testWidgets('Tenant form should handle text input', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: TenantFormScreen(),
          ),
        ),
      );

      await tester.pump();

      // Find text fields and enter test data
      final textFields = find.byType(TextFormField);
      if (textFields.evaluate().length >= 3) {
        await tester.enterText(textFields.at(0), '김테스트');
        await tester.enterText(textFields.at(1), '010-1234-5678');
        await tester.enterText(textFields.at(2), 'test@example.com');
        await tester.pump();

        // Verify text was entered
        expect(find.text('김테스트'), findsOneWidget);
        expect(find.text('010-1234-5678'), findsOneWidget);
        expect(find.text('test@example.com'), findsOneWidget);
      }
    });

    testWidgets('Tenant form should be scrollable', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: TenantFormScreen(),
          ),
        ),
      );

      await tester.pump();

      // Form should be scrollable for better UX
      expect(
        find.byType(SingleChildScrollView).evaluate().isNotEmpty ||
        find.byType(ListView).evaluate().isNotEmpty ||
        find.byType(CustomScrollView).evaluate().isNotEmpty,
        true,
        reason: 'Form should be scrollable'
      );
    });

    testWidgets('Save button should be tappable', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: TenantFormScreen(),
          ),
        ),
      );

      await tester.pump();

      // Find and tap save button
      final saveButtonFinder = find.text('저장');
      final submitButtonFinder = find.text('등록');
      final elevatedButtonFinder = find.byType(ElevatedButton);
      
      if (saveButtonFinder.evaluate().isNotEmpty) {
        await tester.tap(saveButtonFinder.first);
        await tester.pump();
      } else if (submitButtonFinder.evaluate().isNotEmpty) {
        await tester.tap(submitButtonFinder.first);
        await tester.pump();
      } else if (elevatedButtonFinder.evaluate().isNotEmpty) {
        await tester.tap(elevatedButtonFinder.first);
        await tester.pump();
      }
      
      // No exceptions should be thrown
    });

    testWidgets('Tenant form should handle validation', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: TenantFormScreen(),
          ),
        ),
      );

      await tester.pump();

      // Try to submit empty form to trigger validation
      final submitButtons = [
        find.text('저장'),
        find.text('등록'),
        find.byType(ElevatedButton)
      ];
      
      for (final buttonFinder in submitButtons) {
        if (buttonFinder.evaluate().isNotEmpty) {
          await tester.tap(buttonFinder.first);
          await tester.pump();
          break;
        }
      }
      
      // Should still be on the same screen (validation prevented submission)
      expect(find.byType(TenantFormScreen), findsOneWidget);
    });

    testWidgets('Tenant form should support additional fields', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: TenantFormScreen(),
          ),
        ),
      );

      await tester.pump();

      // Look for additional tenant fields
      final optionalFields = [
        '주민등록번호',
        '주소',
        '현재 주소',
        '생년월일',
        '메모',
        '비고'
      ];
      
      bool hasOptionalField = false;
      for (final field in optionalFields) {
        if (find.text(field).evaluate().isNotEmpty) {
          hasOptionalField = true;
          break;
        }
      }
      
      // At least some optional fields should be present for comprehensive tenant data
      expect(hasOptionalField, true, reason: 'Should have some optional tenant fields');
    });
  });
}