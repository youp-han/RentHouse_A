import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:renthouse/features/tenant/data/tenant_repository.dart';
import 'package:renthouse/features/tenant/domain/tenant.dart';

part 'tenant_controller.g.dart';

@riverpod
class TenantController extends _$TenantController {
  @override
  Future<List<Tenant>> build() async {
    return ref.watch(tenantRepositoryProvider).getTenants();
  }

  Future<void> addTenant(Tenant tenant) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(tenantRepositoryProvider).createTenant(tenant);
      return ref.read(tenantRepositoryProvider).getTenants();
    });
  }

  Future<void> updateTenant(Tenant tenant) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(tenantRepositoryProvider).updateTenant(tenant);
      return ref.read(tenantRepositoryProvider).getTenants();
    });
  }

  Future<void> deleteTenant(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(tenantRepositoryProvider).deleteTenant(id);
      return ref.read(tenantRepositoryProvider).getTenants();
    });
  }
}