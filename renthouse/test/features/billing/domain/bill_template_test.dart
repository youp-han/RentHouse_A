import 'package:flutter_test/flutter_test.dart';
import 'package:renthouse/features/billing/domain/bill_template.dart';

void main() {
  group('BillTemplate 도메인 모델 테스트', () {
    late BillTemplate testBillTemplate;

    setUp(() {
      testBillTemplate = const BillTemplate(
        id: 'template1',
        name: '월세',
        category: '임대료',
        amount: 1000000,
        description: '매월 정기 임대료',
      );
    });

    test('BillTemplate 객체 생성이 정상적으로 동작해야 한다', () {
      expect(testBillTemplate.id, 'template1');
      expect(testBillTemplate.name, '월세');
      expect(testBillTemplate.category, '임대료');
      expect(testBillTemplate.amount, 1000000);
      expect(testBillTemplate.description, '매월 정기 임대료');
    });

    test('BillTemplate description은 nullable이어야 한다', () {
      const templateWithoutDescription = BillTemplate(
        id: 'template2',
        name: '관리비',
        category: '부대비용',
        amount: 200000,
      );

      expect(templateWithoutDescription.description, isNull);
    });

    test('BillTemplate JSON 직렬화/역직렬화가 올바르게 동작해야 한다', () {
      final json = testBillTemplate.toJson();
      final fromJson = BillTemplate.fromJson(json);

      expect(fromJson, testBillTemplate);
      expect(fromJson.id, testBillTemplate.id);
      expect(fromJson.name, testBillTemplate.name);
      expect(fromJson.category, testBillTemplate.category);
      expect(fromJson.amount, testBillTemplate.amount);
    });

    test('BillTemplate copyWith가 올바르게 동작해야 한다', () {
      final updatedTemplate = testBillTemplate.copyWith(
        name: '수정된 월세',
        amount: 1200000,
        description: '인상된 임대료',
      );

      expect(updatedTemplate.name, '수정된 월세');
      expect(updatedTemplate.amount, 1200000);
      expect(updatedTemplate.description, '인상된 임대료');
      expect(updatedTemplate.id, testBillTemplate.id);
      expect(updatedTemplate.category, testBillTemplate.category);
    });

    test('다양한 카테고리의 템플릿을 만들 수 있어야 한다', () {
      const rentTemplate = BillTemplate(
        id: 'rent',
        name: '월세',
        category: '임대료',
        amount: 1000000,
      );

      const maintenanceTemplate = BillTemplate(
        id: 'maintenance',
        name: '관리비',
        category: '부대비용',
        amount: 150000,
      );

      const parkingTemplate = BillTemplate(
        id: 'parking',
        name: '주차비',
        category: '부대비용',
        amount: 50000,
      );

      const utilityTemplate = BillTemplate(
        id: 'utility',
        name: '수도세',
        category: '공과금',
        amount: 30000,
      );

      expect(rentTemplate.category, '임대료');
      expect(maintenanceTemplate.category, '부대비용');
      expect(parkingTemplate.category, '부대비용');
      expect(utilityTemplate.category, '공과금');
    });

    test('템플릿 이름이 다양할 수 있어야 한다', () {
      final templates = [
        const BillTemplate(
          id: 'rent',
          name: '월세',
          category: '임대료',
          amount: 1000000,
        ),
        const BillTemplate(
          id: 'maintenance',
          name: '관리비',
          category: '부대비용',
          amount: 150000,
        ),
        const BillTemplate(
          id: 'cleaning',
          name: '청소비',
          category: '부대비용',
          amount: 20000,
        ),
        const BillTemplate(
          id: 'internet',
          name: '인터넷',
          category: '통신비',
          amount: 30000,
        ),
      ];

      final names = templates.map((t) => t.name).toList();
      expect(names, ['월세', '관리비', '청소비', '인터넷']);
    });

    test('기본 금액이 0일 수 있어야 한다', () {
      const freeTemplate = BillTemplate(
        id: 'free',
        name: '무료 서비스',
        category: '혜택',
        amount: 0,
      );

      expect(freeTemplate.amount, 0);
    });

    test('큰 금액도 처리할 수 있어야 한다', () {
      const premiumTemplate = BillTemplate(
        id: 'premium',
        name: '프리미엄 월세',
        category: '임대료',
        amount: 10000000, // 1천만원
      );

      expect(premiumTemplate.amount, 10000000);
    });

    test('BillTemplate equality가 올바르게 동작해야 한다', () {
      const template1 = BillTemplate(
        id: 'same_id',
        name: '월세',
        category: '임대료',
        amount: 1000000,
      );

      const template2 = BillTemplate(
        id: 'same_id',
        name: '월세',
        category: '임대료',
        amount: 1000000,
      );

      expect(template1, template2);
      expect(template1.hashCode, template2.hashCode);
    });

    test('템플릿 설명이 상세할 수 있어야 한다', () {
      const detailedTemplate = BillTemplate(
        id: 'detailed',
        name: '종합 관리비',
        category: '부대비용',
        amount: 250000,
        description: '청소비, 경비비, 공동전기료, 승강기 유지비, 소독비 등을 포함한 종합 관리비용입니다.',
      );

      expect(detailedTemplate.description, isNotNull);
      expect(detailedTemplate.description!.length, greaterThan(10));
      expect(detailedTemplate.description!.contains('관리비용'), isTrue);
    });

    test('카테고리별로 템플릿을 그룹화할 수 있어야 한다', () {
      final templates = [
        const BillTemplate(id: '1', name: '월세', category: '임대료', amount: 1000000),
        const BillTemplate(id: '2', name: '전세', category: '임대료', amount: 50000000),
        const BillTemplate(id: '3', name: '관리비', category: '부대비용', amount: 150000),
        const BillTemplate(id: '4', name: '주차비', category: '부대비용', amount: 50000),
        const BillTemplate(id: '5', name: '수도세', category: '공과금', amount: 30000),
        const BillTemplate(id: '6', name: '전기세', category: '공과금', amount: 50000),
      ];

      final groupedByCategory = <String, List<BillTemplate>>{};
      for (final template in templates) {
        groupedByCategory.putIfAbsent(template.category, () => []).add(template);
      }

      expect(groupedByCategory['임대료']?.length, 2);
      expect(groupedByCategory['부대비용']?.length, 2);
      expect(groupedByCategory['공과금']?.length, 2);
    });
  });
}