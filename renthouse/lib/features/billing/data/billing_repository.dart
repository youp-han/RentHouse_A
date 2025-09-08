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
  Future<List<Billing>> getBillings() async {
    final billings = await _appDatabase.getAllBillings();
    return Future.wait(billings.map((billing) async {
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
}

final billingRepositoryProvider = Provider<BillingRepository>((ref) {
  final appDatabase = ref.watch(appDatabaseProvider);
  return BillingRepository(appDatabase);
});
