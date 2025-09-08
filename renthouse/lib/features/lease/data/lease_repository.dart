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
    return leases.map((lease) => Lease(
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
    )).toList();
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
}

final leaseRepositoryProvider = Provider<LeaseRepository>((ref) {
  final appDatabase = ref.watch(appDatabaseProvider);
  return LeaseRepository(appDatabase);
});