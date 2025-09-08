// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PropertiesTable extends Properties
    with TableInfo<$PropertiesTable, Property> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PropertiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 255,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 255,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rentMeta = const VerificationMeta('rent');
  @override
  late final GeneratedColumn<int> rent = GeneratedColumn<int>(
    'rent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalFloorsMeta = const VerificationMeta(
    'totalFloors',
  );
  @override
  late final GeneratedColumn<int> totalFloors = GeneratedColumn<int>(
    'total_floors',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalUnitsMeta = const VerificationMeta(
    'totalUnits',
  );
  @override
  late final GeneratedColumn<int> totalUnits = GeneratedColumn<int>(
    'total_units',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    address,
    type,
    rent,
    totalFloors,
    totalUnits,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'properties';
  @override
  VerificationContext validateIntegrity(
    Insertable<Property> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('rent')) {
      context.handle(
        _rentMeta,
        rent.isAcceptableOrUnknown(data['rent']!, _rentMeta),
      );
    } else if (isInserting) {
      context.missing(_rentMeta);
    }
    if (data.containsKey('total_floors')) {
      context.handle(
        _totalFloorsMeta,
        totalFloors.isAcceptableOrUnknown(
          data['total_floors']!,
          _totalFloorsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalFloorsMeta);
    }
    if (data.containsKey('total_units')) {
      context.handle(
        _totalUnitsMeta,
        totalUnits.isAcceptableOrUnknown(data['total_units']!, _totalUnitsMeta),
      );
    } else if (isInserting) {
      context.missing(_totalUnitsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Property map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Property(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      rent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rent'],
      )!,
      totalFloors: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_floors'],
      )!,
      totalUnits: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_units'],
      )!,
    );
  }

  @override
  $PropertiesTable createAlias(String alias) {
    return $PropertiesTable(attachedDatabase, alias);
  }
}

class Property extends DataClass implements Insertable<Property> {
  final String id;
  final String name;
  final String address;
  final String type;
  final int rent;
  final int totalFloors;
  final int totalUnits;
  const Property({
    required this.id,
    required this.name,
    required this.address,
    required this.type,
    required this.rent,
    required this.totalFloors,
    required this.totalUnits,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['address'] = Variable<String>(address);
    map['type'] = Variable<String>(type);
    map['rent'] = Variable<int>(rent);
    map['total_floors'] = Variable<int>(totalFloors);
    map['total_units'] = Variable<int>(totalUnits);
    return map;
  }

  PropertiesCompanion toCompanion(bool nullToAbsent) {
    return PropertiesCompanion(
      id: Value(id),
      name: Value(name),
      address: Value(address),
      type: Value(type),
      rent: Value(rent),
      totalFloors: Value(totalFloors),
      totalUnits: Value(totalUnits),
    );
  }

  factory Property.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Property(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      address: serializer.fromJson<String>(json['address']),
      type: serializer.fromJson<String>(json['type']),
      rent: serializer.fromJson<int>(json['rent']),
      totalFloors: serializer.fromJson<int>(json['totalFloors']),
      totalUnits: serializer.fromJson<int>(json['totalUnits']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'address': serializer.toJson<String>(address),
      'type': serializer.toJson<String>(type),
      'rent': serializer.toJson<int>(rent),
      'totalFloors': serializer.toJson<int>(totalFloors),
      'totalUnits': serializer.toJson<int>(totalUnits),
    };
  }

  Property copyWith({
    String? id,
    String? name,
    String? address,
    String? type,
    int? rent,
    int? totalFloors,
    int? totalUnits,
  }) => Property(
    id: id ?? this.id,
    name: name ?? this.name,
    address: address ?? this.address,
    type: type ?? this.type,
    rent: rent ?? this.rent,
    totalFloors: totalFloors ?? this.totalFloors,
    totalUnits: totalUnits ?? this.totalUnits,
  );
  Property copyWithCompanion(PropertiesCompanion data) {
    return Property(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      address: data.address.present ? data.address.value : this.address,
      type: data.type.present ? data.type.value : this.type,
      rent: data.rent.present ? data.rent.value : this.rent,
      totalFloors: data.totalFloors.present
          ? data.totalFloors.value
          : this.totalFloors,
      totalUnits: data.totalUnits.present
          ? data.totalUnits.value
          : this.totalUnits,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Property(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('type: $type, ')
          ..write('rent: $rent, ')
          ..write('totalFloors: $totalFloors, ')
          ..write('totalUnits: $totalUnits')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, address, type, rent, totalFloors, totalUnits);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Property &&
          other.id == this.id &&
          other.name == this.name &&
          other.address == this.address &&
          other.type == this.type &&
          other.rent == this.rent &&
          other.totalFloors == this.totalFloors &&
          other.totalUnits == this.totalUnits);
}

class PropertiesCompanion extends UpdateCompanion<Property> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> address;
  final Value<String> type;
  final Value<int> rent;
  final Value<int> totalFloors;
  final Value<int> totalUnits;
  final Value<int> rowid;
  const PropertiesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.address = const Value.absent(),
    this.type = const Value.absent(),
    this.rent = const Value.absent(),
    this.totalFloors = const Value.absent(),
    this.totalUnits = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PropertiesCompanion.insert({
    required String id,
    required String name,
    required String address,
    required String type,
    required int rent,
    required int totalFloors,
    required int totalUnits,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       address = Value(address),
       type = Value(type),
       rent = Value(rent),
       totalFloors = Value(totalFloors),
       totalUnits = Value(totalUnits);
  static Insertable<Property> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? address,
    Expression<String>? type,
    Expression<int>? rent,
    Expression<int>? totalFloors,
    Expression<int>? totalUnits,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (address != null) 'address': address,
      if (type != null) 'type': type,
      if (rent != null) 'rent': rent,
      if (totalFloors != null) 'total_floors': totalFloors,
      if (totalUnits != null) 'total_units': totalUnits,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PropertiesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? address,
    Value<String>? type,
    Value<int>? rent,
    Value<int>? totalFloors,
    Value<int>? totalUnits,
    Value<int>? rowid,
  }) {
    return PropertiesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      type: type ?? this.type,
      rent: rent ?? this.rent,
      totalFloors: totalFloors ?? this.totalFloors,
      totalUnits: totalUnits ?? this.totalUnits,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (rent.present) {
      map['rent'] = Variable<int>(rent.value);
    }
    if (totalFloors.present) {
      map['total_floors'] = Variable<int>(totalFloors.value);
    }
    if (totalUnits.present) {
      map['total_units'] = Variable<int>(totalUnits.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PropertiesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('type: $type, ')
          ..write('rent: $rent, ')
          ..write('totalFloors: $totalFloors, ')
          ..write('totalUnits: $totalUnits, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UnitsTable extends Units with TableInfo<$UnitsTable, Unit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UnitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _propertyIdMeta = const VerificationMeta(
    'propertyId',
  );
  @override
  late final GeneratedColumn<String> propertyId = GeneratedColumn<String>(
    'property_id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES properties (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _unitNumberMeta = const VerificationMeta(
    'unitNumber',
  );
  @override
  late final GeneratedColumn<String> unitNumber = GeneratedColumn<String>(
    'unit_number',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rentStatusMeta = const VerificationMeta(
    'rentStatus',
  );
  @override
  late final GeneratedColumn<String> rentStatus = GeneratedColumn<String>(
    'rent_status',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sizeMeterMeta = const VerificationMeta(
    'sizeMeter',
  );
  @override
  late final GeneratedColumn<double> sizeMeter = GeneratedColumn<double>(
    'size_meter',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sizeKoreaMeta = const VerificationMeta(
    'sizeKorea',
  );
  @override
  late final GeneratedColumn<double> sizeKorea = GeneratedColumn<double>(
    'size_korea',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _useTypeMeta = const VerificationMeta(
    'useType',
  );
  @override
  late final GeneratedColumn<String> useType = GeneratedColumn<String>(
    'use_type',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    propertyId,
    unitNumber,
    rentStatus,
    sizeMeter,
    sizeKorea,
    useType,
    description,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'units';
  @override
  VerificationContext validateIntegrity(
    Insertable<Unit> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('property_id')) {
      context.handle(
        _propertyIdMeta,
        propertyId.isAcceptableOrUnknown(data['property_id']!, _propertyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_propertyIdMeta);
    }
    if (data.containsKey('unit_number')) {
      context.handle(
        _unitNumberMeta,
        unitNumber.isAcceptableOrUnknown(data['unit_number']!, _unitNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_unitNumberMeta);
    }
    if (data.containsKey('rent_status')) {
      context.handle(
        _rentStatusMeta,
        rentStatus.isAcceptableOrUnknown(data['rent_status']!, _rentStatusMeta),
      );
    } else if (isInserting) {
      context.missing(_rentStatusMeta);
    }
    if (data.containsKey('size_meter')) {
      context.handle(
        _sizeMeterMeta,
        sizeMeter.isAcceptableOrUnknown(data['size_meter']!, _sizeMeterMeta),
      );
    } else if (isInserting) {
      context.missing(_sizeMeterMeta);
    }
    if (data.containsKey('size_korea')) {
      context.handle(
        _sizeKoreaMeta,
        sizeKorea.isAcceptableOrUnknown(data['size_korea']!, _sizeKoreaMeta),
      );
    } else if (isInserting) {
      context.missing(_sizeKoreaMeta);
    }
    if (data.containsKey('use_type')) {
      context.handle(
        _useTypeMeta,
        useType.isAcceptableOrUnknown(data['use_type']!, _useTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_useTypeMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Unit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Unit(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      propertyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}property_id'],
      )!,
      unitNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit_number'],
      )!,
      rentStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rent_status'],
      )!,
      sizeMeter: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}size_meter'],
      )!,
      sizeKorea: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}size_korea'],
      )!,
      useType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}use_type'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
    );
  }

  @override
  $UnitsTable createAlias(String alias) {
    return $UnitsTable(attachedDatabase, alias);
  }
}

class Unit extends DataClass implements Insertable<Unit> {
  final String id;
  final String propertyId;
  final String unitNumber;
  final String rentStatus;
  final double sizeMeter;
  final double sizeKorea;
  final String useType;
  final String? description;
  const Unit({
    required this.id,
    required this.propertyId,
    required this.unitNumber,
    required this.rentStatus,
    required this.sizeMeter,
    required this.sizeKorea,
    required this.useType,
    this.description,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['property_id'] = Variable<String>(propertyId);
    map['unit_number'] = Variable<String>(unitNumber);
    map['rent_status'] = Variable<String>(rentStatus);
    map['size_meter'] = Variable<double>(sizeMeter);
    map['size_korea'] = Variable<double>(sizeKorea);
    map['use_type'] = Variable<String>(useType);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    return map;
  }

  UnitsCompanion toCompanion(bool nullToAbsent) {
    return UnitsCompanion(
      id: Value(id),
      propertyId: Value(propertyId),
      unitNumber: Value(unitNumber),
      rentStatus: Value(rentStatus),
      sizeMeter: Value(sizeMeter),
      sizeKorea: Value(sizeKorea),
      useType: Value(useType),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
    );
  }

  factory Unit.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Unit(
      id: serializer.fromJson<String>(json['id']),
      propertyId: serializer.fromJson<String>(json['propertyId']),
      unitNumber: serializer.fromJson<String>(json['unitNumber']),
      rentStatus: serializer.fromJson<String>(json['rentStatus']),
      sizeMeter: serializer.fromJson<double>(json['sizeMeter']),
      sizeKorea: serializer.fromJson<double>(json['sizeKorea']),
      useType: serializer.fromJson<String>(json['useType']),
      description: serializer.fromJson<String?>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'propertyId': serializer.toJson<String>(propertyId),
      'unitNumber': serializer.toJson<String>(unitNumber),
      'rentStatus': serializer.toJson<String>(rentStatus),
      'sizeMeter': serializer.toJson<double>(sizeMeter),
      'sizeKorea': serializer.toJson<double>(sizeKorea),
      'useType': serializer.toJson<String>(useType),
      'description': serializer.toJson<String?>(description),
    };
  }

  Unit copyWith({
    String? id,
    String? propertyId,
    String? unitNumber,
    String? rentStatus,
    double? sizeMeter,
    double? sizeKorea,
    String? useType,
    Value<String?> description = const Value.absent(),
  }) => Unit(
    id: id ?? this.id,
    propertyId: propertyId ?? this.propertyId,
    unitNumber: unitNumber ?? this.unitNumber,
    rentStatus: rentStatus ?? this.rentStatus,
    sizeMeter: sizeMeter ?? this.sizeMeter,
    sizeKorea: sizeKorea ?? this.sizeKorea,
    useType: useType ?? this.useType,
    description: description.present ? description.value : this.description,
  );
  Unit copyWithCompanion(UnitsCompanion data) {
    return Unit(
      id: data.id.present ? data.id.value : this.id,
      propertyId: data.propertyId.present
          ? data.propertyId.value
          : this.propertyId,
      unitNumber: data.unitNumber.present
          ? data.unitNumber.value
          : this.unitNumber,
      rentStatus: data.rentStatus.present
          ? data.rentStatus.value
          : this.rentStatus,
      sizeMeter: data.sizeMeter.present ? data.sizeMeter.value : this.sizeMeter,
      sizeKorea: data.sizeKorea.present ? data.sizeKorea.value : this.sizeKorea,
      useType: data.useType.present ? data.useType.value : this.useType,
      description: data.description.present
          ? data.description.value
          : this.description,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Unit(')
          ..write('id: $id, ')
          ..write('propertyId: $propertyId, ')
          ..write('unitNumber: $unitNumber, ')
          ..write('rentStatus: $rentStatus, ')
          ..write('sizeMeter: $sizeMeter, ')
          ..write('sizeKorea: $sizeKorea, ')
          ..write('useType: $useType, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    propertyId,
    unitNumber,
    rentStatus,
    sizeMeter,
    sizeKorea,
    useType,
    description,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Unit &&
          other.id == this.id &&
          other.propertyId == this.propertyId &&
          other.unitNumber == this.unitNumber &&
          other.rentStatus == this.rentStatus &&
          other.sizeMeter == this.sizeMeter &&
          other.sizeKorea == this.sizeKorea &&
          other.useType == this.useType &&
          other.description == this.description);
}

class UnitsCompanion extends UpdateCompanion<Unit> {
  final Value<String> id;
  final Value<String> propertyId;
  final Value<String> unitNumber;
  final Value<String> rentStatus;
  final Value<double> sizeMeter;
  final Value<double> sizeKorea;
  final Value<String> useType;
  final Value<String?> description;
  final Value<int> rowid;
  const UnitsCompanion({
    this.id = const Value.absent(),
    this.propertyId = const Value.absent(),
    this.unitNumber = const Value.absent(),
    this.rentStatus = const Value.absent(),
    this.sizeMeter = const Value.absent(),
    this.sizeKorea = const Value.absent(),
    this.useType = const Value.absent(),
    this.description = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UnitsCompanion.insert({
    required String id,
    required String propertyId,
    required String unitNumber,
    required String rentStatus,
    required double sizeMeter,
    required double sizeKorea,
    required String useType,
    this.description = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       propertyId = Value(propertyId),
       unitNumber = Value(unitNumber),
       rentStatus = Value(rentStatus),
       sizeMeter = Value(sizeMeter),
       sizeKorea = Value(sizeKorea),
       useType = Value(useType);
  static Insertable<Unit> custom({
    Expression<String>? id,
    Expression<String>? propertyId,
    Expression<String>? unitNumber,
    Expression<String>? rentStatus,
    Expression<double>? sizeMeter,
    Expression<double>? sizeKorea,
    Expression<String>? useType,
    Expression<String>? description,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (propertyId != null) 'property_id': propertyId,
      if (unitNumber != null) 'unit_number': unitNumber,
      if (rentStatus != null) 'rent_status': rentStatus,
      if (sizeMeter != null) 'size_meter': sizeMeter,
      if (sizeKorea != null) 'size_korea': sizeKorea,
      if (useType != null) 'use_type': useType,
      if (description != null) 'description': description,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UnitsCompanion copyWith({
    Value<String>? id,
    Value<String>? propertyId,
    Value<String>? unitNumber,
    Value<String>? rentStatus,
    Value<double>? sizeMeter,
    Value<double>? sizeKorea,
    Value<String>? useType,
    Value<String?>? description,
    Value<int>? rowid,
  }) {
    return UnitsCompanion(
      id: id ?? this.id,
      propertyId: propertyId ?? this.propertyId,
      unitNumber: unitNumber ?? this.unitNumber,
      rentStatus: rentStatus ?? this.rentStatus,
      sizeMeter: sizeMeter ?? this.sizeMeter,
      sizeKorea: sizeKorea ?? this.sizeKorea,
      useType: useType ?? this.useType,
      description: description ?? this.description,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (propertyId.present) {
      map['property_id'] = Variable<String>(propertyId.value);
    }
    if (unitNumber.present) {
      map['unit_number'] = Variable<String>(unitNumber.value);
    }
    if (rentStatus.present) {
      map['rent_status'] = Variable<String>(rentStatus.value);
    }
    if (sizeMeter.present) {
      map['size_meter'] = Variable<double>(sizeMeter.value);
    }
    if (sizeKorea.present) {
      map['size_korea'] = Variable<double>(sizeKorea.value);
    }
    if (useType.present) {
      map['use_type'] = Variable<String>(useType.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UnitsCompanion(')
          ..write('id: $id, ')
          ..write('propertyId: $propertyId, ')
          ..write('unitNumber: $unitNumber, ')
          ..write('rentStatus: $rentStatus, ')
          ..write('sizeMeter: $sizeMeter, ')
          ..write('sizeKorea: $sizeKorea, ')
          ..write('useType: $useType, ')
          ..write('description: $description, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TenantsTable extends Tenants with TableInfo<$TenantsTable, Tenant> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TenantsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 255,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 255,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _socialNoMeta = const VerificationMeta(
    'socialNo',
  );
  @override
  late final GeneratedColumn<String> socialNo = GeneratedColumn<String>(
    'social_no',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currentAddressMeta = const VerificationMeta(
    'currentAddress',
  );
  @override
  late final GeneratedColumn<String> currentAddress = GeneratedColumn<String>(
    'current_address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    phone,
    email,
    socialNo,
    currentAddress,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tenants';
  @override
  VerificationContext validateIntegrity(
    Insertable<Tenant> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    } else if (isInserting) {
      context.missing(_phoneMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('social_no')) {
      context.handle(
        _socialNoMeta,
        socialNo.isAcceptableOrUnknown(data['social_no']!, _socialNoMeta),
      );
    }
    if (data.containsKey('current_address')) {
      context.handle(
        _currentAddressMeta,
        currentAddress.isAcceptableOrUnknown(
          data['current_address']!,
          _currentAddressMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Tenant map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tenant(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      socialNo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}social_no'],
      ),
      currentAddress: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}current_address'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TenantsTable createAlias(String alias) {
    return $TenantsTable(attachedDatabase, alias);
  }
}

class Tenant extends DataClass implements Insertable<Tenant> {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String? socialNo;
  final String? currentAddress;
  final DateTime createdAt;
  const Tenant({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.socialNo,
    this.currentAddress,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['phone'] = Variable<String>(phone);
    map['email'] = Variable<String>(email);
    if (!nullToAbsent || socialNo != null) {
      map['social_no'] = Variable<String>(socialNo);
    }
    if (!nullToAbsent || currentAddress != null) {
      map['current_address'] = Variable<String>(currentAddress);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TenantsCompanion toCompanion(bool nullToAbsent) {
    return TenantsCompanion(
      id: Value(id),
      name: Value(name),
      phone: Value(phone),
      email: Value(email),
      socialNo: socialNo == null && nullToAbsent
          ? const Value.absent()
          : Value(socialNo),
      currentAddress: currentAddress == null && nullToAbsent
          ? const Value.absent()
          : Value(currentAddress),
      createdAt: Value(createdAt),
    );
  }

  factory Tenant.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tenant(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String>(json['phone']),
      email: serializer.fromJson<String>(json['email']),
      socialNo: serializer.fromJson<String?>(json['socialNo']),
      currentAddress: serializer.fromJson<String?>(json['currentAddress']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String>(phone),
      'email': serializer.toJson<String>(email),
      'socialNo': serializer.toJson<String?>(socialNo),
      'currentAddress': serializer.toJson<String?>(currentAddress),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Tenant copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    Value<String?> socialNo = const Value.absent(),
    Value<String?> currentAddress = const Value.absent(),
    DateTime? createdAt,
  }) => Tenant(
    id: id ?? this.id,
    name: name ?? this.name,
    phone: phone ?? this.phone,
    email: email ?? this.email,
    socialNo: socialNo.present ? socialNo.value : this.socialNo,
    currentAddress: currentAddress.present
        ? currentAddress.value
        : this.currentAddress,
    createdAt: createdAt ?? this.createdAt,
  );
  Tenant copyWithCompanion(TenantsCompanion data) {
    return Tenant(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      socialNo: data.socialNo.present ? data.socialNo.value : this.socialNo,
      currentAddress: data.currentAddress.present
          ? data.currentAddress.value
          : this.currentAddress,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tenant(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('socialNo: $socialNo, ')
          ..write('currentAddress: $currentAddress, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, phone, email, socialNo, currentAddress, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tenant &&
          other.id == this.id &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.socialNo == this.socialNo &&
          other.currentAddress == this.currentAddress &&
          other.createdAt == this.createdAt);
}

class TenantsCompanion extends UpdateCompanion<Tenant> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> phone;
  final Value<String> email;
  final Value<String?> socialNo;
  final Value<String?> currentAddress;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const TenantsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.socialNo = const Value.absent(),
    this.currentAddress = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TenantsCompanion.insert({
    required String id,
    required String name,
    required String phone,
    required String email,
    this.socialNo = const Value.absent(),
    this.currentAddress = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       phone = Value(phone),
       email = Value(email),
       createdAt = Value(createdAt);
  static Insertable<Tenant> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? socialNo,
    Expression<String>? currentAddress,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (socialNo != null) 'social_no': socialNo,
      if (currentAddress != null) 'current_address': currentAddress,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TenantsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? phone,
    Value<String>? email,
    Value<String?>? socialNo,
    Value<String?>? currentAddress,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return TenantsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      socialNo: socialNo ?? this.socialNo,
      currentAddress: currentAddress ?? this.currentAddress,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (socialNo.present) {
      map['social_no'] = Variable<String>(socialNo.value);
    }
    if (currentAddress.present) {
      map['current_address'] = Variable<String>(currentAddress.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TenantsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('socialNo: $socialNo, ')
          ..write('currentAddress: $currentAddress, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LeasesTable extends Leases with TableInfo<$LeasesTable, Lease> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LeasesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tenantIdMeta = const VerificationMeta(
    'tenantId',
  );
  @override
  late final GeneratedColumn<String> tenantId = GeneratedColumn<String>(
    'tenant_id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tenants (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _unitIdMeta = const VerificationMeta('unitId');
  @override
  late final GeneratedColumn<String> unitId = GeneratedColumn<String>(
    'unit_id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES units (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _depositMeta = const VerificationMeta(
    'deposit',
  );
  @override
  late final GeneratedColumn<int> deposit = GeneratedColumn<int>(
    'deposit',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _monthlyRentMeta = const VerificationMeta(
    'monthlyRent',
  );
  @override
  late final GeneratedColumn<int> monthlyRent = GeneratedColumn<int>(
    'monthly_rent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _leaseTypeMeta = const VerificationMeta(
    'leaseType',
  );
  @override
  late final GeneratedColumn<String> leaseType = GeneratedColumn<String>(
    'lease_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _leaseStatusMeta = const VerificationMeta(
    'leaseStatus',
  );
  @override
  late final GeneratedColumn<String> leaseStatus = GeneratedColumn<String>(
    'lease_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contractNotesMeta = const VerificationMeta(
    'contractNotes',
  );
  @override
  late final GeneratedColumn<String> contractNotes = GeneratedColumn<String>(
    'contract_notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tenantId,
    unitId,
    startDate,
    endDate,
    deposit,
    monthlyRent,
    leaseType,
    leaseStatus,
    contractNotes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'leases';
  @override
  VerificationContext validateIntegrity(
    Insertable<Lease> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('tenant_id')) {
      context.handle(
        _tenantIdMeta,
        tenantId.isAcceptableOrUnknown(data['tenant_id']!, _tenantIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tenantIdMeta);
    }
    if (data.containsKey('unit_id')) {
      context.handle(
        _unitIdMeta,
        unitId.isAcceptableOrUnknown(data['unit_id']!, _unitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_unitIdMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    } else if (isInserting) {
      context.missing(_endDateMeta);
    }
    if (data.containsKey('deposit')) {
      context.handle(
        _depositMeta,
        deposit.isAcceptableOrUnknown(data['deposit']!, _depositMeta),
      );
    } else if (isInserting) {
      context.missing(_depositMeta);
    }
    if (data.containsKey('monthly_rent')) {
      context.handle(
        _monthlyRentMeta,
        monthlyRent.isAcceptableOrUnknown(
          data['monthly_rent']!,
          _monthlyRentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_monthlyRentMeta);
    }
    if (data.containsKey('lease_type')) {
      context.handle(
        _leaseTypeMeta,
        leaseType.isAcceptableOrUnknown(data['lease_type']!, _leaseTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_leaseTypeMeta);
    }
    if (data.containsKey('lease_status')) {
      context.handle(
        _leaseStatusMeta,
        leaseStatus.isAcceptableOrUnknown(
          data['lease_status']!,
          _leaseStatusMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_leaseStatusMeta);
    }
    if (data.containsKey('contract_notes')) {
      context.handle(
        _contractNotesMeta,
        contractNotes.isAcceptableOrUnknown(
          data['contract_notes']!,
          _contractNotesMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Lease map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Lease(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tenantId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tenant_id'],
      )!,
      unitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit_id'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      )!,
      deposit: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deposit'],
      )!,
      monthlyRent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}monthly_rent'],
      )!,
      leaseType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lease_type'],
      )!,
      leaseStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lease_status'],
      )!,
      contractNotes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contract_notes'],
      ),
    );
  }

  @override
  $LeasesTable createAlias(String alias) {
    return $LeasesTable(attachedDatabase, alias);
  }
}

class Lease extends DataClass implements Insertable<Lease> {
  final String id;
  final String tenantId;
  final String unitId;
  final DateTime startDate;
  final DateTime endDate;
  final int deposit;
  final int monthlyRent;
  final String leaseType;
  final String leaseStatus;
  final String? contractNotes;
  const Lease({
    required this.id,
    required this.tenantId,
    required this.unitId,
    required this.startDate,
    required this.endDate,
    required this.deposit,
    required this.monthlyRent,
    required this.leaseType,
    required this.leaseStatus,
    this.contractNotes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tenant_id'] = Variable<String>(tenantId);
    map['unit_id'] = Variable<String>(unitId);
    map['start_date'] = Variable<DateTime>(startDate);
    map['end_date'] = Variable<DateTime>(endDate);
    map['deposit'] = Variable<int>(deposit);
    map['monthly_rent'] = Variable<int>(monthlyRent);
    map['lease_type'] = Variable<String>(leaseType);
    map['lease_status'] = Variable<String>(leaseStatus);
    if (!nullToAbsent || contractNotes != null) {
      map['contract_notes'] = Variable<String>(contractNotes);
    }
    return map;
  }

  LeasesCompanion toCompanion(bool nullToAbsent) {
    return LeasesCompanion(
      id: Value(id),
      tenantId: Value(tenantId),
      unitId: Value(unitId),
      startDate: Value(startDate),
      endDate: Value(endDate),
      deposit: Value(deposit),
      monthlyRent: Value(monthlyRent),
      leaseType: Value(leaseType),
      leaseStatus: Value(leaseStatus),
      contractNotes: contractNotes == null && nullToAbsent
          ? const Value.absent()
          : Value(contractNotes),
    );
  }

  factory Lease.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Lease(
      id: serializer.fromJson<String>(json['id']),
      tenantId: serializer.fromJson<String>(json['tenantId']),
      unitId: serializer.fromJson<String>(json['unitId']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
      deposit: serializer.fromJson<int>(json['deposit']),
      monthlyRent: serializer.fromJson<int>(json['monthlyRent']),
      leaseType: serializer.fromJson<String>(json['leaseType']),
      leaseStatus: serializer.fromJson<String>(json['leaseStatus']),
      contractNotes: serializer.fromJson<String?>(json['contractNotes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tenantId': serializer.toJson<String>(tenantId),
      'unitId': serializer.toJson<String>(unitId),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime>(endDate),
      'deposit': serializer.toJson<int>(deposit),
      'monthlyRent': serializer.toJson<int>(monthlyRent),
      'leaseType': serializer.toJson<String>(leaseType),
      'leaseStatus': serializer.toJson<String>(leaseStatus),
      'contractNotes': serializer.toJson<String?>(contractNotes),
    };
  }

  Lease copyWith({
    String? id,
    String? tenantId,
    String? unitId,
    DateTime? startDate,
    DateTime? endDate,
    int? deposit,
    int? monthlyRent,
    String? leaseType,
    String? leaseStatus,
    Value<String?> contractNotes = const Value.absent(),
  }) => Lease(
    id: id ?? this.id,
    tenantId: tenantId ?? this.tenantId,
    unitId: unitId ?? this.unitId,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    deposit: deposit ?? this.deposit,
    monthlyRent: monthlyRent ?? this.monthlyRent,
    leaseType: leaseType ?? this.leaseType,
    leaseStatus: leaseStatus ?? this.leaseStatus,
    contractNotes: contractNotes.present
        ? contractNotes.value
        : this.contractNotes,
  );
  Lease copyWithCompanion(LeasesCompanion data) {
    return Lease(
      id: data.id.present ? data.id.value : this.id,
      tenantId: data.tenantId.present ? data.tenantId.value : this.tenantId,
      unitId: data.unitId.present ? data.unitId.value : this.unitId,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      deposit: data.deposit.present ? data.deposit.value : this.deposit,
      monthlyRent: data.monthlyRent.present
          ? data.monthlyRent.value
          : this.monthlyRent,
      leaseType: data.leaseType.present ? data.leaseType.value : this.leaseType,
      leaseStatus: data.leaseStatus.present
          ? data.leaseStatus.value
          : this.leaseStatus,
      contractNotes: data.contractNotes.present
          ? data.contractNotes.value
          : this.contractNotes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Lease(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('unitId: $unitId, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('deposit: $deposit, ')
          ..write('monthlyRent: $monthlyRent, ')
          ..write('leaseType: $leaseType, ')
          ..write('leaseStatus: $leaseStatus, ')
          ..write('contractNotes: $contractNotes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tenantId,
    unitId,
    startDate,
    endDate,
    deposit,
    monthlyRent,
    leaseType,
    leaseStatus,
    contractNotes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Lease &&
          other.id == this.id &&
          other.tenantId == this.tenantId &&
          other.unitId == this.unitId &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.deposit == this.deposit &&
          other.monthlyRent == this.monthlyRent &&
          other.leaseType == this.leaseType &&
          other.leaseStatus == this.leaseStatus &&
          other.contractNotes == this.contractNotes);
}

class LeasesCompanion extends UpdateCompanion<Lease> {
  final Value<String> id;
  final Value<String> tenantId;
  final Value<String> unitId;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  final Value<int> deposit;
  final Value<int> monthlyRent;
  final Value<String> leaseType;
  final Value<String> leaseStatus;
  final Value<String?> contractNotes;
  final Value<int> rowid;
  const LeasesCompanion({
    this.id = const Value.absent(),
    this.tenantId = const Value.absent(),
    this.unitId = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.deposit = const Value.absent(),
    this.monthlyRent = const Value.absent(),
    this.leaseType = const Value.absent(),
    this.leaseStatus = const Value.absent(),
    this.contractNotes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LeasesCompanion.insert({
    required String id,
    required String tenantId,
    required String unitId,
    required DateTime startDate,
    required DateTime endDate,
    required int deposit,
    required int monthlyRent,
    required String leaseType,
    required String leaseStatus,
    this.contractNotes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tenantId = Value(tenantId),
       unitId = Value(unitId),
       startDate = Value(startDate),
       endDate = Value(endDate),
       deposit = Value(deposit),
       monthlyRent = Value(monthlyRent),
       leaseType = Value(leaseType),
       leaseStatus = Value(leaseStatus);
  static Insertable<Lease> custom({
    Expression<String>? id,
    Expression<String>? tenantId,
    Expression<String>? unitId,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<int>? deposit,
    Expression<int>? monthlyRent,
    Expression<String>? leaseType,
    Expression<String>? leaseStatus,
    Expression<String>? contractNotes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tenantId != null) 'tenant_id': tenantId,
      if (unitId != null) 'unit_id': unitId,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (deposit != null) 'deposit': deposit,
      if (monthlyRent != null) 'monthly_rent': monthlyRent,
      if (leaseType != null) 'lease_type': leaseType,
      if (leaseStatus != null) 'lease_status': leaseStatus,
      if (contractNotes != null) 'contract_notes': contractNotes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LeasesCompanion copyWith({
    Value<String>? id,
    Value<String>? tenantId,
    Value<String>? unitId,
    Value<DateTime>? startDate,
    Value<DateTime>? endDate,
    Value<int>? deposit,
    Value<int>? monthlyRent,
    Value<String>? leaseType,
    Value<String>? leaseStatus,
    Value<String?>? contractNotes,
    Value<int>? rowid,
  }) {
    return LeasesCompanion(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      unitId: unitId ?? this.unitId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      deposit: deposit ?? this.deposit,
      monthlyRent: monthlyRent ?? this.monthlyRent,
      leaseType: leaseType ?? this.leaseType,
      leaseStatus: leaseStatus ?? this.leaseStatus,
      contractNotes: contractNotes ?? this.contractNotes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tenantId.present) {
      map['tenant_id'] = Variable<String>(tenantId.value);
    }
    if (unitId.present) {
      map['unit_id'] = Variable<String>(unitId.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (deposit.present) {
      map['deposit'] = Variable<int>(deposit.value);
    }
    if (monthlyRent.present) {
      map['monthly_rent'] = Variable<int>(monthlyRent.value);
    }
    if (leaseType.present) {
      map['lease_type'] = Variable<String>(leaseType.value);
    }
    if (leaseStatus.present) {
      map['lease_status'] = Variable<String>(leaseStatus.value);
    }
    if (contractNotes.present) {
      map['contract_notes'] = Variable<String>(contractNotes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LeasesCompanion(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('unitId: $unitId, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('deposit: $deposit, ')
          ..write('monthlyRent: $monthlyRent, ')
          ..write('leaseType: $leaseType, ')
          ..write('leaseStatus: $leaseStatus, ')
          ..write('contractNotes: $contractNotes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BillTemplatesTable extends BillTemplates
    with TableInfo<$BillTemplatesTable, BillTemplate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BillTemplatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 255,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    category,
    amount,
    description,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bill_templates';
  @override
  VerificationContext validateIntegrity(
    Insertable<BillTemplate> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BillTemplate map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BillTemplate(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
    );
  }

  @override
  $BillTemplatesTable createAlias(String alias) {
    return $BillTemplatesTable(attachedDatabase, alias);
  }
}

class BillTemplate extends DataClass implements Insertable<BillTemplate> {
  final String id;
  final String name;
  final String category;
  final int amount;
  final String? description;
  const BillTemplate({
    required this.id,
    required this.name,
    required this.category,
    required this.amount,
    this.description,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['category'] = Variable<String>(category);
    map['amount'] = Variable<int>(amount);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    return map;
  }

  BillTemplatesCompanion toCompanion(bool nullToAbsent) {
    return BillTemplatesCompanion(
      id: Value(id),
      name: Value(name),
      category: Value(category),
      amount: Value(amount),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
    );
  }

  factory BillTemplate.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BillTemplate(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String>(json['category']),
      amount: serializer.fromJson<int>(json['amount']),
      description: serializer.fromJson<String?>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String>(category),
      'amount': serializer.toJson<int>(amount),
      'description': serializer.toJson<String?>(description),
    };
  }

  BillTemplate copyWith({
    String? id,
    String? name,
    String? category,
    int? amount,
    Value<String?> description = const Value.absent(),
  }) => BillTemplate(
    id: id ?? this.id,
    name: name ?? this.name,
    category: category ?? this.category,
    amount: amount ?? this.amount,
    description: description.present ? description.value : this.description,
  );
  BillTemplate copyWithCompanion(BillTemplatesCompanion data) {
    return BillTemplate(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      amount: data.amount.present ? data.amount.value : this.amount,
      description: data.description.present
          ? data.description.value
          : this.description,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BillTemplate(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('amount: $amount, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, category, amount, description);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BillTemplate &&
          other.id == this.id &&
          other.name == this.name &&
          other.category == this.category &&
          other.amount == this.amount &&
          other.description == this.description);
}

class BillTemplatesCompanion extends UpdateCompanion<BillTemplate> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> category;
  final Value<int> amount;
  final Value<String?> description;
  final Value<int> rowid;
  const BillTemplatesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.amount = const Value.absent(),
    this.description = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BillTemplatesCompanion.insert({
    required String id,
    required String name,
    required String category,
    required int amount,
    this.description = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       category = Value(category),
       amount = Value(amount);
  static Insertable<BillTemplate> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? category,
    Expression<int>? amount,
    Expression<String>? description,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (amount != null) 'amount': amount,
      if (description != null) 'description': description,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BillTemplatesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? category,
    Value<int>? amount,
    Value<String?>? description,
    Value<int>? rowid,
  }) {
    return BillTemplatesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BillTemplatesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('amount: $amount, ')
          ..write('description: $description, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BillingsTable extends Billings with TableInfo<$BillingsTable, Billing> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BillingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _leaseIdMeta = const VerificationMeta(
    'leaseId',
  );
  @override
  late final GeneratedColumn<String> leaseId = GeneratedColumn<String>(
    'lease_id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES leases (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _yearMonthMeta = const VerificationMeta(
    'yearMonth',
  );
  @override
  late final GeneratedColumn<String> yearMonth = GeneratedColumn<String>(
    'year_month',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 7,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _issueDateMeta = const VerificationMeta(
    'issueDate',
  );
  @override
  late final GeneratedColumn<DateTime> issueDate = GeneratedColumn<DateTime>(
    'issue_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
    'due_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paidMeta = const VerificationMeta('paid');
  @override
  late final GeneratedColumn<bool> paid = GeneratedColumn<bool>(
    'paid',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("paid" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _paidDateMeta = const VerificationMeta(
    'paidDate',
  );
  @override
  late final GeneratedColumn<DateTime> paidDate = GeneratedColumn<DateTime>(
    'paid_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalAmountMeta = const VerificationMeta(
    'totalAmount',
  );
  @override
  late final GeneratedColumn<int> totalAmount = GeneratedColumn<int>(
    'total_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    leaseId,
    yearMonth,
    issueDate,
    dueDate,
    paid,
    paidDate,
    totalAmount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'billings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Billing> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('lease_id')) {
      context.handle(
        _leaseIdMeta,
        leaseId.isAcceptableOrUnknown(data['lease_id']!, _leaseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_leaseIdMeta);
    }
    if (data.containsKey('year_month')) {
      context.handle(
        _yearMonthMeta,
        yearMonth.isAcceptableOrUnknown(data['year_month']!, _yearMonthMeta),
      );
    } else if (isInserting) {
      context.missing(_yearMonthMeta);
    }
    if (data.containsKey('issue_date')) {
      context.handle(
        _issueDateMeta,
        issueDate.isAcceptableOrUnknown(data['issue_date']!, _issueDateMeta),
      );
    } else if (isInserting) {
      context.missing(_issueDateMeta);
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    } else if (isInserting) {
      context.missing(_dueDateMeta);
    }
    if (data.containsKey('paid')) {
      context.handle(
        _paidMeta,
        paid.isAcceptableOrUnknown(data['paid']!, _paidMeta),
      );
    }
    if (data.containsKey('paid_date')) {
      context.handle(
        _paidDateMeta,
        paidDate.isAcceptableOrUnknown(data['paid_date']!, _paidDateMeta),
      );
    }
    if (data.containsKey('total_amount')) {
      context.handle(
        _totalAmountMeta,
        totalAmount.isAcceptableOrUnknown(
          data['total_amount']!,
          _totalAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalAmountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Billing map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Billing(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      leaseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lease_id'],
      )!,
      yearMonth: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}year_month'],
      )!,
      issueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}issue_date'],
      )!,
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date'],
      )!,
      paid: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}paid'],
      )!,
      paidDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}paid_date'],
      ),
      totalAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_amount'],
      )!,
    );
  }

  @override
  $BillingsTable createAlias(String alias) {
    return $BillingsTable(attachedDatabase, alias);
  }
}

class Billing extends DataClass implements Insertable<Billing> {
  final String id;
  final String leaseId;
  final String yearMonth;
  final DateTime issueDate;
  final DateTime dueDate;
  final bool paid;
  final DateTime? paidDate;
  final int totalAmount;
  const Billing({
    required this.id,
    required this.leaseId,
    required this.yearMonth,
    required this.issueDate,
    required this.dueDate,
    required this.paid,
    this.paidDate,
    required this.totalAmount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['lease_id'] = Variable<String>(leaseId);
    map['year_month'] = Variable<String>(yearMonth);
    map['issue_date'] = Variable<DateTime>(issueDate);
    map['due_date'] = Variable<DateTime>(dueDate);
    map['paid'] = Variable<bool>(paid);
    if (!nullToAbsent || paidDate != null) {
      map['paid_date'] = Variable<DateTime>(paidDate);
    }
    map['total_amount'] = Variable<int>(totalAmount);
    return map;
  }

  BillingsCompanion toCompanion(bool nullToAbsent) {
    return BillingsCompanion(
      id: Value(id),
      leaseId: Value(leaseId),
      yearMonth: Value(yearMonth),
      issueDate: Value(issueDate),
      dueDate: Value(dueDate),
      paid: Value(paid),
      paidDate: paidDate == null && nullToAbsent
          ? const Value.absent()
          : Value(paidDate),
      totalAmount: Value(totalAmount),
    );
  }

  factory Billing.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Billing(
      id: serializer.fromJson<String>(json['id']),
      leaseId: serializer.fromJson<String>(json['leaseId']),
      yearMonth: serializer.fromJson<String>(json['yearMonth']),
      issueDate: serializer.fromJson<DateTime>(json['issueDate']),
      dueDate: serializer.fromJson<DateTime>(json['dueDate']),
      paid: serializer.fromJson<bool>(json['paid']),
      paidDate: serializer.fromJson<DateTime?>(json['paidDate']),
      totalAmount: serializer.fromJson<int>(json['totalAmount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'leaseId': serializer.toJson<String>(leaseId),
      'yearMonth': serializer.toJson<String>(yearMonth),
      'issueDate': serializer.toJson<DateTime>(issueDate),
      'dueDate': serializer.toJson<DateTime>(dueDate),
      'paid': serializer.toJson<bool>(paid),
      'paidDate': serializer.toJson<DateTime?>(paidDate),
      'totalAmount': serializer.toJson<int>(totalAmount),
    };
  }

  Billing copyWith({
    String? id,
    String? leaseId,
    String? yearMonth,
    DateTime? issueDate,
    DateTime? dueDate,
    bool? paid,
    Value<DateTime?> paidDate = const Value.absent(),
    int? totalAmount,
  }) => Billing(
    id: id ?? this.id,
    leaseId: leaseId ?? this.leaseId,
    yearMonth: yearMonth ?? this.yearMonth,
    issueDate: issueDate ?? this.issueDate,
    dueDate: dueDate ?? this.dueDate,
    paid: paid ?? this.paid,
    paidDate: paidDate.present ? paidDate.value : this.paidDate,
    totalAmount: totalAmount ?? this.totalAmount,
  );
  Billing copyWithCompanion(BillingsCompanion data) {
    return Billing(
      id: data.id.present ? data.id.value : this.id,
      leaseId: data.leaseId.present ? data.leaseId.value : this.leaseId,
      yearMonth: data.yearMonth.present ? data.yearMonth.value : this.yearMonth,
      issueDate: data.issueDate.present ? data.issueDate.value : this.issueDate,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      paid: data.paid.present ? data.paid.value : this.paid,
      paidDate: data.paidDate.present ? data.paidDate.value : this.paidDate,
      totalAmount: data.totalAmount.present
          ? data.totalAmount.value
          : this.totalAmount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Billing(')
          ..write('id: $id, ')
          ..write('leaseId: $leaseId, ')
          ..write('yearMonth: $yearMonth, ')
          ..write('issueDate: $issueDate, ')
          ..write('dueDate: $dueDate, ')
          ..write('paid: $paid, ')
          ..write('paidDate: $paidDate, ')
          ..write('totalAmount: $totalAmount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    leaseId,
    yearMonth,
    issueDate,
    dueDate,
    paid,
    paidDate,
    totalAmount,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Billing &&
          other.id == this.id &&
          other.leaseId == this.leaseId &&
          other.yearMonth == this.yearMonth &&
          other.issueDate == this.issueDate &&
          other.dueDate == this.dueDate &&
          other.paid == this.paid &&
          other.paidDate == this.paidDate &&
          other.totalAmount == this.totalAmount);
}

class BillingsCompanion extends UpdateCompanion<Billing> {
  final Value<String> id;
  final Value<String> leaseId;
  final Value<String> yearMonth;
  final Value<DateTime> issueDate;
  final Value<DateTime> dueDate;
  final Value<bool> paid;
  final Value<DateTime?> paidDate;
  final Value<int> totalAmount;
  final Value<int> rowid;
  const BillingsCompanion({
    this.id = const Value.absent(),
    this.leaseId = const Value.absent(),
    this.yearMonth = const Value.absent(),
    this.issueDate = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.paid = const Value.absent(),
    this.paidDate = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BillingsCompanion.insert({
    required String id,
    required String leaseId,
    required String yearMonth,
    required DateTime issueDate,
    required DateTime dueDate,
    this.paid = const Value.absent(),
    this.paidDate = const Value.absent(),
    required int totalAmount,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       leaseId = Value(leaseId),
       yearMonth = Value(yearMonth),
       issueDate = Value(issueDate),
       dueDate = Value(dueDate),
       totalAmount = Value(totalAmount);
  static Insertable<Billing> custom({
    Expression<String>? id,
    Expression<String>? leaseId,
    Expression<String>? yearMonth,
    Expression<DateTime>? issueDate,
    Expression<DateTime>? dueDate,
    Expression<bool>? paid,
    Expression<DateTime>? paidDate,
    Expression<int>? totalAmount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (leaseId != null) 'lease_id': leaseId,
      if (yearMonth != null) 'year_month': yearMonth,
      if (issueDate != null) 'issue_date': issueDate,
      if (dueDate != null) 'due_date': dueDate,
      if (paid != null) 'paid': paid,
      if (paidDate != null) 'paid_date': paidDate,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BillingsCompanion copyWith({
    Value<String>? id,
    Value<String>? leaseId,
    Value<String>? yearMonth,
    Value<DateTime>? issueDate,
    Value<DateTime>? dueDate,
    Value<bool>? paid,
    Value<DateTime?>? paidDate,
    Value<int>? totalAmount,
    Value<int>? rowid,
  }) {
    return BillingsCompanion(
      id: id ?? this.id,
      leaseId: leaseId ?? this.leaseId,
      yearMonth: yearMonth ?? this.yearMonth,
      issueDate: issueDate ?? this.issueDate,
      dueDate: dueDate ?? this.dueDate,
      paid: paid ?? this.paid,
      paidDate: paidDate ?? this.paidDate,
      totalAmount: totalAmount ?? this.totalAmount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (leaseId.present) {
      map['lease_id'] = Variable<String>(leaseId.value);
    }
    if (yearMonth.present) {
      map['year_month'] = Variable<String>(yearMonth.value);
    }
    if (issueDate.present) {
      map['issue_date'] = Variable<DateTime>(issueDate.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (paid.present) {
      map['paid'] = Variable<bool>(paid.value);
    }
    if (paidDate.present) {
      map['paid_date'] = Variable<DateTime>(paidDate.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<int>(totalAmount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BillingsCompanion(')
          ..write('id: $id, ')
          ..write('leaseId: $leaseId, ')
          ..write('yearMonth: $yearMonth, ')
          ..write('issueDate: $issueDate, ')
          ..write('dueDate: $dueDate, ')
          ..write('paid: $paid, ')
          ..write('paidDate: $paidDate, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BillingItemsTable extends BillingItems
    with TableInfo<$BillingItemsTable, BillingItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BillingItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _billingIdMeta = const VerificationMeta(
    'billingId',
  );
  @override
  late final GeneratedColumn<String> billingId = GeneratedColumn<String>(
    'billing_id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES billings (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _billTemplateIdMeta = const VerificationMeta(
    'billTemplateId',
  );
  @override
  late final GeneratedColumn<String> billTemplateId = GeneratedColumn<String>(
    'bill_template_id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES bill_templates (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, billingId, billTemplateId, amount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'billing_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<BillingItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('billing_id')) {
      context.handle(
        _billingIdMeta,
        billingId.isAcceptableOrUnknown(data['billing_id']!, _billingIdMeta),
      );
    } else if (isInserting) {
      context.missing(_billingIdMeta);
    }
    if (data.containsKey('bill_template_id')) {
      context.handle(
        _billTemplateIdMeta,
        billTemplateId.isAcceptableOrUnknown(
          data['bill_template_id']!,
          _billTemplateIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_billTemplateIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BillingItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BillingItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      billingId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}billing_id'],
      )!,
      billTemplateId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bill_template_id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
    );
  }

  @override
  $BillingItemsTable createAlias(String alias) {
    return $BillingItemsTable(attachedDatabase, alias);
  }
}

class BillingItem extends DataClass implements Insertable<BillingItem> {
  final String id;
  final String billingId;
  final String billTemplateId;
  final int amount;
  const BillingItem({
    required this.id,
    required this.billingId,
    required this.billTemplateId,
    required this.amount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['billing_id'] = Variable<String>(billingId);
    map['bill_template_id'] = Variable<String>(billTemplateId);
    map['amount'] = Variable<int>(amount);
    return map;
  }

  BillingItemsCompanion toCompanion(bool nullToAbsent) {
    return BillingItemsCompanion(
      id: Value(id),
      billingId: Value(billingId),
      billTemplateId: Value(billTemplateId),
      amount: Value(amount),
    );
  }

  factory BillingItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BillingItem(
      id: serializer.fromJson<String>(json['id']),
      billingId: serializer.fromJson<String>(json['billingId']),
      billTemplateId: serializer.fromJson<String>(json['billTemplateId']),
      amount: serializer.fromJson<int>(json['amount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'billingId': serializer.toJson<String>(billingId),
      'billTemplateId': serializer.toJson<String>(billTemplateId),
      'amount': serializer.toJson<int>(amount),
    };
  }

  BillingItem copyWith({
    String? id,
    String? billingId,
    String? billTemplateId,
    int? amount,
  }) => BillingItem(
    id: id ?? this.id,
    billingId: billingId ?? this.billingId,
    billTemplateId: billTemplateId ?? this.billTemplateId,
    amount: amount ?? this.amount,
  );
  BillingItem copyWithCompanion(BillingItemsCompanion data) {
    return BillingItem(
      id: data.id.present ? data.id.value : this.id,
      billingId: data.billingId.present ? data.billingId.value : this.billingId,
      billTemplateId: data.billTemplateId.present
          ? data.billTemplateId.value
          : this.billTemplateId,
      amount: data.amount.present ? data.amount.value : this.amount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BillingItem(')
          ..write('id: $id, ')
          ..write('billingId: $billingId, ')
          ..write('billTemplateId: $billTemplateId, ')
          ..write('amount: $amount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, billingId, billTemplateId, amount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BillingItem &&
          other.id == this.id &&
          other.billingId == this.billingId &&
          other.billTemplateId == this.billTemplateId &&
          other.amount == this.amount);
}

class BillingItemsCompanion extends UpdateCompanion<BillingItem> {
  final Value<String> id;
  final Value<String> billingId;
  final Value<String> billTemplateId;
  final Value<int> amount;
  final Value<int> rowid;
  const BillingItemsCompanion({
    this.id = const Value.absent(),
    this.billingId = const Value.absent(),
    this.billTemplateId = const Value.absent(),
    this.amount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BillingItemsCompanion.insert({
    required String id,
    required String billingId,
    required String billTemplateId,
    required int amount,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       billingId = Value(billingId),
       billTemplateId = Value(billTemplateId),
       amount = Value(amount);
  static Insertable<BillingItem> custom({
    Expression<String>? id,
    Expression<String>? billingId,
    Expression<String>? billTemplateId,
    Expression<int>? amount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (billingId != null) 'billing_id': billingId,
      if (billTemplateId != null) 'bill_template_id': billTemplateId,
      if (amount != null) 'amount': amount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BillingItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? billingId,
    Value<String>? billTemplateId,
    Value<int>? amount,
    Value<int>? rowid,
  }) {
    return BillingItemsCompanion(
      id: id ?? this.id,
      billingId: billingId ?? this.billingId,
      billTemplateId: billTemplateId ?? this.billTemplateId,
      amount: amount ?? this.amount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (billingId.present) {
      map['billing_id'] = Variable<String>(billingId.value);
    }
    if (billTemplateId.present) {
      map['bill_template_id'] = Variable<String>(billTemplateId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BillingItemsCompanion(')
          ..write('id: $id, ')
          ..write('billingId: $billingId, ')
          ..write('billTemplateId: $billTemplateId, ')
          ..write('amount: $amount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PropertiesTable properties = $PropertiesTable(this);
  late final $UnitsTable units = $UnitsTable(this);
  late final $TenantsTable tenants = $TenantsTable(this);
  late final $LeasesTable leases = $LeasesTable(this);
  late final $BillTemplatesTable billTemplates = $BillTemplatesTable(this);
  late final $BillingsTable billings = $BillingsTable(this);
  late final $BillingItemsTable billingItems = $BillingItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    properties,
    units,
    tenants,
    leases,
    billTemplates,
    billings,
    billingItems,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'properties',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('units', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tenants',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('leases', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'units',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('leases', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'leases',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('billings', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'billings',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('billing_items', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$PropertiesTableCreateCompanionBuilder =
    PropertiesCompanion Function({
      required String id,
      required String name,
      required String address,
      required String type,
      required int rent,
      required int totalFloors,
      required int totalUnits,
      Value<int> rowid,
    });
typedef $$PropertiesTableUpdateCompanionBuilder =
    PropertiesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> address,
      Value<String> type,
      Value<int> rent,
      Value<int> totalFloors,
      Value<int> totalUnits,
      Value<int> rowid,
    });

final class $$PropertiesTableReferences
    extends BaseReferences<_$AppDatabase, $PropertiesTable, Property> {
  $$PropertiesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$UnitsTable, List<Unit>> _unitsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.units,
    aliasName: $_aliasNameGenerator(db.properties.id, db.units.propertyId),
  );

  $$UnitsTableProcessedTableManager get unitsRefs {
    final manager = $$UnitsTableTableManager(
      $_db,
      $_db.units,
    ).filter((f) => f.propertyId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_unitsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PropertiesTableFilterComposer
    extends Composer<_$AppDatabase, $PropertiesTable> {
  $$PropertiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rent => $composableBuilder(
    column: $table.rent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalFloors => $composableBuilder(
    column: $table.totalFloors,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalUnits => $composableBuilder(
    column: $table.totalUnits,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> unitsRefs(
    Expression<bool> Function($$UnitsTableFilterComposer f) f,
  ) {
    final $$UnitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.propertyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnitsTableFilterComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PropertiesTableOrderingComposer
    extends Composer<_$AppDatabase, $PropertiesTable> {
  $$PropertiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rent => $composableBuilder(
    column: $table.rent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalFloors => $composableBuilder(
    column: $table.totalFloors,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalUnits => $composableBuilder(
    column: $table.totalUnits,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PropertiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PropertiesTable> {
  $$PropertiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get rent =>
      $composableBuilder(column: $table.rent, builder: (column) => column);

  GeneratedColumn<int> get totalFloors => $composableBuilder(
    column: $table.totalFloors,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalUnits => $composableBuilder(
    column: $table.totalUnits,
    builder: (column) => column,
  );

  Expression<T> unitsRefs<T extends Object>(
    Expression<T> Function($$UnitsTableAnnotationComposer a) f,
  ) {
    final $$UnitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.propertyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnitsTableAnnotationComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PropertiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PropertiesTable,
          Property,
          $$PropertiesTableFilterComposer,
          $$PropertiesTableOrderingComposer,
          $$PropertiesTableAnnotationComposer,
          $$PropertiesTableCreateCompanionBuilder,
          $$PropertiesTableUpdateCompanionBuilder,
          (Property, $$PropertiesTableReferences),
          Property,
          PrefetchHooks Function({bool unitsRefs})
        > {
  $$PropertiesTableTableManager(_$AppDatabase db, $PropertiesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PropertiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PropertiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PropertiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> rent = const Value.absent(),
                Value<int> totalFloors = const Value.absent(),
                Value<int> totalUnits = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PropertiesCompanion(
                id: id,
                name: name,
                address: address,
                type: type,
                rent: rent,
                totalFloors: totalFloors,
                totalUnits: totalUnits,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String address,
                required String type,
                required int rent,
                required int totalFloors,
                required int totalUnits,
                Value<int> rowid = const Value.absent(),
              }) => PropertiesCompanion.insert(
                id: id,
                name: name,
                address: address,
                type: type,
                rent: rent,
                totalFloors: totalFloors,
                totalUnits: totalUnits,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PropertiesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({unitsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (unitsRefs) db.units],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (unitsRefs)
                    await $_getPrefetchedData<Property, $PropertiesTable, Unit>(
                      currentTable: table,
                      referencedTable: $$PropertiesTableReferences
                          ._unitsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$PropertiesTableReferences(db, table, p0).unitsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.propertyId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PropertiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PropertiesTable,
      Property,
      $$PropertiesTableFilterComposer,
      $$PropertiesTableOrderingComposer,
      $$PropertiesTableAnnotationComposer,
      $$PropertiesTableCreateCompanionBuilder,
      $$PropertiesTableUpdateCompanionBuilder,
      (Property, $$PropertiesTableReferences),
      Property,
      PrefetchHooks Function({bool unitsRefs})
    >;
typedef $$UnitsTableCreateCompanionBuilder =
    UnitsCompanion Function({
      required String id,
      required String propertyId,
      required String unitNumber,
      required String rentStatus,
      required double sizeMeter,
      required double sizeKorea,
      required String useType,
      Value<String?> description,
      Value<int> rowid,
    });
typedef $$UnitsTableUpdateCompanionBuilder =
    UnitsCompanion Function({
      Value<String> id,
      Value<String> propertyId,
      Value<String> unitNumber,
      Value<String> rentStatus,
      Value<double> sizeMeter,
      Value<double> sizeKorea,
      Value<String> useType,
      Value<String?> description,
      Value<int> rowid,
    });

final class $$UnitsTableReferences
    extends BaseReferences<_$AppDatabase, $UnitsTable, Unit> {
  $$UnitsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PropertiesTable _propertyIdTable(_$AppDatabase db) => db.properties
      .createAlias($_aliasNameGenerator(db.units.propertyId, db.properties.id));

  $$PropertiesTableProcessedTableManager get propertyId {
    final $_column = $_itemColumn<String>('property_id')!;

    final manager = $$PropertiesTableTableManager(
      $_db,
      $_db.properties,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_propertyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$LeasesTable, List<Lease>> _leasesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.leases,
    aliasName: $_aliasNameGenerator(db.units.id, db.leases.unitId),
  );

  $$LeasesTableProcessedTableManager get leasesRefs {
    final manager = $$LeasesTableTableManager(
      $_db,
      $_db.leases,
    ).filter((f) => f.unitId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_leasesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$UnitsTableFilterComposer extends Composer<_$AppDatabase, $UnitsTable> {
  $$UnitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unitNumber => $composableBuilder(
    column: $table.unitNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rentStatus => $composableBuilder(
    column: $table.rentStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get sizeMeter => $composableBuilder(
    column: $table.sizeMeter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get sizeKorea => $composableBuilder(
    column: $table.sizeKorea,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get useType => $composableBuilder(
    column: $table.useType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  $$PropertiesTableFilterComposer get propertyId {
    final $$PropertiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.propertyId,
      referencedTable: $db.properties,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PropertiesTableFilterComposer(
            $db: $db,
            $table: $db.properties,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> leasesRefs(
    Expression<bool> Function($$LeasesTableFilterComposer f) f,
  ) {
    final $$LeasesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.leases,
      getReferencedColumn: (t) => t.unitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LeasesTableFilterComposer(
            $db: $db,
            $table: $db.leases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UnitsTableOrderingComposer
    extends Composer<_$AppDatabase, $UnitsTable> {
  $$UnitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unitNumber => $composableBuilder(
    column: $table.unitNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rentStatus => $composableBuilder(
    column: $table.rentStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get sizeMeter => $composableBuilder(
    column: $table.sizeMeter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get sizeKorea => $composableBuilder(
    column: $table.sizeKorea,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get useType => $composableBuilder(
    column: $table.useType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  $$PropertiesTableOrderingComposer get propertyId {
    final $$PropertiesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.propertyId,
      referencedTable: $db.properties,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PropertiesTableOrderingComposer(
            $db: $db,
            $table: $db.properties,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UnitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UnitsTable> {
  $$UnitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get unitNumber => $composableBuilder(
    column: $table.unitNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rentStatus => $composableBuilder(
    column: $table.rentStatus,
    builder: (column) => column,
  );

  GeneratedColumn<double> get sizeMeter =>
      $composableBuilder(column: $table.sizeMeter, builder: (column) => column);

  GeneratedColumn<double> get sizeKorea =>
      $composableBuilder(column: $table.sizeKorea, builder: (column) => column);

  GeneratedColumn<String> get useType =>
      $composableBuilder(column: $table.useType, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  $$PropertiesTableAnnotationComposer get propertyId {
    final $$PropertiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.propertyId,
      referencedTable: $db.properties,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PropertiesTableAnnotationComposer(
            $db: $db,
            $table: $db.properties,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> leasesRefs<T extends Object>(
    Expression<T> Function($$LeasesTableAnnotationComposer a) f,
  ) {
    final $$LeasesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.leases,
      getReferencedColumn: (t) => t.unitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LeasesTableAnnotationComposer(
            $db: $db,
            $table: $db.leases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UnitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UnitsTable,
          Unit,
          $$UnitsTableFilterComposer,
          $$UnitsTableOrderingComposer,
          $$UnitsTableAnnotationComposer,
          $$UnitsTableCreateCompanionBuilder,
          $$UnitsTableUpdateCompanionBuilder,
          (Unit, $$UnitsTableReferences),
          Unit,
          PrefetchHooks Function({bool propertyId, bool leasesRefs})
        > {
  $$UnitsTableTableManager(_$AppDatabase db, $UnitsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UnitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UnitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UnitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> propertyId = const Value.absent(),
                Value<String> unitNumber = const Value.absent(),
                Value<String> rentStatus = const Value.absent(),
                Value<double> sizeMeter = const Value.absent(),
                Value<double> sizeKorea = const Value.absent(),
                Value<String> useType = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UnitsCompanion(
                id: id,
                propertyId: propertyId,
                unitNumber: unitNumber,
                rentStatus: rentStatus,
                sizeMeter: sizeMeter,
                sizeKorea: sizeKorea,
                useType: useType,
                description: description,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String propertyId,
                required String unitNumber,
                required String rentStatus,
                required double sizeMeter,
                required double sizeKorea,
                required String useType,
                Value<String?> description = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UnitsCompanion.insert(
                id: id,
                propertyId: propertyId,
                unitNumber: unitNumber,
                rentStatus: rentStatus,
                sizeMeter: sizeMeter,
                sizeKorea: sizeKorea,
                useType: useType,
                description: description,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$UnitsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({propertyId = false, leasesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (leasesRefs) db.leases],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (propertyId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.propertyId,
                                referencedTable: $$UnitsTableReferences
                                    ._propertyIdTable(db),
                                referencedColumn: $$UnitsTableReferences
                                    ._propertyIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (leasesRefs)
                    await $_getPrefetchedData<Unit, $UnitsTable, Lease>(
                      currentTable: table,
                      referencedTable: $$UnitsTableReferences._leasesRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$UnitsTableReferences(db, table, p0).leasesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.unitId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$UnitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UnitsTable,
      Unit,
      $$UnitsTableFilterComposer,
      $$UnitsTableOrderingComposer,
      $$UnitsTableAnnotationComposer,
      $$UnitsTableCreateCompanionBuilder,
      $$UnitsTableUpdateCompanionBuilder,
      (Unit, $$UnitsTableReferences),
      Unit,
      PrefetchHooks Function({bool propertyId, bool leasesRefs})
    >;
typedef $$TenantsTableCreateCompanionBuilder =
    TenantsCompanion Function({
      required String id,
      required String name,
      required String phone,
      required String email,
      Value<String?> socialNo,
      Value<String?> currentAddress,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$TenantsTableUpdateCompanionBuilder =
    TenantsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> phone,
      Value<String> email,
      Value<String?> socialNo,
      Value<String?> currentAddress,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$TenantsTableReferences
    extends BaseReferences<_$AppDatabase, $TenantsTable, Tenant> {
  $$TenantsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$LeasesTable, List<Lease>> _leasesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.leases,
    aliasName: $_aliasNameGenerator(db.tenants.id, db.leases.tenantId),
  );

  $$LeasesTableProcessedTableManager get leasesRefs {
    final manager = $$LeasesTableTableManager(
      $_db,
      $_db.leases,
    ).filter((f) => f.tenantId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_leasesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TenantsTableFilterComposer
    extends Composer<_$AppDatabase, $TenantsTable> {
  $$TenantsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get socialNo => $composableBuilder(
    column: $table.socialNo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currentAddress => $composableBuilder(
    column: $table.currentAddress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> leasesRefs(
    Expression<bool> Function($$LeasesTableFilterComposer f) f,
  ) {
    final $$LeasesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.leases,
      getReferencedColumn: (t) => t.tenantId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LeasesTableFilterComposer(
            $db: $db,
            $table: $db.leases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TenantsTableOrderingComposer
    extends Composer<_$AppDatabase, $TenantsTable> {
  $$TenantsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get socialNo => $composableBuilder(
    column: $table.socialNo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currentAddress => $composableBuilder(
    column: $table.currentAddress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TenantsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TenantsTable> {
  $$TenantsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get socialNo =>
      $composableBuilder(column: $table.socialNo, builder: (column) => column);

  GeneratedColumn<String> get currentAddress => $composableBuilder(
    column: $table.currentAddress,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> leasesRefs<T extends Object>(
    Expression<T> Function($$LeasesTableAnnotationComposer a) f,
  ) {
    final $$LeasesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.leases,
      getReferencedColumn: (t) => t.tenantId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LeasesTableAnnotationComposer(
            $db: $db,
            $table: $db.leases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TenantsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TenantsTable,
          Tenant,
          $$TenantsTableFilterComposer,
          $$TenantsTableOrderingComposer,
          $$TenantsTableAnnotationComposer,
          $$TenantsTableCreateCompanionBuilder,
          $$TenantsTableUpdateCompanionBuilder,
          (Tenant, $$TenantsTableReferences),
          Tenant,
          PrefetchHooks Function({bool leasesRefs})
        > {
  $$TenantsTableTableManager(_$AppDatabase db, $TenantsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TenantsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TenantsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TenantsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String?> socialNo = const Value.absent(),
                Value<String?> currentAddress = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TenantsCompanion(
                id: id,
                name: name,
                phone: phone,
                email: email,
                socialNo: socialNo,
                currentAddress: currentAddress,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String phone,
                required String email,
                Value<String?> socialNo = const Value.absent(),
                Value<String?> currentAddress = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => TenantsCompanion.insert(
                id: id,
                name: name,
                phone: phone,
                email: email,
                socialNo: socialNo,
                currentAddress: currentAddress,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TenantsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({leasesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (leasesRefs) db.leases],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (leasesRefs)
                    await $_getPrefetchedData<Tenant, $TenantsTable, Lease>(
                      currentTable: table,
                      referencedTable: $$TenantsTableReferences
                          ._leasesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$TenantsTableReferences(db, table, p0).leasesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.tenantId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TenantsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TenantsTable,
      Tenant,
      $$TenantsTableFilterComposer,
      $$TenantsTableOrderingComposer,
      $$TenantsTableAnnotationComposer,
      $$TenantsTableCreateCompanionBuilder,
      $$TenantsTableUpdateCompanionBuilder,
      (Tenant, $$TenantsTableReferences),
      Tenant,
      PrefetchHooks Function({bool leasesRefs})
    >;
typedef $$LeasesTableCreateCompanionBuilder =
    LeasesCompanion Function({
      required String id,
      required String tenantId,
      required String unitId,
      required DateTime startDate,
      required DateTime endDate,
      required int deposit,
      required int monthlyRent,
      required String leaseType,
      required String leaseStatus,
      Value<String?> contractNotes,
      Value<int> rowid,
    });
typedef $$LeasesTableUpdateCompanionBuilder =
    LeasesCompanion Function({
      Value<String> id,
      Value<String> tenantId,
      Value<String> unitId,
      Value<DateTime> startDate,
      Value<DateTime> endDate,
      Value<int> deposit,
      Value<int> monthlyRent,
      Value<String> leaseType,
      Value<String> leaseStatus,
      Value<String?> contractNotes,
      Value<int> rowid,
    });

final class $$LeasesTableReferences
    extends BaseReferences<_$AppDatabase, $LeasesTable, Lease> {
  $$LeasesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TenantsTable _tenantIdTable(_$AppDatabase db) => db.tenants
      .createAlias($_aliasNameGenerator(db.leases.tenantId, db.tenants.id));

  $$TenantsTableProcessedTableManager get tenantId {
    final $_column = $_itemColumn<String>('tenant_id')!;

    final manager = $$TenantsTableTableManager(
      $_db,
      $_db.tenants,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tenantIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $UnitsTable _unitIdTable(_$AppDatabase db) =>
      db.units.createAlias($_aliasNameGenerator(db.leases.unitId, db.units.id));

  $$UnitsTableProcessedTableManager get unitId {
    final $_column = $_itemColumn<String>('unit_id')!;

    final manager = $$UnitsTableTableManager(
      $_db,
      $_db.units,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_unitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$BillingsTable, List<Billing>> _billingsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.billings,
    aliasName: $_aliasNameGenerator(db.leases.id, db.billings.leaseId),
  );

  $$BillingsTableProcessedTableManager get billingsRefs {
    final manager = $$BillingsTableTableManager(
      $_db,
      $_db.billings,
    ).filter((f) => f.leaseId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_billingsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LeasesTableFilterComposer
    extends Composer<_$AppDatabase, $LeasesTable> {
  $$LeasesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deposit => $composableBuilder(
    column: $table.deposit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get monthlyRent => $composableBuilder(
    column: $table.monthlyRent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get leaseType => $composableBuilder(
    column: $table.leaseType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get leaseStatus => $composableBuilder(
    column: $table.leaseStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contractNotes => $composableBuilder(
    column: $table.contractNotes,
    builder: (column) => ColumnFilters(column),
  );

  $$TenantsTableFilterComposer get tenantId {
    final $$TenantsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tenantId,
      referencedTable: $db.tenants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TenantsTableFilterComposer(
            $db: $db,
            $table: $db.tenants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UnitsTableFilterComposer get unitId {
    final $$UnitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.unitId,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnitsTableFilterComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> billingsRefs(
    Expression<bool> Function($$BillingsTableFilterComposer f) f,
  ) {
    final $$BillingsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.billings,
      getReferencedColumn: (t) => t.leaseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BillingsTableFilterComposer(
            $db: $db,
            $table: $db.billings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LeasesTableOrderingComposer
    extends Composer<_$AppDatabase, $LeasesTable> {
  $$LeasesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deposit => $composableBuilder(
    column: $table.deposit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get monthlyRent => $composableBuilder(
    column: $table.monthlyRent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get leaseType => $composableBuilder(
    column: $table.leaseType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get leaseStatus => $composableBuilder(
    column: $table.leaseStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contractNotes => $composableBuilder(
    column: $table.contractNotes,
    builder: (column) => ColumnOrderings(column),
  );

  $$TenantsTableOrderingComposer get tenantId {
    final $$TenantsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tenantId,
      referencedTable: $db.tenants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TenantsTableOrderingComposer(
            $db: $db,
            $table: $db.tenants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UnitsTableOrderingComposer get unitId {
    final $$UnitsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.unitId,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnitsTableOrderingComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LeasesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LeasesTable> {
  $$LeasesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<int> get deposit =>
      $composableBuilder(column: $table.deposit, builder: (column) => column);

  GeneratedColumn<int> get monthlyRent => $composableBuilder(
    column: $table.monthlyRent,
    builder: (column) => column,
  );

  GeneratedColumn<String> get leaseType =>
      $composableBuilder(column: $table.leaseType, builder: (column) => column);

  GeneratedColumn<String> get leaseStatus => $composableBuilder(
    column: $table.leaseStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contractNotes => $composableBuilder(
    column: $table.contractNotes,
    builder: (column) => column,
  );

  $$TenantsTableAnnotationComposer get tenantId {
    final $$TenantsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tenantId,
      referencedTable: $db.tenants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TenantsTableAnnotationComposer(
            $db: $db,
            $table: $db.tenants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UnitsTableAnnotationComposer get unitId {
    final $$UnitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.unitId,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnitsTableAnnotationComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> billingsRefs<T extends Object>(
    Expression<T> Function($$BillingsTableAnnotationComposer a) f,
  ) {
    final $$BillingsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.billings,
      getReferencedColumn: (t) => t.leaseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BillingsTableAnnotationComposer(
            $db: $db,
            $table: $db.billings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LeasesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LeasesTable,
          Lease,
          $$LeasesTableFilterComposer,
          $$LeasesTableOrderingComposer,
          $$LeasesTableAnnotationComposer,
          $$LeasesTableCreateCompanionBuilder,
          $$LeasesTableUpdateCompanionBuilder,
          (Lease, $$LeasesTableReferences),
          Lease,
          PrefetchHooks Function({
            bool tenantId,
            bool unitId,
            bool billingsRefs,
          })
        > {
  $$LeasesTableTableManager(_$AppDatabase db, $LeasesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LeasesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LeasesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LeasesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tenantId = const Value.absent(),
                Value<String> unitId = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime> endDate = const Value.absent(),
                Value<int> deposit = const Value.absent(),
                Value<int> monthlyRent = const Value.absent(),
                Value<String> leaseType = const Value.absent(),
                Value<String> leaseStatus = const Value.absent(),
                Value<String?> contractNotes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LeasesCompanion(
                id: id,
                tenantId: tenantId,
                unitId: unitId,
                startDate: startDate,
                endDate: endDate,
                deposit: deposit,
                monthlyRent: monthlyRent,
                leaseType: leaseType,
                leaseStatus: leaseStatus,
                contractNotes: contractNotes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tenantId,
                required String unitId,
                required DateTime startDate,
                required DateTime endDate,
                required int deposit,
                required int monthlyRent,
                required String leaseType,
                required String leaseStatus,
                Value<String?> contractNotes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LeasesCompanion.insert(
                id: id,
                tenantId: tenantId,
                unitId: unitId,
                startDate: startDate,
                endDate: endDate,
                deposit: deposit,
                monthlyRent: monthlyRent,
                leaseType: leaseType,
                leaseStatus: leaseStatus,
                contractNotes: contractNotes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$LeasesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({tenantId = false, unitId = false, billingsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [if (billingsRefs) db.billings],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (tenantId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.tenantId,
                                    referencedTable: $$LeasesTableReferences
                                        ._tenantIdTable(db),
                                    referencedColumn: $$LeasesTableReferences
                                        ._tenantIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (unitId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.unitId,
                                    referencedTable: $$LeasesTableReferences
                                        ._unitIdTable(db),
                                    referencedColumn: $$LeasesTableReferences
                                        ._unitIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (billingsRefs)
                        await $_getPrefetchedData<Lease, $LeasesTable, Billing>(
                          currentTable: table,
                          referencedTable: $$LeasesTableReferences
                              ._billingsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LeasesTableReferences(
                                db,
                                table,
                                p0,
                              ).billingsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.leaseId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$LeasesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LeasesTable,
      Lease,
      $$LeasesTableFilterComposer,
      $$LeasesTableOrderingComposer,
      $$LeasesTableAnnotationComposer,
      $$LeasesTableCreateCompanionBuilder,
      $$LeasesTableUpdateCompanionBuilder,
      (Lease, $$LeasesTableReferences),
      Lease,
      PrefetchHooks Function({bool tenantId, bool unitId, bool billingsRefs})
    >;
typedef $$BillTemplatesTableCreateCompanionBuilder =
    BillTemplatesCompanion Function({
      required String id,
      required String name,
      required String category,
      required int amount,
      Value<String?> description,
      Value<int> rowid,
    });
typedef $$BillTemplatesTableUpdateCompanionBuilder =
    BillTemplatesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> category,
      Value<int> amount,
      Value<String?> description,
      Value<int> rowid,
    });

final class $$BillTemplatesTableReferences
    extends BaseReferences<_$AppDatabase, $BillTemplatesTable, BillTemplate> {
  $$BillTemplatesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$BillingItemsTable, List<BillingItem>>
  _billingItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.billingItems,
    aliasName: $_aliasNameGenerator(
      db.billTemplates.id,
      db.billingItems.billTemplateId,
    ),
  );

  $$BillingItemsTableProcessedTableManager get billingItemsRefs {
    final manager = $$BillingItemsTableTableManager(
      $_db,
      $_db.billingItems,
    ).filter((f) => f.billTemplateId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_billingItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BillTemplatesTableFilterComposer
    extends Composer<_$AppDatabase, $BillTemplatesTable> {
  $$BillTemplatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> billingItemsRefs(
    Expression<bool> Function($$BillingItemsTableFilterComposer f) f,
  ) {
    final $$BillingItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.billingItems,
      getReferencedColumn: (t) => t.billTemplateId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BillingItemsTableFilterComposer(
            $db: $db,
            $table: $db.billingItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BillTemplatesTableOrderingComposer
    extends Composer<_$AppDatabase, $BillTemplatesTable> {
  $$BillTemplatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BillTemplatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BillTemplatesTable> {
  $$BillTemplatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  Expression<T> billingItemsRefs<T extends Object>(
    Expression<T> Function($$BillingItemsTableAnnotationComposer a) f,
  ) {
    final $$BillingItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.billingItems,
      getReferencedColumn: (t) => t.billTemplateId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BillingItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.billingItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BillTemplatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BillTemplatesTable,
          BillTemplate,
          $$BillTemplatesTableFilterComposer,
          $$BillTemplatesTableOrderingComposer,
          $$BillTemplatesTableAnnotationComposer,
          $$BillTemplatesTableCreateCompanionBuilder,
          $$BillTemplatesTableUpdateCompanionBuilder,
          (BillTemplate, $$BillTemplatesTableReferences),
          BillTemplate,
          PrefetchHooks Function({bool billingItemsRefs})
        > {
  $$BillTemplatesTableTableManager(_$AppDatabase db, $BillTemplatesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BillTemplatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BillTemplatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BillTemplatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BillTemplatesCompanion(
                id: id,
                name: name,
                category: category,
                amount: amount,
                description: description,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String category,
                required int amount,
                Value<String?> description = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BillTemplatesCompanion.insert(
                id: id,
                name: name,
                category: category,
                amount: amount,
                description: description,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BillTemplatesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({billingItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (billingItemsRefs) db.billingItems],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (billingItemsRefs)
                    await $_getPrefetchedData<
                      BillTemplate,
                      $BillTemplatesTable,
                      BillingItem
                    >(
                      currentTable: table,
                      referencedTable: $$BillTemplatesTableReferences
                          ._billingItemsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$BillTemplatesTableReferences(
                            db,
                            table,
                            p0,
                          ).billingItemsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.billTemplateId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$BillTemplatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BillTemplatesTable,
      BillTemplate,
      $$BillTemplatesTableFilterComposer,
      $$BillTemplatesTableOrderingComposer,
      $$BillTemplatesTableAnnotationComposer,
      $$BillTemplatesTableCreateCompanionBuilder,
      $$BillTemplatesTableUpdateCompanionBuilder,
      (BillTemplate, $$BillTemplatesTableReferences),
      BillTemplate,
      PrefetchHooks Function({bool billingItemsRefs})
    >;
typedef $$BillingsTableCreateCompanionBuilder =
    BillingsCompanion Function({
      required String id,
      required String leaseId,
      required String yearMonth,
      required DateTime issueDate,
      required DateTime dueDate,
      Value<bool> paid,
      Value<DateTime?> paidDate,
      required int totalAmount,
      Value<int> rowid,
    });
typedef $$BillingsTableUpdateCompanionBuilder =
    BillingsCompanion Function({
      Value<String> id,
      Value<String> leaseId,
      Value<String> yearMonth,
      Value<DateTime> issueDate,
      Value<DateTime> dueDate,
      Value<bool> paid,
      Value<DateTime?> paidDate,
      Value<int> totalAmount,
      Value<int> rowid,
    });

final class $$BillingsTableReferences
    extends BaseReferences<_$AppDatabase, $BillingsTable, Billing> {
  $$BillingsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $LeasesTable _leaseIdTable(_$AppDatabase db) => db.leases.createAlias(
    $_aliasNameGenerator(db.billings.leaseId, db.leases.id),
  );

  $$LeasesTableProcessedTableManager get leaseId {
    final $_column = $_itemColumn<String>('lease_id')!;

    final manager = $$LeasesTableTableManager(
      $_db,
      $_db.leases,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_leaseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$BillingItemsTable, List<BillingItem>>
  _billingItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.billingItems,
    aliasName: $_aliasNameGenerator(db.billings.id, db.billingItems.billingId),
  );

  $$BillingItemsTableProcessedTableManager get billingItemsRefs {
    final manager = $$BillingItemsTableTableManager(
      $_db,
      $_db.billingItems,
    ).filter((f) => f.billingId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_billingItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BillingsTableFilterComposer
    extends Composer<_$AppDatabase, $BillingsTable> {
  $$BillingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get yearMonth => $composableBuilder(
    column: $table.yearMonth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get issueDate => $composableBuilder(
    column: $table.issueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get paid => $composableBuilder(
    column: $table.paid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get paidDate => $composableBuilder(
    column: $table.paidDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnFilters(column),
  );

  $$LeasesTableFilterComposer get leaseId {
    final $$LeasesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.leaseId,
      referencedTable: $db.leases,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LeasesTableFilterComposer(
            $db: $db,
            $table: $db.leases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> billingItemsRefs(
    Expression<bool> Function($$BillingItemsTableFilterComposer f) f,
  ) {
    final $$BillingItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.billingItems,
      getReferencedColumn: (t) => t.billingId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BillingItemsTableFilterComposer(
            $db: $db,
            $table: $db.billingItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BillingsTableOrderingComposer
    extends Composer<_$AppDatabase, $BillingsTable> {
  $$BillingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get yearMonth => $composableBuilder(
    column: $table.yearMonth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get issueDate => $composableBuilder(
    column: $table.issueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get paid => $composableBuilder(
    column: $table.paid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get paidDate => $composableBuilder(
    column: $table.paidDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnOrderings(column),
  );

  $$LeasesTableOrderingComposer get leaseId {
    final $$LeasesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.leaseId,
      referencedTable: $db.leases,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LeasesTableOrderingComposer(
            $db: $db,
            $table: $db.leases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BillingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BillingsTable> {
  $$BillingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get yearMonth =>
      $composableBuilder(column: $table.yearMonth, builder: (column) => column);

  GeneratedColumn<DateTime> get issueDate =>
      $composableBuilder(column: $table.issueDate, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<bool> get paid =>
      $composableBuilder(column: $table.paid, builder: (column) => column);

  GeneratedColumn<DateTime> get paidDate =>
      $composableBuilder(column: $table.paidDate, builder: (column) => column);

  GeneratedColumn<int> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => column,
  );

  $$LeasesTableAnnotationComposer get leaseId {
    final $$LeasesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.leaseId,
      referencedTable: $db.leases,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LeasesTableAnnotationComposer(
            $db: $db,
            $table: $db.leases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> billingItemsRefs<T extends Object>(
    Expression<T> Function($$BillingItemsTableAnnotationComposer a) f,
  ) {
    final $$BillingItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.billingItems,
      getReferencedColumn: (t) => t.billingId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BillingItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.billingItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BillingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BillingsTable,
          Billing,
          $$BillingsTableFilterComposer,
          $$BillingsTableOrderingComposer,
          $$BillingsTableAnnotationComposer,
          $$BillingsTableCreateCompanionBuilder,
          $$BillingsTableUpdateCompanionBuilder,
          (Billing, $$BillingsTableReferences),
          Billing,
          PrefetchHooks Function({bool leaseId, bool billingItemsRefs})
        > {
  $$BillingsTableTableManager(_$AppDatabase db, $BillingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BillingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BillingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BillingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> leaseId = const Value.absent(),
                Value<String> yearMonth = const Value.absent(),
                Value<DateTime> issueDate = const Value.absent(),
                Value<DateTime> dueDate = const Value.absent(),
                Value<bool> paid = const Value.absent(),
                Value<DateTime?> paidDate = const Value.absent(),
                Value<int> totalAmount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BillingsCompanion(
                id: id,
                leaseId: leaseId,
                yearMonth: yearMonth,
                issueDate: issueDate,
                dueDate: dueDate,
                paid: paid,
                paidDate: paidDate,
                totalAmount: totalAmount,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String leaseId,
                required String yearMonth,
                required DateTime issueDate,
                required DateTime dueDate,
                Value<bool> paid = const Value.absent(),
                Value<DateTime?> paidDate = const Value.absent(),
                required int totalAmount,
                Value<int> rowid = const Value.absent(),
              }) => BillingsCompanion.insert(
                id: id,
                leaseId: leaseId,
                yearMonth: yearMonth,
                issueDate: issueDate,
                dueDate: dueDate,
                paid: paid,
                paidDate: paidDate,
                totalAmount: totalAmount,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BillingsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({leaseId = false, billingItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (billingItemsRefs) db.billingItems],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (leaseId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.leaseId,
                                referencedTable: $$BillingsTableReferences
                                    ._leaseIdTable(db),
                                referencedColumn: $$BillingsTableReferences
                                    ._leaseIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (billingItemsRefs)
                    await $_getPrefetchedData<
                      Billing,
                      $BillingsTable,
                      BillingItem
                    >(
                      currentTable: table,
                      referencedTable: $$BillingsTableReferences
                          ._billingItemsRefsTable(db),
                      managerFromTypedResult: (p0) => $$BillingsTableReferences(
                        db,
                        table,
                        p0,
                      ).billingItemsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.billingId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$BillingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BillingsTable,
      Billing,
      $$BillingsTableFilterComposer,
      $$BillingsTableOrderingComposer,
      $$BillingsTableAnnotationComposer,
      $$BillingsTableCreateCompanionBuilder,
      $$BillingsTableUpdateCompanionBuilder,
      (Billing, $$BillingsTableReferences),
      Billing,
      PrefetchHooks Function({bool leaseId, bool billingItemsRefs})
    >;
typedef $$BillingItemsTableCreateCompanionBuilder =
    BillingItemsCompanion Function({
      required String id,
      required String billingId,
      required String billTemplateId,
      required int amount,
      Value<int> rowid,
    });
typedef $$BillingItemsTableUpdateCompanionBuilder =
    BillingItemsCompanion Function({
      Value<String> id,
      Value<String> billingId,
      Value<String> billTemplateId,
      Value<int> amount,
      Value<int> rowid,
    });

final class $$BillingItemsTableReferences
    extends BaseReferences<_$AppDatabase, $BillingItemsTable, BillingItem> {
  $$BillingItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BillingsTable _billingIdTable(_$AppDatabase db) =>
      db.billings.createAlias(
        $_aliasNameGenerator(db.billingItems.billingId, db.billings.id),
      );

  $$BillingsTableProcessedTableManager get billingId {
    final $_column = $_itemColumn<String>('billing_id')!;

    final manager = $$BillingsTableTableManager(
      $_db,
      $_db.billings,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_billingIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $BillTemplatesTable _billTemplateIdTable(_$AppDatabase db) =>
      db.billTemplates.createAlias(
        $_aliasNameGenerator(
          db.billingItems.billTemplateId,
          db.billTemplates.id,
        ),
      );

  $$BillTemplatesTableProcessedTableManager get billTemplateId {
    final $_column = $_itemColumn<String>('bill_template_id')!;

    final manager = $$BillTemplatesTableTableManager(
      $_db,
      $_db.billTemplates,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_billTemplateIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BillingItemsTableFilterComposer
    extends Composer<_$AppDatabase, $BillingItemsTable> {
  $$BillingItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  $$BillingsTableFilterComposer get billingId {
    final $$BillingsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.billingId,
      referencedTable: $db.billings,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BillingsTableFilterComposer(
            $db: $db,
            $table: $db.billings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BillTemplatesTableFilterComposer get billTemplateId {
    final $$BillTemplatesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.billTemplateId,
      referencedTable: $db.billTemplates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BillTemplatesTableFilterComposer(
            $db: $db,
            $table: $db.billTemplates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BillingItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $BillingItemsTable> {
  $$BillingItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  $$BillingsTableOrderingComposer get billingId {
    final $$BillingsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.billingId,
      referencedTable: $db.billings,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BillingsTableOrderingComposer(
            $db: $db,
            $table: $db.billings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BillTemplatesTableOrderingComposer get billTemplateId {
    final $$BillTemplatesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.billTemplateId,
      referencedTable: $db.billTemplates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BillTemplatesTableOrderingComposer(
            $db: $db,
            $table: $db.billTemplates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BillingItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BillingItemsTable> {
  $$BillingItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  $$BillingsTableAnnotationComposer get billingId {
    final $$BillingsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.billingId,
      referencedTable: $db.billings,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BillingsTableAnnotationComposer(
            $db: $db,
            $table: $db.billings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BillTemplatesTableAnnotationComposer get billTemplateId {
    final $$BillTemplatesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.billTemplateId,
      referencedTable: $db.billTemplates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BillTemplatesTableAnnotationComposer(
            $db: $db,
            $table: $db.billTemplates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BillingItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BillingItemsTable,
          BillingItem,
          $$BillingItemsTableFilterComposer,
          $$BillingItemsTableOrderingComposer,
          $$BillingItemsTableAnnotationComposer,
          $$BillingItemsTableCreateCompanionBuilder,
          $$BillingItemsTableUpdateCompanionBuilder,
          (BillingItem, $$BillingItemsTableReferences),
          BillingItem,
          PrefetchHooks Function({bool billingId, bool billTemplateId})
        > {
  $$BillingItemsTableTableManager(_$AppDatabase db, $BillingItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BillingItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BillingItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BillingItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> billingId = const Value.absent(),
                Value<String> billTemplateId = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BillingItemsCompanion(
                id: id,
                billingId: billingId,
                billTemplateId: billTemplateId,
                amount: amount,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String billingId,
                required String billTemplateId,
                required int amount,
                Value<int> rowid = const Value.absent(),
              }) => BillingItemsCompanion.insert(
                id: id,
                billingId: billingId,
                billTemplateId: billTemplateId,
                amount: amount,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BillingItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({billingId = false, billTemplateId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (billingId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.billingId,
                                referencedTable: $$BillingItemsTableReferences
                                    ._billingIdTable(db),
                                referencedColumn: $$BillingItemsTableReferences
                                    ._billingIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (billTemplateId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.billTemplateId,
                                referencedTable: $$BillingItemsTableReferences
                                    ._billTemplateIdTable(db),
                                referencedColumn: $$BillingItemsTableReferences
                                    ._billTemplateIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$BillingItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BillingItemsTable,
      BillingItem,
      $$BillingItemsTableFilterComposer,
      $$BillingItemsTableOrderingComposer,
      $$BillingItemsTableAnnotationComposer,
      $$BillingItemsTableCreateCompanionBuilder,
      $$BillingItemsTableUpdateCompanionBuilder,
      (BillingItem, $$BillingItemsTableReferences),
      BillingItem,
      PrefetchHooks Function({bool billingId, bool billTemplateId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PropertiesTableTableManager get properties =>
      $$PropertiesTableTableManager(_db, _db.properties);
  $$UnitsTableTableManager get units =>
      $$UnitsTableTableManager(_db, _db.units);
  $$TenantsTableTableManager get tenants =>
      $$TenantsTableTableManager(_db, _db.tenants);
  $$LeasesTableTableManager get leases =>
      $$LeasesTableTableManager(_db, _db.leases);
  $$BillTemplatesTableTableManager get billTemplates =>
      $$BillTemplatesTableTableManager(_db, _db.billTemplates);
  $$BillingsTableTableManager get billings =>
      $$BillingsTableTableManager(_db, _db.billings);
  $$BillingItemsTableTableManager get billingItems =>
      $$BillingItemsTableTableManager(_db, _db.billingItems);
}
