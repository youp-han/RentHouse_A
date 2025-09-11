# RentHouse Project Entities

This document summarizes the core data entities and database tables used in the RentHouse project.

## Domain Models (Freezed)

These are the primary data models used throughout the application, defined using the `freezed` package for immutable data structures.

### Property

*File: `renthouse/lib/features/property/domain/property.dart`*

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:renthouse/features/property/domain/unit.dart';

part 'property.freezed.dart';
part 'property.g.dart';

@freezed
class Property with _$Property {
  const factory Property({
    required String id,
    required String name,
    required String address,
    required String type,
    required int totalFloors,
    required int totalUnits,
    @Default(0) int rent,
    @Default([]) List<Unit> units,
  }) = _Property;

  factory Property.fromJson(Map<String, dynamic> json) => _$PropertyFromJson(json);
}
```

### Unit

*File: `renthouse/lib/features/property/domain/unit.dart`*

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'unit.freezed.dart';
part 'unit.g.dart';

@freezed
class Unit with _$Unit {
  const factory Unit({
    required String id,
    required String propertyId,
    required String unitNumber,
    required String rentStatus,
    required double sizeMeter,
    required double sizeKorea,
    required String useType,
    String? description,
  }) = _Unit;

  factory Unit.fromJson(Map<String, dynamic> json) => _$UnitFromJson(json);
}
```

### Tenant

*File: `renthouse/lib/features/tenant/domain/tenant.dart`*

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tenant.freezed.dart';
part 'tenant.g.dart';

@freezed
class Tenant with _$Tenant {
  const factory Tenant({
    required String id,
    required String name,
    required String phone,
    required String email,
    String? socialNo,
    String? currentAddress,
    required DateTime createdAt,
  }) = _Tenant;

  factory Tenant.fromJson(Map<String, dynamic> json) => _$TenantFromJson(json);
}
```

### Lease

*File: `renthouse/lib/features/lease/domain/lease.dart`*

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'lease.freezed.dart';
part 'lease.g.dart';

enum LeaseType { residential, commercial }

enum LeaseStatus { active, terminated, expired, pending }

@freezed
class Lease with _$Lease {
  const factory Lease({
    required String id,
    required String tenantId,
    required String unitId,
    required DateTime startDate,
    required DateTime endDate,
    required int deposit,
    required int monthlyRent,
    required LeaseType leaseType,
    required LeaseStatus leaseStatus,
    String? contractNotes,
  }) = _Lease;

  factory Lease.fromJson(Map<String, dynamic> json) => _$LeaseFromJson(json);
}
```

### BillTemplate

*File: `renthouse/lib/features/billing/domain/bill_template.dart`*

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bill_template.freezed.dart';
part 'bill_template.g.dart';

@freezed
class BillTemplate with _$BillTemplate {
  const factory BillTemplate({
    required String id,
    required String name,
    required String category,
    required int amount,
    String? description,
  }) = _BillTemplate;

  factory BillTemplate.fromJson(Map<String, dynamic> json) => _$BillTemplateFromJson(json);
}
```

### Billing

*File: `renthouse/lib/features/billing/domain/billing.dart`*

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:renthouse/features/billing/domain/billing_item.dart';

part 'billing.freezed.dart';
part 'billing.g.dart';

@freezed
class Billing with _$Billing {
  const factory Billing({
    required String id,
    required String leaseId,
    required String yearMonth,
    required DateTime issueDate,
    required DateTime dueDate,
    @Default(false) bool paid,
    DateTime? paidDate,
    required int totalAmount,
    @Default([]) List<BillingItem> items,
  }) = _Billing;

  factory Billing.fromJson(Map<String, dynamic> json) => _$BillingFromJson(json);
}
```

### BillingItem

*File: `renthouse/lib/features/billing/domain/billing_item.dart`*

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'billing_item.freezed.dart';
part 'billing_item.g.dart';

@freezed
class BillingItem with _$BillingItem {
  const factory BillingItem({
    required String id,
    required String billingId,
    required String billTemplateId,
    required int amount,
  }) = _BillingItem;

  factory BillingItem.fromJson(Map<String, dynamic> json) => _$BillingItemFromJson(json);
}
```

## Database Tables (Drift)

These are the table definitions for the SQLite database, managed by the `drift` package.

*File: `renthouse/lib/core/database/app_database.dart`*

### Properties Table

```dart
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
```

### Units Table

```dart
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
```

### Tenants Table

```dart
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
```

### Leases Table

```dart
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
```

### BillTemplates Table

```dart
class BillTemplates extends Table {
  TextColumn get id => text().withLength(min: 1, max: 50)();
  TextColumn get name => text().withLength(min: 1, max: 255)();
  TextColumn get category => text().withLength(min: 1, max: 50)();
  IntColumn get amount => integer()();
  TextColumn get description => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
```

### Billings Table

```dart
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
```

### BillingItems Table

```dart
class BillingItems extends Table {
  TextColumn get id => text().withLength(min: 1, max: 50)();
  TextColumn get billingId => text().withLength(min: 1, max: 50).references(Billings, #id, onDelete: KeyAction.cascade)();
  TextColumn get billTemplateId => text().withLength(min: 1, max: 50).references(BillTemplates, #id, onDelete: KeyAction.restrict)();
  IntColumn get amount => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
```