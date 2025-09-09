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
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(billingRepositoryProvider).createBilling(billing);
      return ref.read(billingRepositoryProvider).getBillings();
    });
  }

  Future<void> updateBilling(Billing billing) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(billingRepositoryProvider).updateBilling(billing);
      return ref.read(billingRepositoryProvider).getBillings();
    });
  }

  Future<void> deleteBilling(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(billingRepositoryProvider).deleteBilling(id);
      return ref.read(billingRepositoryProvider).getBillings();
    });
  }
}