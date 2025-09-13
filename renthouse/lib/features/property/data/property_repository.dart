import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:renthouse/core/database/app_database.dart' as app_db;
import 'package:renthouse/core/database/database_provider.dart';
import 'package:renthouse/features/property/domain/property.dart';
import 'package:renthouse/features/property/domain/unit.dart';
import 'package:renthouse/features/activity/application/activity_log_service.dart';
import 'package:drift/drift.dart';

class PropertyRepository {
  final app_db.AppDatabase _appDatabase;
  final ActivityLogService? _activityLogService;

  PropertyRepository(this._appDatabase, [this._activityLogService]);

  Future<List<Property>> getProperties() async {
    final properties = await _appDatabase.getAllProperties();
    return Future.wait(properties.map((property) async {
      final units = await _appDatabase.getUnitsForProperty(property.id);
      final billingItems = await _appDatabase.getPropertyBillingItems(property.id);
      return _mapProperty(property, units, billingItems);
    }).toList());
  }

  Future<Property?> getPropertyById(String id) async {
    // Inefficient: Fetches all properties and filters in memory.
    // TODO: Replace with a direct database query for a single property by ID.
    final allProperties = await getProperties();
    return allProperties.firstWhereOrNull((p) => p.id == id);
  }

  Future<Property> createProperty(Property property) async {
    await _appDatabase.insertProperty(app_db.PropertiesCompanion.insert(
      id: property.id,
      name: property.name,
      zipCode: Value(property.zipCode),
      address1: Value(property.address1),
      address2: Value(property.address2),
      propertyType: Value(property.propertyType.name),
      contractType: Value(property.contractType.name),
      rent: const Value(0),
      totalUnits: property.totalUnits,
      ownerName: Value(property.ownerName),
      ownerPhone: Value(property.ownerPhone),
      ownerEmail: Value(property.ownerEmail),
    ));
    
    // Insert billing items
    for (var item in property.defaultBillingItems) {
      await _appDatabase.insertPropertyBillingItem(app_db.PropertyBillingItemsCompanion.insert(
        id: 'pbi_${property.id}_${DateTime.now().millisecondsSinceEpoch}_${item.name.hashCode}',
        propertyId: property.id,
        name: item.name,
        amount: item.amount,
        isEnabled: Value(item.isEnabled),
      ));
    }
    
    for (var unit in property.units) {
      await addUnit(unit);
    }
    
    // 활동 로그 기록
    await _activityLogService?.logPropertyCreated(property.id, property.name);
    
    return property;
  }

  Future<Property> updateProperty(Property property) async {
    await _appDatabase.updateProperty(app_db.PropertiesCompanion(
      id: Value(property.id),
      name: Value(property.name),
      zipCode: Value(property.zipCode),
      address1: Value(property.address1),
      address2: Value(property.address2),
      propertyType: Value(property.propertyType.name),
      contractType: Value(property.contractType.name),
      rent: const Value(0),
      totalUnits: Value(property.totalUnits),
      ownerName: Value(property.ownerName),
      ownerPhone: Value(property.ownerPhone),
      ownerEmail: Value(property.ownerEmail),
    ));
    
    // Update billing items - delete existing and insert new ones  
    await _appDatabase.deletePropertyBillingItemsForProperty(property.id);
    for (var item in property.defaultBillingItems) {
      await _appDatabase.insertPropertyBillingItem(app_db.PropertyBillingItemsCompanion.insert(
        id: 'pbi_${property.id}_${DateTime.now().millisecondsSinceEpoch}_${item.name.hashCode}',
        propertyId: property.id,
        name: item.name,
        amount: item.amount,
        isEnabled: Value(item.isEnabled),
      ));
    }
    
    // 활동 로그 기록
    await _activityLogService?.logPropertyUpdated(property.id, property.name);
    
    return property;
  }

  Future<void> deleteProperty(String id) async {
    // 삭제 전에 property 정보 가져오기 (로깅용)
    final property = await getPropertyById(id);
    final propertyName = property?.name ?? 'Unknown Property';
    
    await _appDatabase.deleteProperty(id);
    
    // 활동 로그 기록
    await _activityLogService?.logPropertyDeleted(id, propertyName);
  }

  Future<Unit> addUnit(Unit unit) async {
    await _appDatabase.insertUnit(app_db.UnitsCompanion.insert(
      id: unit.id,
      propertyId: unit.propertyId,
      unitNumber: unit.unitNumber,
      rentStatus: unit.rentStatus.value,
      sizeMeter: unit.sizeMeter,
      sizeKorea: unit.sizeKorea,
      useType: unit.useType,
      description: Value(unit.description),
    ));
    return unit;
  }

  Future<Unit> updateUnit(Unit unit) async {
    await _appDatabase.updateUnit(app_db.UnitsCompanion(
      id: Value(unit.id),
      propertyId: Value(unit.propertyId),
      unitNumber: Value(unit.unitNumber),
      rentStatus: Value(unit.rentStatus.value),
      sizeMeter: Value(unit.sizeMeter),
      sizeKorea: Value(unit.sizeKorea),
      useType: Value(unit.useType),
      description: Value(unit.description),
    ));
    return unit;
  }

  Future<void> deleteUnit(String id) async {
    await _appDatabase.deleteUnit(id);
  }

  Future<Unit?> getUnitById(String id) async {
    try {
      final unit = await _appDatabase.getUnitById(id);
      return _mapUnit(unit);
    } catch (e) {
      return null;
    }
  }

  Future<List<Unit>> getAllUnits() async {
    final units = await _appDatabase.getAllUnits();
    return units.map((unit) => _mapUnit(unit)).toList();
  }

  Property _mapProperty(app_db.Property property, List<app_db.Unit> units, List<app_db.PropertyBillingItem> billingItems) {
    return Property(
      id: property.id,
      name: property.name,
      zipCode: property.zipCode,
      address1: property.address1,
      address2: property.address2,
      address: property.address1, // For backward compatibility
      propertyType: PropertyType.values.firstWhere((e) => e.name == property.propertyType),
      contractType: ContractType.values.firstWhere((e) => e.name == property.contractType),
      rent: property.rent,
      totalUnits: property.totalUnits,
      ownerName: property.ownerName,
      ownerPhone: property.ownerPhone,
      ownerEmail: property.ownerEmail,
      defaultBillingItems: billingItems.map((item) => BillingItem(
        name: item.name,
        amount: item.amount,
        isEnabled: item.isEnabled,
      )).toList(),
      units: units.map((unit) => _mapUnit(unit)).toList(),
    );
  }

  Unit _mapUnit(app_db.Unit unit) {
    return Unit(
      id: unit.id,
      propertyId: unit.propertyId,
      unitNumber: unit.unitNumber,
      rentStatus: RentStatusExtension.fromString(unit.rentStatus),
      sizeMeter: unit.sizeMeter,
      sizeKorea: unit.sizeKorea,
      useType: unit.useType,
      description: unit.description,
    );
  }
}

final propertyRepositoryProvider = Provider<PropertyRepository>((ref) {
  final appDatabase = ref.watch(appDatabaseProvider);
  final activityLogService = ref.watch(activityLogServiceProvider);
  return PropertyRepository(appDatabase, activityLogService);
});

final propertyDetailProvider = FutureProvider.autoDispose.family<Property?, String>((ref, id) async {
  final repository = ref.watch(propertyRepositoryProvider);
  return repository.getPropertyById(id);
});

final allUnitsProvider = FutureProvider<List<Unit>>((ref) {
  final repository = ref.watch(propertyRepositoryProvider);
  return repository.getAllUnits();
});

final unitDetailProvider =
    FutureProvider.autoDispose.family<Unit?, String>((ref, id) async {
  final repository = ref.watch(propertyRepositoryProvider);
  return repository.getUnitById(id);
});