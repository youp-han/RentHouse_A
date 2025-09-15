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
          billTemplateId: item.billTemplateId,
          amount: item.amount,
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
        billTemplateId: item.billTemplateId,
        amount: item.amount,
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
        billTemplateId: item.billTemplateId,
        amount: item.amount,
      ));
    }
    return billing;
  }

  Future<void> deleteBilling(String id) => _appDatabase.deleteBilling(id);

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
        billTemplateId: item.billTemplateId,
        amount: item.amount,
      )).toList(),
    );
  }

  // 활성 계약에 대한 일괄 청구서 생성
  Future<List<String>> createBulkBillings(String yearMonth, DateTime issueDate, DateTime dueDate) async {
    final activeLeases = await _appDatabase.getActiveLeases();
    
    final createdBillingIds = <String>[];
    
    for (final lease in activeLeases) {
      // 중복 생성 방지: 이미 해당 월의 청구서가 있는지 확인
      final exists = await billingExistsForLeaseAndMonth(lease.id, yearMonth);
      if (!exists) {
        // 청구서 생성
        final billingId = 'billing_${DateTime.now().millisecondsSinceEpoch}_${lease.id}';
        
        // 기본 청구 항목들 (월세, 관리비 등)
        final billingItems = <BillingItem>[];
        var totalAmount = 0;
        
        // 월세 추가
        if (lease.monthlyRent > 0) {
          final rentItemId = 'item_${DateTime.now().millisecondsSinceEpoch}_rent';
          billingItems.add(BillingItem(
            id: rentItemId,
            billingId: billingId,
            billTemplateId: 'monthly_rent',
            amount: lease.monthlyRent,
          ));
          totalAmount += lease.monthlyRent;
        }
        
        // 자산별 청구 항목들 가져오기
        try {
          final unit = await _appDatabase.getUnitById(lease.unitId);
          final propertyBillingItems = await _appDatabase.getPropertyBillingItems(unit.propertyId);
          for (final propertyItem in propertyBillingItems.where((item) => item.isEnabled)) {
            final itemId = 'item_${DateTime.now().millisecondsSinceEpoch}_${propertyItem.id}';
            billingItems.add(BillingItem(
              id: itemId,
              billingId: billingId,
              billTemplateId: propertyItem.id,
              amount: propertyItem.amount,
            ));
            totalAmount += propertyItem.amount;
          }
        } catch (e) {
          // 유닛을 찾을 수 없는 경우 건너뛰기
          continue;
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
}

final billingRepositoryProvider = Provider<BillingRepository>((ref) {
  final appDatabase = ref.watch(appDatabaseProvider);
  return BillingRepository(appDatabase);
});
