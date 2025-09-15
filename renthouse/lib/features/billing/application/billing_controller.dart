import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:renthouse/features/billing/data/billing_repository.dart';
import 'package:renthouse/features/billing/domain/billing.dart';

part 'billing_controller.g.dart';

@riverpod
class BillingController extends _$BillingController {
  @override
  Future<List<Billing>> build({String? searchQuery}) async {
    return ref.watch(billingRepositoryProvider).getBillings(searchQuery: searchQuery);
  }

  Future<void> addBilling(Billing billing) async {
    await ref.read(billingRepositoryProvider).createBilling(billing);
    ref.invalidateSelf();
  }

  Future<void> updateBilling(Billing billing) async {
    await ref.read(billingRepositoryProvider).updateBilling(billing);
    ref.invalidateSelf();
  }

  Future<void> deleteBilling(String id) async {
    await ref.read(billingRepositoryProvider).deleteBilling(id);
    ref.invalidateSelf();
  }

  Future<List<String>> createBulkBillings(String yearMonth, DateTime issueDate, DateTime dueDate) async {
    try {
      final repository = ref.read(billingRepositoryProvider);
      final createdIds = await repository.createBulkBillings(yearMonth, issueDate, dueDate);

      // 청구서 목록 새로고침
      ref.invalidateSelf();

      return createdIds;
    } catch (e) {
      rethrow;
    }
  }
}