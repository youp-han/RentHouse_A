import 'package:drift/drift.dart';

// Import the new connection setup
import 'package:renthouse/core/database/connection.dart';

part 'app_database.g.dart';

// Define tables
class Properties extends Table {
  TextColumn get id => text().withLength(min: 1, max: 50)();
  TextColumn get name => text().withLength(min: 1, max: 255)();
  // 주소 구조 변경 (task136)
  TextColumn get zipCode => text().nullable()(); // 우편번호
  TextColumn get address1 => text().nullable()(); // 주소1
  TextColumn get address2 => text().nullable()(); // 상세주소
  TextColumn get address => text().nullable()(); // 기존 호환성을 위해 유지
  // 자산 유형을 enum string으로 저장 (task132)
  TextColumn get propertyType => text().withDefault(const Constant('villa'))();
  // 계약 종류 추가 (task135)
  TextColumn get contractType => text().withDefault(const Constant('wolse'))();
  // 층수 필드 제거됨 (task133)
  IntColumn get totalUnits => integer()();
  IntColumn get rent => integer().withDefault(const Constant(0))();
  // 소유자 정보 추가 (task134) - 고객관리 기능과 연동 예정
  TextColumn get ownerId => text().nullable()();
  TextColumn get ownerName => text().nullable()();
  TextColumn get ownerPhone => text().nullable()();
  TextColumn get ownerEmail => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// 자산별 기본 청구 항목 테이블 (추가 요구사항)
class PropertyBillingItems extends Table {
  TextColumn get id => text().withLength(min: 1, max: 50)();
  TextColumn get propertyId => text().withLength(min: 1, max: 50).references(Properties, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text().withLength(min: 1, max: 100)(); // 관리비, 수도비, 전기비, 청소비, 주차비, 수리비
  IntColumn get amount => integer()(); // 고정 금액
  BoolColumn get isEnabled => boolean().withDefault(const Constant(true))();

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
  TextColumn get bday => text().nullable()(); // 생년월일 (YYMMDD 형태)
  IntColumn get personalNo => integer().nullable()(); // 주민등록번호 뒷자리 첫번째 숫자
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
  TextColumn get itemName => text().withLength(min: 1, max: 100).nullable()(); // 템플릿 이름 직접 저장

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

class ActivityLogs extends Table {
  TextColumn get id => text().withLength(min: 1, max: 50)();
  TextColumn get userId => text().withLength(min: 1, max: 50).references(Users, #id, onDelete: KeyAction.cascade)();
  TextColumn get activityType => text().withLength(min: 1, max: 50)();
  TextColumn get description => text().withLength(min: 1, max: 500)();
  TextColumn get entityType => text().withLength(min: 1, max: 50)();
  TextColumn get entityId => text().withLength(min: 1, max: 50)();
  TextColumn get entityDisplayName => text().withLength(min: 1, max: 255).nullable().named('entity_name')();
  TextColumn get metadata => text().nullable()(); // JSON 형태로 저장
  DateTimeColumn get timestamp => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}


@DriftDatabase(tables: [Properties, Units, Tenants, Leases, BillTemplates, Billings, BillingItems, Users, Payments, PaymentAllocations, PropertyBillingItems, ActivityLogs])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? connect());

  @override
  int get schemaVersion => 8;

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
      
      if (from < 6) {
        // task131-136: Properties 테이블 업데이트
        // 새로운 컬럼들 추가
        await m.addColumn(properties, properties.zipCode);
        await m.addColumn(properties, properties.address1);
        await m.addColumn(properties, properties.address2);
        await m.addColumn(properties, properties.propertyType);
        await m.addColumn(properties, properties.contractType);
        await m.addColumn(properties, properties.ownerId);
        await m.addColumn(properties, properties.ownerName);
        await m.addColumn(properties, properties.ownerPhone);
        await m.addColumn(properties, properties.ownerEmail);
        
        // totalFloors 컬럼 제거 (task133) - Drift에서는 컬럼 삭제를 직접 지원하지 않으므로 무시
        
        // 새로운 테이블 생성
        await m.createTable(propertyBillingItems);
      }
      
      if (from < 7) {
        // task160: ActivityLogs 테이블 생성
        await m.createTable(activityLogs);
      }

      if (from < 8) {
        // BillingItems 테이블에 itemName 컬럼 추가 (청구 항목 이름 직접 저장)
        await m.addColumn(billingItems, billingItems.itemName);
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

  // 최적화된 활성 계약 확인 쿼리
  Future<bool> hasActiveLeaseForTenant(String tenantId) async {
    final now = DateTime.now();
    final activeLeases = await (select(leases)
      ..where((tbl) => 
        tbl.tenantId.equals(tenantId) & 
        tbl.leaseStatus.equals('active') &
        tbl.startDate.isSmallerThanValue(now) &
        tbl.endDate.isBiggerThanValue(now)
      )
    ).get();
    return activeLeases.isNotEmpty;
  }

  // 현재 활성 임차인 ID 목록 반환 (최적화된 쿼리)
  Future<List<String>> getActiveTenantIds() async {
    final now = DateTime.now();
    final activeLeases = await (select(leases)
      ..where((tbl) => 
        tbl.leaseStatus.equals('active') &
        tbl.startDate.isSmallerThanValue(now) &
        tbl.endDate.isBiggerThanValue(now)
      )
    ).get();
    return activeLeases.map((lease) => lease.tenantId).toSet().toList();
  }

  // 활성 계약 목록 반환 (최적화된 쿼리)
  Future<List<Lease>> getActiveLeases() async {
    return (select(leases)..where((tbl) => tbl.leaseStatus.equals('active'))).get();
  }

  // DAO for bill templates
  Future<List<BillTemplate>> getAllBillTemplates() => select(billTemplates).get();
  Future<BillTemplate?> getBillTemplateById(String id) async {
    try {
      return await (select(billTemplates)..where((tbl) => tbl.id.equals(id))).getSingle();
    } catch (e) {
      return null;
    }
  }
  Future<void> insertBillTemplate(BillTemplatesCompanion template) => into(billTemplates).insert(template);
  Future<bool> updateBillTemplate(BillTemplatesCompanion template) => update(billTemplates).replace(template);
  Future<void> deleteBillTemplate(String id) => (delete(billTemplates)..where((tbl) => tbl.id.equals(id))).go();

  // DAO for billings
  Future<List<Billing>> getAllBillings() => select(billings).get();
  Future<Billing?> getBillingById(String id) async {
    try {
      return await (select(billings)..where((tbl) => tbl.id.equals(id))).getSingle();
    } catch (e) {
      return null;
    }
  }
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

  Future<User?> getFirstUser() async {
    try {
      return await (select(users)..orderBy([(t) => OrderingTerm(expression: t.createdAt)])).getSingleOrNull();
    } catch (e) {
      return null;
    }
  }
  Future<void> insertUser(UsersCompanion user) => into(users).insert(user);
  Future<bool> updateUser(UsersCompanion user) => update(users).replace(user);
  Future<void> deleteUser(String id) => (delete(users)..where((tbl) => tbl.id.equals(id))).go();
  
  // 비밀번호 업데이트
  Future<void> updateUserPassword(String userId, String newPasswordHash) async {
    await (update(users)..where((tbl) => tbl.id.equals(userId)))
        .write(UsersCompanion(passwordHash: Value(newPasswordHash)));
  }
  
  // 사용자 이름 업데이트
  Future<void> updateUserName(String userId, String newName) async {
    await (update(users)..where((tbl) => tbl.id.equals(userId)))
        .write(UsersCompanion(name: Value(newName)));
  }

  /// 사용자와 연관된 모든 데이터 삭제 (회원 탈퇴 시 사용)
  Future<void> deleteAllUserData(String userId) async {
    await transaction(() async {
      // 1. 사용자가 소유한 자산들 조회
      final userProperties = await (select(properties)..where((tbl) => tbl.ownerId.equals(userId))).get();
      
      for (final property in userProperties) {
        // 2. 각 자산의 유닛들과 연관된 데이터 삭제
        final propertyUnits = await getUnitsForProperty(property.id);
        
        for (final unit in propertyUnits) {
          // 3. 해당 유닛의 계약들 조회 및 관련 데이터 삭제
          final unitLeases = await (select(leases)..where((tbl) => tbl.unitId.equals(unit.id))).get();
          
          for (final lease in unitLeases) {
            // 4. 계약별 청구서들과 관련 데이터 삭제
            final leaseBillings = await (select(billings)..where((tbl) => tbl.leaseId.equals(lease.id))).get();
            
            for (final billing in leaseBillings) {
              // 청구서 항목들 삭제
              await (delete(billingItems)..where((tbl) => tbl.billingId.equals(billing.id))).go();
              
              // 수납 배분 데이터 삭제
              await deletePaymentAllocationsForBilling(billing.id);
            }
            
            // 청구서들 삭제
            await (delete(billings)..where((tbl) => tbl.leaseId.equals(lease.id))).go();
          }
          
          // 계약들 삭제
          await (delete(leases)..where((tbl) => tbl.unitId.equals(unit.id))).go();
        }
        
        // 5. 자산별 청구 항목들 삭제 (CASCADE로 자동 삭제되지만 명시적으로)
        await (delete(propertyBillingItems)..where((tbl) => tbl.propertyId.equals(property.id))).go();
        
        // 6. 유닛들 삭제 (CASCADE로 자동 삭제되지만 명시적으로)
        await deleteUnitsForProperty(property.id);
      }
      
      // 7. 사용자 소유 자산들 삭제
      await (delete(properties)..where((tbl) => tbl.ownerId.equals(userId))).go();
      
      // 8. 마지막으로 사용자 삭제
      await deleteUser(userId);
    });
  }

  /// 청구서 ID로 수납 배분 삭제
  Future<void> deletePaymentAllocationsForBilling(String billingId) =>
      (delete(paymentAllocations)..where((tbl) => tbl.billingId.equals(billingId))).go();

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

  // ActivityLogs DAO 메서드들
  Future<List<ActivityLog>> getAllActivityLogs() => select(activityLogs).get();
  Future<List<ActivityLog>> getRecentActivityLogs({int limit = 50}) => 
    (select(activityLogs)..orderBy([(tbl) => OrderingTerm.desc(tbl.timestamp)])..limit(limit)).get();
  Future<List<ActivityLog>> getActivityLogsByUser(String userId) => 
    (select(activityLogs)..where((tbl) => tbl.userId.equals(userId))..orderBy([(tbl) => OrderingTerm.desc(tbl.timestamp)])).get();
  Future<List<ActivityLog>> getActivityLogsByEntity(String entityType, String entityId) => 
    (select(activityLogs)..where((tbl) => tbl.entityType.equals(entityType) & tbl.entityId.equals(entityId))..orderBy([(tbl) => OrderingTerm.desc(tbl.timestamp)])).get();
  Future<void> insertActivityLog(ActivityLogsCompanion activityLog) => into(activityLogs).insert(activityLog);
  Future<void> deleteActivityLog(String id) => (delete(activityLogs)..where((tbl) => tbl.id.equals(id))).go();
  Future<void> deleteOldActivityLogs(DateTime cutoffDate) => 
    (delete(activityLogs)..where((tbl) => tbl.timestamp.isSmallerThanValue(cutoffDate))).go();

  // PropertyBillingItems DAO 메서드들
  Future<List<PropertyBillingItem>> getPropertyBillingItems(String propertyId) => 
    (select(propertyBillingItems)..where((tbl) => tbl.propertyId.equals(propertyId))).get();
  
  Future<List<PropertyBillingItem>> getActivePropertyBillingItems(String propertyId) => 
    (select(propertyBillingItems)
      ..where((tbl) => tbl.propertyId.equals(propertyId) & tbl.isEnabled.equals(true))
    ).get();
  
  Future<void> insertPropertyBillingItem(PropertyBillingItemsCompanion item) => 
    into(propertyBillingItems).insert(item);
  
  Future<bool> updatePropertyBillingItem(PropertyBillingItemsCompanion item) => 
    update(propertyBillingItems).replace(item);
  
  Future<void> deletePropertyBillingItem(String id) => 
    (delete(propertyBillingItems)..where((tbl) => tbl.id.equals(id))).go();
  
  Future<void> deletePropertyBillingItemsForProperty(String propertyId) => 
    (delete(propertyBillingItems)..where((tbl) => tbl.propertyId.equals(propertyId))).go();

  // 자산별 기본 청구 항목 초기화 (선택항목: 관리비, 수도비, 전기비, 청소비, 주차비, 수리비)
  Future<void> initializeDefaultBillingItemsForProperty(String propertyId) async {
    final defaultItems = [
      {'name': '관리비', 'amount': 50000},
      {'name': '수도비', 'amount': 30000},
      {'name': '전기비', 'amount': 40000},
      {'name': '청소비', 'amount': 20000},
      {'name': '주차비', 'amount': 50000},
      {'name': '수리비 (임차인과실)', 'amount': 0},
    ];

    for (final item in defaultItems) {
      await insertPropertyBillingItem(PropertyBillingItemsCompanion.insert(
        id: 'pbi_${propertyId}_${DateTime.now().millisecondsSinceEpoch}_${item['name'].hashCode}',
        propertyId: propertyId,
        name: item['name'] as String,
        amount: item['amount'] as int,
        isEnabled: const Value(false), // 기본적으로 비활성화
      ));
    }
  }
}
