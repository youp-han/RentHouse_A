import 'package:drift/drift.dart';

// Import the new connection setup
import 'package:renthouse/core/database/connection.dart';

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
  // Phase 2: 청구서 상태 추가
  TextColumn get status => text().withDefault(const Constant('DRAFT'))(); // DRAFT, ISSUED, PARTIALLY_PAID, PAID, OVERDUE, VOID

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

// Phase 2: 새로운 테이블들
class Users extends Table {
  TextColumn get id => text().withLength(min: 1, max: 50)();
  TextColumn get email => text().withLength(min: 1, max: 255).unique()();
  TextColumn get name => text().withLength(min: 1, max: 255)();
  TextColumn get passwordHash => text().withLength(min: 1, max: 255)();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class Payments extends Table {
  TextColumn get id => text().withLength(min: 1, max: 50)();
  TextColumn get tenantId => text().withLength(min: 1, max: 50).references(Tenants, #id, onDelete: KeyAction.cascade)();
  TextColumn get method => text().withLength(min: 1, max: 50)(); // CASH, TRANSFER, CARD
  IntColumn get amount => integer()();
  DateTimeColumn get paidDate => dateTime()();
  TextColumn get memo => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class PaymentAllocations extends Table {
  TextColumn get id => text().withLength(min: 1, max: 50)();
  TextColumn get paymentId => text().withLength(min: 1, max: 50).references(Payments, #id, onDelete: KeyAction.cascade)();
  TextColumn get billingId => text().withLength(min: 1, max: 50).references(Billings, #id, onDelete: KeyAction.cascade)();
  IntColumn get amount => integer()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}


@DriftDatabase(tables: [Properties, Units, Tenants, Leases, BillTemplates, Billings, BillingItems, Users, Payments, PaymentAllocations])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? connect());

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) {
      return m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 5) {
        // Phase 2: 새로운 테이블들 생성
        await m.createTable(users);
        await m.createTable(payments);
        await m.createTable(paymentAllocations);
        
        // Billings 테이블에 status 컬럼 추가
        await m.addColumn(billings, billings.status);
        
        // (lease_id, yearMonth) 유니크 인덱스 추가
        await m.createIndex(Index('billing_lease_month_unique', 
          'CREATE UNIQUE INDEX billing_lease_month_unique ON billings (lease_id, year_month)'));
      }
    },
  );

  // DAO for properties
  Future<List<Property>> getAllProperties() => select(properties).get();
  Future<Property> getPropertyById(String id) => (select(properties)..where((tbl) => tbl.id.equals(id))).getSingle();
  Future<void> insertProperty(PropertiesCompanion property) => into(properties).insert(property);
  Future<bool> updateProperty(PropertiesCompanion property) => update(properties).replace(property);
  Future<void> deleteProperty(String id) => (delete(properties)..where((tbl) => tbl.id.equals(id))).go();

  // DAO for units
  Future<List<Unit>> getAllUnits() => select(units).get();
  Future<Unit> getUnitById(String id) => (select(units)..where((tbl) => tbl.id.equals(id))).getSingle();
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
  Future<bool> hasLeasesForTenant(String tenantId) async {
    final count = await (select(leases)..where((tbl) => tbl.tenantId.equals(tenantId))).get().then((list) => list.length);
    return count > 0;
  }

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

  // Phase 2: DAO for users
  Future<List<User>> getAllUsers() => select(users).get();
  Future<User?> getUserById(String id) async {
    try {
      return await (select(users)..where((tbl) => tbl.id.equals(id))).getSingle();
    } catch (e) {
      return null;
    }
  }
  Future<User?> getUserByEmail(String email) async {
    try {
      return await (select(users)..where((tbl) => tbl.email.equals(email))).getSingle();
    } catch (e) {
      return null;
    }
  }
  Future<void> insertUser(UsersCompanion user) => into(users).insert(user);
  Future<bool> updateUser(UsersCompanion user) => update(users).replace(user);
  Future<void> deleteUser(String id) => (delete(users)..where((tbl) => tbl.id.equals(id))).go();

  // Phase 2: DAO for payments
  Future<List<Payment>> getAllPayments() => select(payments).get();
  Future<Payment?> getPaymentById(String id) async {
    try {
      return await (select(payments)..where((tbl) => tbl.id.equals(id))).getSingle();
    } catch (e) {
      return null;
    }
  }
  Future<List<Payment>> getPaymentsByTenant(String tenantId) => (select(payments)..where((tbl) => tbl.tenantId.equals(tenantId))).get();
  Future<void> insertPayment(PaymentsCompanion payment) => into(payments).insert(payment);
  Future<bool> updatePayment(PaymentsCompanion payment) => update(payments).replace(payment);
  Future<void> deletePayment(String id) => (delete(payments)..where((tbl) => tbl.id.equals(id))).go();

  // Phase 2: DAO for payment allocations
  Future<List<PaymentAllocation>> getAllPaymentAllocations() => select(paymentAllocations).get();
  Future<List<PaymentAllocation>> getPaymentAllocationsByPayment(String paymentId) => 
    (select(paymentAllocations)..where((tbl) => tbl.paymentId.equals(paymentId))).get();
  Future<List<PaymentAllocation>> getPaymentAllocationsByBilling(String billingId) => 
    (select(paymentAllocations)..where((tbl) => tbl.billingId.equals(billingId))).get();
  Future<void> insertPaymentAllocation(PaymentAllocationsCompanion allocation) => into(paymentAllocations).insert(allocation);
  Future<void> deletePaymentAllocation(String id) => (delete(paymentAllocations)..where((tbl) => tbl.id.equals(id))).go();
  Future<void> deletePaymentAllocationsForPayment(String paymentId) => 
    (delete(paymentAllocations)..where((tbl) => tbl.paymentId.equals(paymentId))).go();

  // Phase 2: 청구서 상태 관련 DAO 메서드들
  Future<List<Billing>> getBillingsByStatus(String status) => 
    (select(billings)..where((tbl) => tbl.status.equals(status))).get();
  Future<List<Billing>> getOverdueBillings() async {
    final now = DateTime.now();
    return (select(billings)
      ..where((tbl) => tbl.dueDate.isSmallerThanValue(now) & tbl.status.isNotValue('PAID'))
    ).get();
  }
  Future<void> updateBillingStatus(String billingId, String status) async {
    await (update(billings)..where((tbl) => tbl.id.equals(billingId)))
      .write(BillingsCompanion(status: Value(status)));
  }

  // Phase 2: 수납 관련 복합 쿼리
  Future<int> getTotalPaidAmountForBilling(String billingId) async {
    final allocations = await getPaymentAllocationsByBilling(billingId);
    return allocations.fold<int>(0, (sum, allocation) => sum + allocation.amount);
  }

  // Phase 2: 중복 청구 방지 체크
  Future<bool> hasExistingBilling(String leaseId, String yearMonth) async {
    final existing = await (select(billings)
      ..where((tbl) => tbl.leaseId.equals(leaseId) & tbl.yearMonth.equals(yearMonth))
    ).get();
    return existing.isNotEmpty;
  }
}
