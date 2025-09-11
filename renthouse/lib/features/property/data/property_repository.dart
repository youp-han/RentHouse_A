import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:renthouse/core/database/app_database.dart' as app_db;
import 'package:renthouse/core/database/database_provider.dart';
import 'package:renthouse/features/property/domain/property.dart';
import 'package:renthouse/features/property/domain/unit.dart';
import 'package:drift/drift.dart';

class PropertyRepository {
  final app_db.AppDatabase _appDatabase;

  PropertyRepository(this._appDatabase);

  Future<List<Property>> getProperties() async {
    final properties = await _appDatabase.getAllProperties();
    return Future.wait(properties.map((property) async {
      final units = await _appDatabase.getUnitsForProperty(property.id);
      return _mapProperty(property, units);
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
      address: property.address,
      type: property.type,
      rent: property.rent,
      totalFloors: property.totalFloors,
      totalUnits: property.totalUnits,
    ));
    for (var unit in property.units) {
      await addUnit(unit);
    }
    return property;
  }

  Future<Property> updateProperty(Property property) async {
    await _appDatabase.updateProperty(app_db.PropertiesCompanion(
      id: Value(property.id),
      name: Value(property.name),
      address: Value(property.address),
      type: Value(property.type),
      rent: Value(property.rent),
      totalFloors: Value(property.totalFloors),
      totalUnits: Value(property.totalUnits),
    ));
    return property;
  }

  Future<void> deleteProperty(String id) async {
    await _appDatabase.deleteProperty(id);
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

  Property _mapProperty(app_db.Property property, List<app_db.Unit> units) {
    return Property(
      id: property.id,
      name: property.name,
      address: property.address,
      type: property.type,
      rent: property.rent,
      totalFloors: property.totalFloors,
      totalUnits: property.totalUnits,
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
  return PropertyRepository(appDatabase);
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