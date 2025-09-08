import 'dart:io';
import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/foundation.dart' show kIsWeb;

// Import the new connection setup
import 'package:renthouse/core/database/connection.dart';

import 'package:renthouse/features/billing/domain/bill_template.dart';
import 'package:renthouse/features/billing/domain/billing.dart';
import 'package:renthouse/features/billing/domain/billing_item.dart';
import 'package:renthouse/features/lease/domain/lease.dart';
import 'package:renthouse/features/property/domain/property.dart';
import 'package:renthouse/features/property/domain/unit.dart';
import 'package:renthouse/features/tenant/domain/tenant.dart';

part 'app_database.g.dart';

// Define tables
class Properties extends Table {
  TextColumn get id => text().withLength(min: 1, max: 50)();
  TextColumn get name => text().withLength(min: 1, max: 255)();
  TextColumn get address => text().withLength(min: 1, max: 255)();
  TextColumn get type => text().withLength(min: 1, max: 50)();
  IntColumn get rent => integer()();
  IntColumn get totalFloors => integer()();
  IntColumn get totalUnits => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

class Units extends Table {
  TextColumn get id => text().withLength(min: 1, max: 50)();
  TextColumn get propertyId => text().withLength(min: 1, max: 50).references(Properties, #id, onDelete: KeyAction.cascade)();
  TextColumn get unitNumber => text().withLength(min: 1, max: 50)();
  TextColumn get rentStatus => text().withLength(min: 1, max: 50)();
  RealColumn get sizeMeter => real()();
  RealColumn get sizeKorea => real()();
  TextColumn get useType => text().withLength(min: 1, max: 50)();
  TextColumn get description => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Tenants extends Table {
  TextColumn get id => text().withLength(min: 1, max: 50)();
  TextColumn get name => text().withLength(min: 1, max: 255)();
  TextColumn get phone => text().withLength(min: 1, max: 50)();
  TextColumn get email => text().withLength(min: 1, max: 255)();
  TextColumn get socialNo => text().nullable()();
  TextColumn get currentAddress => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class Leases extends Table {
  TextColumn get id => text().withLength(min: 1, max: 50)();
  TextColumn get tenantId => text().withLength(min: 1, max: 50).references(Tenants, #id, onDelete: KeyAction.cascade)();
  TextColumn get unitId => text().withLength(min: 1, max: 50).references(Units, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  IntColumn get deposit => integer()();
  IntColumn get monthlyRent => integer()();
  TextColumn get leaseType => text()();
  TextColumn get leaseStatus => text()();
  TextColumn get contractNotes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class BillTemplates extends Table {
  TextColumn get id => text().withLength(min: 1, max: 50)();
  TextColumn get name => text().withLength(min: 1, max: 255)();
  TextColumn get category => text().withLength(min: 1, max: 50)();
  IntColumn get amount => integer()();
  TextColumn get description => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Billings extends Table {
  TextColumn get id => text().withLength(min: 1, max: 50)();
  TextColumn get leaseId => text().withLength(min: 1, max: 50).references(Leases, #id, onDelete: KeyAction.cascade)();
  TextColumn get yearMonth => text().withLength(min: 1, max: 7)();
  DateTimeColumn get issueDate => dateTime()();
  DateTimeColumn get dueDate => dateTime()();
  BoolColumn get paid => boolean().withDefault(const Constant(false))();
  DateTimeColumn get paidDate => dateTime().nullable()();
  IntColumn get totalAmount => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

class BillingItems extends Table {
  TextColumn get id => text().withLength(min: 1, max: 50)();
  TextColumn get billingId => text().withLength(min: 1, max: 50).references(Billings, #id, onDelete: KeyAction.cascade)();
  TextColumn get billTemplateId => text().withLength(min: 1, max: 50).references(BillTemplates, #id, onDelete: KeyAction.restrict)();
  IntColumn get amount => integer()();

  @override
  Set<Column> get primaryKey => {id};
}


@DriftDatabase(tables: [Properties, Units, Tenants, Leases, BillTemplates, Billings, BillingItems])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(connect());

  @override
  int get schemaVersion => 4;

  // DAO for properties
  Future<List<Property>> getAllProperties() => select(properties).get();
  Future<Property> getPropertyById(String id) => (select(properties)..where((tbl) => tbl.id.equals(id))).getSingle();
  Future<void> insertProperty(PropertiesCompanion property) => into(properties).insert(property);
  Future<bool> updateProperty(PropertiesCompanion property) => update(properties).replace(property);
  Future<void> deleteProperty(String id) => (delete(properties)..where((tbl) => tbl.id.equals(id))).go();

  // DAO for units
  Future<List<Unit>> getAllUnits() => select(units).get();
  Future<List<Unit>> getUnitsForProperty(String propertyId) => (select(units)..where((tbl) => tbl.propertyId.equals(propertyId))).get();
  Future<void> insertUnit(UnitsCompanion unit) => into(units).insert(unit);
  Future<bool> updateUnit(UnitsCompanion unit) => update(units).replace(unit);
  Future<void> deleteUnit(String id) => (delete(units)..where((tbl) => tbl.id.equals(id))).go();
  Future<void> deleteUnitsForProperty(String propertyId) => (delete(units)..where((tbl) => tbl.propertyId.equals(propertyId))).go();

  // DAO for tenants
  Future<List<Tenant>> getAllTenants() => select(tenants).get();
  Future<Tenant> getTenantById(String id) => (select(tenants)..where((tbl) => tbl.id.equals(id))).getSingle();
  Future<void> insertTenant(TenantsCompanion tenant) => into(tenants).insert(tenant);
  Future<bool> updateTenant(TenantsCompanion tenant) => update(tenants).replace(tenant);
  Future<void> deleteTenant(String id) => (delete(tenants)..where((tbl) => tbl.id.equals(id))).go();

  // DAO for leases
  Future<List<Lease>> getAllLeases() => select(leases).get();
  Future<Lease> getLeaseById(String id) => (select(leases)..where((tbl) => tbl.id.equals(id))).getSingle();
  Future<void> insertLease(LeasesCompanion lease) => into(leases).insert(lease);
  Future<bool> updateLease(LeasesCompanion lease) => update(leases).replace(lease);
  Future<void> deleteLease(String id) => (delete(leases)..where((tbl) => tbl.id.equals(id))).go();

  // DAO for bill templates
  Future<List<BillTemplate>> getAllBillTemplates() => select(billTemplates).get();
  Future<void> insertBillTemplate(BillTemplatesCompanion template) => into(billTemplates).insert(template);
  Future<bool> updateBillTemplate(BillTemplatesCompanion template) => update(billTemplates).replace(template);
  Future<void> deleteBillTemplate(String id) => (delete(billTemplates)..where((tbl) => tbl.id.equals(id))).go();

  // DAO for billings
  Future<List<Billing>> getAllBillings() => select(billings).get();
  Future<void> insertBilling(BillingsCompanion billing) => into(billings).insert(billing);
  Future<bool> updateBilling(BillingsCompanion billing) => update(billings).replace(billing);
  Future<void> deleteBilling(String id) => (delete(billings)..where((tbl) => tbl.id.equals(id))).go();

  // DAO for billing items
  Future<List<BillingItem>> getBillingItemsForBilling(String billingId) => (select(billingItems)..where((tbl) => tbl.billingId.equals(billingId))).get();
  Future<void> insertBillingItem(BillingItemsCompanion item) => into(billingItems).insert(item);
  Future<void> deleteBillingItemsForBilling(String billingId) => (delete(billingItems)..where((tbl) => tbl.billingId.equals(billingId))).go();
}
