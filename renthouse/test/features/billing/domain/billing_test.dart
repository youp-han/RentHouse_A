import 'package:flutter_test/flutter_test.dart';
import 'package:renthouse/features/billing/domain/billing.dart';
import 'package:renthouse/features/billing/domain/billing_item.dart';

void main() {
  group('Billing 도메인 모델 테스트', () {
    late Billing testBilling;
    late DateTime issueDate;
    late DateTime dueDate;
    late DateTime paidDate;

    setUp(() {
      issueDate = DateTime(2023, 3, 1);
      dueDate = DateTime(2023, 3, 31);
      paidDate = DateTime(2023, 3, 15);
      
      testBilling = Billing(
        id: 'billing1',
        leaseId: 'lease1',
        yearMonth: '2023-03',
        issueDate: issueDate,
        dueDate: dueDate,
        paid: true,
        paidDate: paidDate,
        totalAmount: 1200000,
        items: [],
      );
    });

    test('Billing 객체 생성이 정상적으로 동작해야 한다', () {
      expect(testBilling.id, 'billing1');
      expect(testBilling.leaseId, 'lease1');
      expect(testBilling.yearMonth, '2023-03');
      expect(testBilling.issueDate, issueDate);
      expect(testBilling.dueDate, dueDate);
      expect(testBilling.paid, isTrue);
      expect(testBilling.paidDate, paidDate);
      expect(testBilling.totalAmount, 1200000);
      expect(testBilling.items, isEmpty);
    });

    test('Billing 기본값이 올바르게 설정되어야 한다', () {
      final billingWithDefaults = Billing(
        id: 'billing2',
        leaseId: 'lease2',
        yearMonth: '2023-04',
        issueDate: issueDate,
        dueDate: dueDate,
        totalAmount: 1000000,
      );

      expect(billingWithDefaults.paid, isFalse);
      expect(billingWithDefaults.paidDate, isNull);
      expect(billingWithDefaults.items, isEmpty);
    });

    test('Billing JSON 직렬화/역직렬화가 올바르게 동작해야 한다', () {
      final json = testBilling.toJson();
      final fromJson = Billing.fromJson(json);

      expect(fromJson, testBilling);
      expect(fromJson.id, testBilling.id);
      expect(fromJson.leaseId, testBilling.leaseId);
      expect(fromJson.yearMonth, testBilling.yearMonth);
      expect(fromJson.paid, testBilling.paid);
    });

    test('Billing copyWith가 올바르게 동작해야 한다', () {
      final updatedBilling = testBilling.copyWith(
        paid: false,
        paidDate: null,
        totalAmount: 1500000,
      );

      expect(updatedBilling.paid, isFalse);
      expect(updatedBilling.paidDate, isNull);
      expect(updatedBilling.totalAmount, 1500000);
      expect(updatedBilling.id, testBilling.id);
      expect(updatedBilling.leaseId, testBilling.leaseId);
    });

    test('Billing items 리스트가 올바르게 처리되어야 한다', () {
      const item1 = BillingItem(
        id: 'item1',
        billingId: 'billing1',
        billTemplateId: 'template1',
        amount: 1000000,
      );

      const item2 = BillingItem(
        id: 'item2',
        billingId: 'billing1',
        billTemplateId: 'template2',
        amount: 200000,
      );

      final billingWithItems = testBilling.copyWith(
        items: [item1, item2],
        totalAmount: 1200000,
      );

      expect(billingWithItems.items.length, 2);
      expect(billingWithItems.items[0].billTemplateId, 'template1');
      expect(billingWithItems.items[1].billTemplateId, 'template2');
      
      final itemsTotal = billingWithItems.items
          .map((item) => item.amount)
          .reduce((a, b) => a + b);
      expect(itemsTotal, billingWithItems.totalAmount);
    });

    test('yearMonth 형식 테스트', () {
      final validYearMonths = [
        '2023-01',
        '2023-12',
        '2024-06',
      ];

      for (final yearMonth in validYearMonths) {
        final billing = Billing(
          id: 'billing_test',
          leaseId: 'lease1',
          yearMonth: yearMonth,
          issueDate: issueDate,
          dueDate: dueDate,
          totalAmount: 1000000,
        );
        
        expect(billing.yearMonth, yearMonth);
        expect(billing.yearMonth.length, 7); // 'YYYY-MM' 형식
        expect(billing.yearMonth.contains('-'), isTrue);
      }
    });

    test('미납 청구서 식별 테스트', () {
      final unpaidBilling = Billing(
        id: 'unpaid_billing',
        leaseId: 'lease1',
        yearMonth: '2023-03',
        issueDate: issueDate,
        dueDate: dueDate,
        paid: false,
        totalAmount: 1000000,
      );

      final paidBilling = Billing(
        id: 'paid_billing',
        leaseId: 'lease1',
        yearMonth: '2023-04',
        issueDate: issueDate,
        dueDate: dueDate,
        paid: true,
        paidDate: paidDate,
        totalAmount: 1000000,
      );

      expect(unpaidBilling.paid, isFalse);
      expect(unpaidBilling.paidDate, isNull);
      expect(paidBilling.paid, isTrue);
      expect(paidBilling.paidDate, isNotNull);
    });

    test('연체 여부 확인 테스트', () {
      final now = DateTime.now();
      final pastDueDate = now.subtract(const Duration(days: 30));
      final futureDueDate = now.add(const Duration(days: 30));

      final overdueBilling = Billing(
        id: 'overdue',
        leaseId: 'lease1',
        yearMonth: '2023-01',
        issueDate: pastDueDate.subtract(const Duration(days: 30)),
        dueDate: pastDueDate,
        paid: false,
        totalAmount: 1000000,
      );

      final currentBilling = Billing(
        id: 'current',
        leaseId: 'lease1',
        yearMonth: '2023-02',
        issueDate: now.subtract(const Duration(days: 5)),
        dueDate: futureDueDate,
        paid: false,
        totalAmount: 1000000,
      );

      // 연체 여부는 paid가 false이고 dueDate가 현재보다 이전인 경우
      final isOverdue = !overdueBilling.paid && 
                       overdueBilling.dueDate.isBefore(now);
      final isCurrent = !currentBilling.paid && 
                       currentBilling.dueDate.isAfter(now);

      expect(isOverdue, isTrue);
      expect(isCurrent, isTrue);
    });

    test('Billing equality가 올바르게 동작해야 한다', () {
      final billing1 = Billing(
        id: 'same_id',
        leaseId: 'lease1',
        yearMonth: '2023-03',
        issueDate: issueDate,
        dueDate: dueDate,
        totalAmount: 1000000,
      );

      final billing2 = Billing(
        id: 'same_id',
        leaseId: 'lease1',
        yearMonth: '2023-03',
        issueDate: issueDate,
        dueDate: dueDate,
        totalAmount: 1000000,
      );

      expect(billing1, billing2);
      expect(billing1.hashCode, billing2.hashCode);
    });

    test('결제일이 마감일보다 늦을 수 있는지 테스트', () {
      final latePaidBilling = Billing(
        id: 'late_paid',
        leaseId: 'lease1',
        yearMonth: '2023-03',
        issueDate: issueDate,
        dueDate: dueDate,
        paid: true,
        paidDate: dueDate.add(const Duration(days: 5)), // 마감일 이후 결제
        totalAmount: 1000000,
      );

      expect(latePaidBilling.paid, isTrue);
      expect(latePaidBilling.paidDate!.isAfter(latePaidBilling.dueDate), isTrue);
    });
  });
}