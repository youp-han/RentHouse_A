import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:renthouse/core/database/app_database.dart' as app_db;
import 'package:renthouse/core/database/database_provider.dart';
import 'package:renthouse/features/tenant/domain/tenant.dart';
import 'package:drift/drift.dart';

class TenantRepository {
  final app_db.AppDatabase _appDatabase;

  TenantRepository(this._appDatabase);

  Future<List<Tenant>> getTenants() async {
    final tenants = await _appDatabase.getAllTenants();
    return tenants.map((tenant) => Tenant(
      id: tenant.id,
      name: tenant.name,
      phone: tenant.phone,
      email: tenant.email,
      socialNo: tenant.socialNo,
      bday: tenant.bday,
      personalNo: tenant.personalNo,
      currentAddress: tenant.currentAddress,
      createdAt: tenant.createdAt,
    )).toList();
  }

  Future<Tenant> createTenant(Tenant tenant) async {
    await _appDatabase.insertTenant(app_db.TenantsCompanion.insert(
      id: tenant.id,
      name: tenant.name,
      phone: tenant.phone,
      email: tenant.email,
      socialNo: Value(tenant.socialNo),
      bday: Value(tenant.bday),
      personalNo: Value(tenant.personalNo),
      currentAddress: Value(tenant.currentAddress),
      createdAt: tenant.createdAt,
    ));
    return tenant;
  }

  Future<Tenant> updateTenant(Tenant tenant) async {
    await _appDatabase.updateTenant(app_db.TenantsCompanion(
      id: Value(tenant.id),
      name: Value(tenant.name),
      phone: Value(tenant.phone),
      email: Value(tenant.email),
      socialNo: Value(tenant.socialNo),
      bday: Value(tenant.bday),
      personalNo: Value(tenant.personalNo),
      currentAddress: Value(tenant.currentAddress),
      createdAt: Value(tenant.createdAt),
    ));
    return tenant;
  }

  Future<void> deleteTenant(String id) async {
    // Check for associated leases before deleting the tenant
    final hasLeases = await _appDatabase.hasLeasesForTenant(id);
    if (hasLeases) {
      throw Exception('Tenant has associated leases and cannot be deleted.');
    }
    await _appDatabase.deleteTenant(id);
  }
}

final tenantRepositoryProvider = Provider<TenantRepository>((ref) {
  final appDatabase = ref.watch(appDatabaseProvider);
  return TenantRepository(appDatabase);
});