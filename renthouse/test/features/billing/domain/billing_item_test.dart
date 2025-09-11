import 'package:flutter_test/flutter_test.dart';
import 'package:renthouse/features/billing/domain/billing_item.dart';

void main() {
  group('BillingItem 도메인 모델 테스트', () {
    late BillingItem testBillingItem;

    setUp(() {
      testBillingItem = const BillingItem(
        id: 'item1',
        billingId: 'billing1',
        billTemplateId: 'template1',
        amount: 1000000,
      );
    });

    test('BillingItem 객체 생성이 정상적으로 동작해야 한다', () {
      expect(testBillingItem.id, 'item1');
      expect(testBillingItem.billingId, 'billing1');
      expect(testBillingItem.billTemplateId, 'template1');
      expect(testBillingItem.amount, 1000000);
    });

    test('BillingItem JSON 직렬화/역직렬화가 올바르게 동작해야 한다', () {
      final json = testBillingItem.toJson();
      final fromJson = BillingItem.fromJson(json);

      expect(fromJson, testBillingItem);
      expect(fromJson.id, testBillingItem.id);
      expect(fromJson.billingId, testBillingItem.billingId);
      expect(fromJson.billTemplateId, testBillingItem.billTemplateId);
      expect(fromJson.amount, testBillingItem.amount);
    });

    test('BillingItem copyWith가 올바르게 동작해야 한다', () {
      final updatedItem = testBillingItem.copyWith(
        amount: 1200000,
        billTemplateId: 'template2',
      );

      expect(updatedItem.amount, 1200000);
      expect(updatedItem.billTemplateId, 'template2');
      expect(updatedItem.id, testBillingItem.id);
      expect(updatedItem.billingId, testBillingItem.billingId);
    });

    test('다양한 금액을 가질 수 있어야 한다', () {
      final rentItem = BillingItem(
        id: 'rent_item',
        billingId: 'billing1',
        billTemplateId: 'rent_template',
        amount: 1500000, // 월세
      );

      final maintenanceItem = BillingItem(
        id: 'maintenance_item',
        billingId: 'billing1',
        billTemplateId: 'maintenance_template',
        amount: 200000, // 관리비
      );

      final parkingItem = BillingItem(
        id: 'parking_item',
        billingId: 'billing1',
        billTemplateId: 'parking_template',
        amount: 50000, // 주차비
      );

      expect(rentItem.amount, 1500000);
      expect(maintenanceItem.amount, 200000);
      expect(parkingItem.amount, 50000);
    });

    test('BillingItem들의 총합 계산 테스트', () {
      final items = [
        const BillingItem(
          id: 'item1',
          billingId: 'billing1',
          billTemplateId: 'template1',
          amount: 1000000,
        ),
        const BillingItem(
          id: 'item2',
          billingId: 'billing1',
          billTemplateId: 'template2',
          amount: 200000,
        ),
        const BillingItem(
          id: 'item3',
          billingId: 'billing1',
          billTemplateId: 'template3',
          amount: 50000,
        ),
      ];

      final total = items.map((item) => item.amount).reduce((a, b) => a + b);
      expect(total, 1250000);
    });

    test('같은 billing에 속한 여러 항목들 테스트', () {
      const billingId = 'billing_multiple_items';
      
      final items = [
        const BillingItem(
          id: 'item1',
          billingId: billingId,
          billTemplateId: 'rent_template',
          amount: 1000000,
        ),
        const BillingItem(
          id: 'item2',
          billingId: billingId,
          billTemplateId: 'maintenance_template',
          amount: 150000,
        ),
        const BillingItem(
          id: 'item3',
          billingId: billingId,
          billTemplateId: 'parking_template',
          amount: 50000,
        ),
      ];

      for (final item in items) {
        expect(item.billingId, billingId);
      }

      expect(items.length, 3);
    });

    test('BillingItem equality가 올바르게 동작해야 한다', () {
      const item1 = BillingItem(
        id: 'same_id',
        billingId: 'billing1',
        billTemplateId: 'template1',
        amount: 1000000,
      );

      const item2 = BillingItem(
        id: 'same_id',
        billingId: 'billing1',
        billTemplateId: 'template1',
        amount: 1000000,
      );

      expect(item1, item2);
      expect(item1.hashCode, item2.hashCode);
    });

    test('금액이 0인 경우도 유효해야 한다', () {
      const zeroAmountItem = BillingItem(
        id: 'zero_item',
        billingId: 'billing1',
        billTemplateId: 'free_template',
        amount: 0,
      );

      expect(zeroAmountItem.amount, 0);
    });

    test('음수 금액도 허용되어야 한다 (할인, 환불 등)', () {
      const discountItem = BillingItem(
        id: 'discount_item',
        billingId: 'billing1',
        billTemplateId: 'discount_template',
        amount: -50000, // 할인
      );

      expect(discountItem.amount, -50000);
      expect(discountItem.amount < 0, isTrue);
    });

    test('큰 금액도 처리할 수 있어야 한다', () {
      const largeAmountItem = BillingItem(
        id: 'large_item',
        billingId: 'billing1',
        billTemplateId: 'premium_template',
        amount: 100000000, // 1억
      );

      expect(largeAmountItem.amount, 100000000);
    });
  });
}