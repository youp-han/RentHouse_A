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
      return Property(
        id: property.id,
        name: property.name,
        address: property.address,
        type: property.type,
        rent: property.rent,
        totalFloors: property.totalFloors,
        totalUnits: property.totalUnits,
        units: units.map((unit) => Unit(
          id: unit.id,
          propertyId: unit.propertyId,
          unitNumber: unit.unitNumber,
          rentStatus: unit.rentStatus,
          sizeMeter: unit.sizeMeter,
          sizeKorea: unit.sizeKorea,
          useType: unit.useType,
          description: unit.description,
        )).toList(),
      );
    }).toList());
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
      await _appDatabase.insertUnit(app_db.UnitsCompanion.insert(
        id: unit.id,
        propertyId: unit.propertyId,
        unitNumber: unit.unitNumber,
        rentStatus: unit.rentStatus,
        sizeMeter: unit.sizeMeter,
        sizeKorea: unit.sizeKorea,
        useType: unit.useType,
        description: Value(unit.description),
      ));
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

    // Delete existing units and insert new ones for simplicity
    await _appDatabase.deleteUnitsForProperty(property.id);
    for (var unit in property.units) {
      await _appDatabase.insertUnit(app_db.UnitsCompanion.insert(
        id: unit.id,
        propertyId: unit.propertyId,
        unitNumber: unit.unitNumber,
        rentStatus: unit.rentStatus,
        sizeMeter: unit.sizeMeter,
        sizeKorea: unit.sizeKorea,
        useType: unit.useType,
        description: Value(unit.description),
      ));
    }
    return property;
  }

  Future<void> deleteProperty(String id) async {
    await _appDatabase.deleteProperty(id);
  }

  Future<List<Unit>> getAllUnits() async {
    final units = await _appDatabase.getAllUnits();
    return units.map((unit) => Unit(
      id: unit.id,
      propertyId: unit.propertyId,
      unitNumber: unit.unitNumber,
      rentStatus: unit.rentStatus,
      sizeMeter: unit.sizeMeter,
      sizeKorea: unit.sizeKorea,
      useType: unit.useType,
      description: unit.description,
    )).toList();
  }
}

final propertyRepositoryProvider = Provider<PropertyRepository>((ref) {
  final appDatabase = ref.watch(appDatabaseProvider);
  return PropertyRepository(appDatabase);
});

final allUnitsProvider = FutureProvider<List<Unit>>((ref) {
  final repository = ref.watch(propertyRepositoryProvider);
  return repository.getAllUnits();
});