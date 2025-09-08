import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:renthouse/features/billing/data/billing_repository.dart';
import 'package:renthouse/features/billing/domain/bill_template.dart';

part 'bill_template_controller.g.dart';

@riverpod
class BillTemplateController extends _$BillTemplateController {
  @override
  Future<List<BillTemplate>> build() async {
    return ref.watch(billingRepositoryProvider).getBillTemplates();
  }

  Future<void> addBillTemplate(BillTemplate template) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(billingRepositoryProvider).createBillTemplate(template);
      return ref.read(billingRepositoryProvider).getBillTemplates();
    });
  }

  Future<void> updateBillTemplate(BillTemplate template) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(billingRepositoryProvider).updateBillTemplate(template);
      return ref.read(billingRepositoryProvider).getBillTemplates();
    });
  }

  Future<void> deleteBillTemplate(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(billingRepositoryProvider).deleteBillTemplate(id);
      return ref.read(billingRepositoryProvider).getBillTemplates();
    });
  }
}