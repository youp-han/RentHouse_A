import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:renthouse/core/database/app_database.dart' as app_db;
import 'package:renthouse/core/database/database_provider.dart';
import 'package:renthouse/features/billing/domain/bill_template.dart';
import 'package:renthouse/features/billing/domain/billing.dart';
import 'package:renthouse/features/billing/domain/billing_item.dart';
import 'package:drift/drift.dart';

class BillingRepository {
  final app_db.AppDatabase _appDatabase;

  BillingRepository(this._appDatabase);

  // BillTemplate CRUD
  Future<List<BillTemplate>> getBillTemplates() async {
    final appDbBillTemplates = await _appDatabase.getAllBillTemplates();
    return appDbBillTemplates.map((appDbTemplate) => BillTemplate(
      id: appDbTemplate.id,
      name: appDbTemplate.name,
      category: appDbTemplate.category,
      amount: appDbTemplate.amount,
      description: appDbTemplate.description,
    )).toList();
  }
  Future<void> createBillTemplate(BillTemplate template) => _appDatabase.insertBillTemplate(app_db.BillTemplatesCompanion.insert(
        id: template.id,
        name: template.name,
        category: template.category,
        amount: template.amount,
        description: Value(template.description),
      ));
  Future<void> updateBillTemplate(BillTemplate template) => _appDatabase.updateBillTemplate(app_db.BillTemplatesCompanion(
        id: Value(template.id),
        name: Value(template.name),
        category: Value(template.category),
        amount: Value(template.amount),
        description: Value(template.description),
      ));
  Future<void> deleteBillTemplate(String id) => _appDatabase.deleteBillTemplate(id);

  // Billing Aggregate CRUD
  Future<List<Billing>> getBillings({String? searchQuery}) async {
    final billings = await _appDatabase.getAllBillings();
    final mappedBillings = await Future.wait(billings.map((billing) async {
      final items = await _appDatabase.getBillingItemsForBilling(billing.id);
      return Billing(
        id: billing.id,
        leaseId: billing.leaseId,
        yearMonth: billing.yearMonth,
        issueDate: billing.issueDate,
        dueDate: billing.dueDate,
        paid: billing.paid,
        paidDate: billing.paidDate,
        totalAmount: billing.totalAmount,
        items: items.map((item) => BillingItem(
          id: item.id,
          billingId: item.billingId,
          billTemplateId: item.billTemplateId ?? '',
          amount: item.amount,
          itemName: item.itemName, // 저장된 템플릿 이름 포함
          quantity: item.quantity,
          unitPrice: item.unitPrice,
          tax: item.tax,
          memo: item.memo,
        )).toList(),
      );
    }).toList());

    if (searchQuery != null && searchQuery.isNotEmpty) {
      final lowerCaseQuery = searchQuery.toLowerCase();
      return mappedBillings.where((billing) {
        return billing.leaseId.toLowerCase().contains(lowerCaseQuery) ||
               billing.yearMonth.toLowerCase().contains(lowerCaseQuery);
      }).toList();
    }

    return mappedBillings;
  }

  Future<Billing> createBilling(Billing billing) async {
    await _appDatabase.insertBilling(app_db.BillingsCompanion.insert(
      id: billing.id,
      leaseId: billing.leaseId,
      yearMonth: billing.yearMonth,
      issueDate: billing.issueDate,
      dueDate: billing.dueDate,
      paid: Value(billing.paid),
      paidDate: Value(billing.paidDate),
      totalAmount: billing.totalAmount,
    ));
    for (var item in billing.items) {
      await _appDatabase.insertBillingItem(app_db.BillingItemsCompanion.insert(
        id: item.id,
        billingId: item.billingId,
        billTemplateId: Value(item.billTemplateId),
        amount: item.amount,
        itemName: Value(item.itemName), // 템플릿 이름 저장
        quantity: Value(item.quantity),
        unitPrice: Value(item.unitPrice),
        tax: Value(item.tax),
        memo: Value(item.memo),
      ));
    }
    return billing;
  }

  Future<Billing> updateBilling(Billing billing) async {
    await _appDatabase.updateBilling(app_db.BillingsCompanion(
      id: Value(billing.id),
      leaseId: Value(billing.leaseId),
      yearMonth: Value(billing.yearMonth),
      issueDate: Value(billing.issueDate),
      dueDate: Value(billing.dueDate),
      paid: Value(billing.paid),
      paidDate: Value(billing.paidDate),
      totalAmount: Value(billing.totalAmount),
    ));

    await _appDatabase.deleteBillingItemsForBilling(billing.id);
    for (var item in billing.items) {
      await _appDatabase.insertBillingItem(app_db.BillingItemsCompanion.insert(
        id: item.id,
        billingId: item.billingId,
        billTemplateId: Value(item.billTemplateId),
        amount: item.amount,
        itemName: Value(item.itemName), // 템플릿 이름 저장
        quantity: Value(item.quantity),
        unitPrice: Value(item.unitPrice),
        tax: Value(item.tax),
        memo: Value(item.memo),
      ));
    }
    return billing;
  }

  Future<void> deleteBilling(String id) async {
    // 먼저 관련된 청구 항목들을 삭제
    await _appDatabase.deleteBillingItemsForBilling(id);
    // 그 다음 청구서를 삭제
    await _appDatabase.deleteBilling(id);
  }

  // 특정 월의 청구서가 이미 존재하는지 확인
  Future<bool> billingExistsForLeaseAndMonth(String leaseId, String yearMonth) async {
    return await _appDatabase.hasExistingBilling(leaseId, yearMonth);
  }

  Future<Billing?> getBillingById(String id) async {
    final billing = await _appDatabase.getBillingById(id);
    if (billing == null) return null;
    
    final items = await _appDatabase.getBillingItemsForBilling(billing.id);
    return Billing(
      id: billing.id,
      leaseId: billing.leaseId,
      yearMonth: billing.yearMonth,
      issueDate: billing.issueDate,
      dueDate: billing.dueDate,
      paid: billing.paid,
      paidDate: billing.paidDate,
      totalAmount: billing.totalAmount,
      items: items.map((item) => BillingItem(
        id: item.id,
        billingId: item.billingId,
        billTemplateId: item.billTemplateId ?? '',
        amount: item.amount,
        itemName: item.itemName,
        quantity: item.quantity,
        unitPrice: item.unitPrice,
        tax: item.tax,
        memo: item.memo,
      )).toList(),
    );
  }

  // 활성 계약에 대한 일괄 청구서 생성
  Future<List<String>> createBulkBillings(String yearMonth, DateTime issueDate, DateTime dueDate) async {
    print('[BillingRepository] createBulkBillings 시작: $yearMonth');

    // 기본 월세 템플릿이 없으면 생성
    await _ensureMonthlyRentTemplate();

    // 현재 존재하는 모든 템플릿 출력 (디버깅)
    final allTemplates = await _appDatabase.getAllBillTemplates();
    print('[BillingRepository] 현재 템플릿 목록:');
    for (final template in allTemplates) {
      print('  - ID: ${template.id}, Name: ${template.name}');
    }

    final activeLeases = await _appDatabase.getActiveLeases();
    print('[BillingRepository] 활성 계약 수: ${activeLeases.length}');

    final createdBillingIds = <String>[];

    for (final lease in activeLeases) {
      print('[BillingRepository] 계약 처리 중: ${lease.id}');
      // 중복 생성 방지: 이미 해당 월의 청구서가 있는지 확인
      final exists = await billingExistsForLeaseAndMonth(lease.id, yearMonth);
      if (!exists) {
        print('[BillingRepository] 계약 ${lease.id}에 대해 새 청구서 생성');
        // 청구서 생성 (ID 길이 제한 고려)
        final now = DateTime.now().millisecondsSinceEpoch;
        final billingId = 'b${now.toString().substring(now.toString().length - 8)}';
        print('[BillingRepository] 생성된 청구서 ID: $billingId');

        // 기본 청구 항목들 (월세, 관리비 등)
        final billingItems = <BillingItem>[];
        var totalAmount = 0;
        
        // 월세 추가
        if (lease.monthlyRent > 0) {
          final now = DateTime.now().millisecondsSinceEpoch;
          final rentItemId = 'r${now.toString().substring(now.toString().length - 8)}';

          // Foreign Key 제약조건 제거로 인해 템플릿 ID는 이제 optional
          var templateId = 'tmpl_monthly_rent';

          billingItems.add(BillingItem(
            id: rentItemId,
            billingId: billingId,
            billTemplateId: templateId,
            amount: lease.monthlyRent,
            itemName: '월세',
          ));
          totalAmount += lease.monthlyRent;
        }
        
        // 자산별 청구 항목들 가져오기 (virtual unit인 경우 건너뛰되 청구서는 생성)
        try {
          final unit = await _appDatabase.getUnitById(lease.unitId);
          final propertyBillingItems = await _appDatabase.getPropertyBillingItems(unit.propertyId);
          var itemCounter = 0;
          for (final propertyItem in propertyBillingItems.where((item) => item.isEnabled)) {
            final now = DateTime.now().millisecondsSinceEpoch;
            final itemId = 'p${now.toString().substring(now.toString().length - 7)}${itemCounter++}';
            billingItems.add(BillingItem(
              id: itemId,
              billingId: billingId,
              billTemplateId: propertyItem.id,
              amount: propertyItem.amount,
              itemName: propertyItem.name,
            ));
            totalAmount += propertyItem.amount;
          }
        } catch (e) {
          // 유닛을 찾을 수 없는 경우 (virtual unit 등) property billing items는 건너뛰지만 청구서는 생성
          print('[BillingRepository] 유닛 ${lease.unitId}를 찾을 수 없음: $e');
        }
        
        // 청구서 생성
        final billing = Billing(
          id: billingId,
          leaseId: lease.id,
          yearMonth: yearMonth,
          issueDate: issueDate,
          dueDate: dueDate,
          paid: false,
          paidDate: null,
          totalAmount: totalAmount,
          items: billingItems,
        );
        
        await createBilling(billing);
        createdBillingIds.add(billingId);
      }
    }

    return createdBillingIds;
  }

  // 기본 월세 템플릿 생성 보장
  Future<void> _ensureMonthlyRentTemplate() async {
    try {
      // 템플릿 목록 조회로 존재 여부 확인
      final templates = await _appDatabase.getAllBillTemplates();
      final exists = templates.any((t) => t.id == 'tmpl_monthly_rent');

      if (exists) {
        print('[BillingRepository] 월세 템플릿이 이미 존재함');
        return;
      }

      // 존재하지 않으면 생성
      print('[BillingRepository] 월세 템플릿 생성 중...');
      await _appDatabase.insertBillTemplate(
        app_db.BillTemplatesCompanion.insert(
          id: 'tmpl_monthly_rent',
          name: '월세',
          category: '주택비',
          amount: 0, // 기본값
          description: const Value('월 임대료'),
        ),
      );
      print('[BillingRepository] 월세 템플릿 생성 완료');

      // 생성 후 재확인
      final templatesAfter = await _appDatabase.getAllBillTemplates();
      final existsAfter = templatesAfter.any((t) => t.id == 'tmpl_monthly_rent');
      print('[BillingRepository] 생성 후 확인: $existsAfter');

    } catch (e) {
      print('[BillingRepository] 템플릿 생성 중 오류: $e');
      rethrow;
    }
  }
}

final billingRepositoryProvider = Provider<BillingRepository>((ref) {
  final appDatabase = ref.watch(appDatabaseProvider);
  return BillingRepository(appDatabase);
});
