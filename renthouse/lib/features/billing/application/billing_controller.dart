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
    state = await AsyncValue.guard(() async {
      await ref.read(billingRepositoryProvider).createBilling(billing);
      return ref.read(billingRepositoryProvider).getBillings();
    });
  }

  Future<void> updateBilling(Billing billing) async {
    state = await AsyncValue.guard(() async {
      await ref.read(billingRepositoryProvider).updateBilling(billing);
      return ref.read(billingRepositoryProvider).getBillings();
    });
  }

  Future<void> deleteBilling(String id) async {
    state = await AsyncValue.guard(() async {
      await ref.read(billingRepositoryProvider).deleteBilling(id);
      return ref.read(billingRepositoryProvider).getBillings();
    });
  }

  Future<List<String>> createBulkBillings(String yearMonth, DateTime issueDate, DateTime dueDate) async {
    try {
      final repository = ref.read(billingRepositoryProvider);
      final createdIds = await repository.createBulkBillings(yearMonth, issueDate, dueDate);
      
      // 청구서 목록 새로고침
      state = await AsyncValue.guard(() async {
        return repository.getBillings();
      });
      
      return createdIds;
    } catch (e) {
      rethrow;
    }
  }
}