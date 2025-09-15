import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:renthouse/core/database/app_database.dart' as app_db;
import 'package:renthouse/core/database/database_provider.dart';
import 'package:renthouse/features/lease/domain/lease.dart';
import 'package:drift/drift.dart';

class LeaseRepository {
  final app_db.AppDatabase _appDatabase;

  LeaseRepository(this._appDatabase);

  Future<List<Lease>> getLeases() async {
    final leases = await _appDatabase.getAllLeases();
    return leases.map((lease) => _mapLease(lease)).toList();
  }

  Future<Lease?> getLeaseById(String id) async {
    try {
      final lease = await _appDatabase.getLeaseById(id);
      return _mapLease(lease);
    } catch (e) {
      return null;
    }
  }

  Future<Lease> createLease(Lease lease) async {
    await _appDatabase.insertLease(app_db.LeasesCompanion.insert(
      id: lease.id,
      tenantId: lease.tenantId,
      unitId: lease.unitId,
      startDate: lease.startDate,
      endDate: lease.endDate,
      deposit: lease.deposit,
      monthlyRent: lease.monthlyRent,
      leaseType: lease.leaseType.name,
      leaseStatus: lease.leaseStatus.name,
      contractNotes: Value(lease.contractNotes),
    ));
    return lease;
  }

  Future<Lease> updateLease(Lease lease) async {
    await _appDatabase.updateLease(app_db.LeasesCompanion(
      id: Value(lease.id),
      tenantId: Value(lease.tenantId),
      unitId: Value(lease.unitId),
      startDate: Value(lease.startDate),
      endDate: Value(lease.endDate),
      deposit: Value(lease.deposit),
      monthlyRent: Value(lease.monthlyRent),
      leaseType: Value(lease.leaseType.name),
      leaseStatus: Value(lease.leaseStatus.name),
      contractNotes: Value(lease.contractNotes),
    ));
    return lease;
  }

  Future<void> deleteLease(String id) async {
    await _appDatabase.deleteLease(id);
  }

  Future<bool> hasLeasesForTenant(String tenantId) async {
    return _appDatabase.hasLeasesForTenant(tenantId);
  }

  // 임차인이 현재 활성 계약을 가지고 있는지 확인
  Future<bool> hasActiveLeaseForTenant(String tenantId) async {
    return await _appDatabase.hasActiveLeaseForTenant(tenantId);
  }

  // 현재 활성 계약이 없는 임차인 ID 목록 반환
  Future<List<String>> getAvailableTenantIds() async {
    return await _appDatabase.getActiveTenantIds();
  }

  Lease _mapLease(app_db.Lease lease) {
    return Lease(
      id: lease.id,
      tenantId: lease.tenantId,
      unitId: lease.unitId,
      startDate: lease.startDate,
      endDate: lease.endDate,
      deposit: lease.deposit,
      monthlyRent: lease.monthlyRent,
      leaseType: LeaseType.values.firstWhere((e) => e.toString() == 'LeaseType.${lease.leaseType}'),
      leaseStatus: LeaseStatus.values.firstWhere((e) => e.toString() == 'LeaseStatus.${lease.leaseStatus}'),
      contractNotes: lease.contractNotes,
    );
  }
}

final leaseRepositoryProvider = Provider<LeaseRepository>((ref) {
  final appDatabase = ref.watch(appDatabaseProvider);
  return LeaseRepository(appDatabase);
});