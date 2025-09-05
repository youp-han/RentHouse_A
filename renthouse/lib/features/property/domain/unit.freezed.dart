// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'unit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Unit _$UnitFromJson(Map<String, dynamic> json) {
  return _Unit.fromJson(json);
}

/// @nodoc
mixin _$Unit {
  String get id => throw _privateConstructorUsedError;
  String get propertyId => throw _privateConstructorUsedError;
  String get unitNumber => throw _privateConstructorUsedError;
  String get rentStatus => throw _privateConstructorUsedError;
  double get sizeMeter => throw _privateConstructorUsedError;
  double get sizeKorea => throw _privateConstructorUsedError;
  String get useType => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  /// Serializes this Unit to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Unit
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UnitCopyWith<Unit> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UnitCopyWith<$Res> {
  factory $UnitCopyWith(Unit value, $Res Function(Unit) then) =
      _$UnitCopyWithImpl<$Res, Unit>;
  @useResult
  $Res call({
    String id,
    String propertyId,
    String unitNumber,
    String rentStatus,
    double sizeMeter,
    double sizeKorea,
    String useType,
    String? description,
  });
}

/// @nodoc
class _$UnitCopyWithImpl<$Res, $Val extends Unit>
    implements $UnitCopyWith<$Res> {
  _$UnitCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Unit
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? propertyId = null,
    Object? unitNumber = null,
    Object? rentStatus = null,
    Object? sizeMeter = null,
    Object? sizeKorea = null,
    Object? useType = null,
    Object? description = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            propertyId: null == propertyId
                ? _value.propertyId
                : propertyId // ignore: cast_nullable_to_non_nullable
                      as String,
            unitNumber: null == unitNumber
                ? _value.unitNumber
                : unitNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            rentStatus: null == rentStatus
                ? _value.rentStatus
                : rentStatus // ignore: cast_nullable_to_non_nullable
                      as String,
            sizeMeter: null == sizeMeter
                ? _value.sizeMeter
                : sizeMeter // ignore: cast_nullable_to_non_nullable
                      as double,
            sizeKorea: null == sizeKorea
                ? _value.sizeKorea
                : sizeKorea // ignore: cast_nullable_to_non_nullable
                      as double,
            useType: null == useType
                ? _value.useType
                : useType // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UnitImplCopyWith<$Res> implements $UnitCopyWith<$Res> {
  factory _$$UnitImplCopyWith(
    _$UnitImpl value,
    $Res Function(_$UnitImpl) then,
  ) = __$$UnitImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String propertyId,
    String unitNumber,
    String rentStatus,
    double sizeMeter,
    double sizeKorea,
    String useType,
    String? description,
  });
}

/// @nodoc
class __$$UnitImplCopyWithImpl<$Res>
    extends _$UnitCopyWithImpl<$Res, _$UnitImpl>
    implements _$$UnitImplCopyWith<$Res> {
  __$$UnitImplCopyWithImpl(_$UnitImpl _value, $Res Function(_$UnitImpl) _then)
    : super(_value, _then);

  /// Create a copy of Unit
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? propertyId = null,
    Object? unitNumber = null,
    Object? rentStatus = null,
    Object? sizeMeter = null,
    Object? sizeKorea = null,
    Object? useType = null,
    Object? description = freezed,
  }) {
    return _then(
      _$UnitImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        propertyId: null == propertyId
            ? _value.propertyId
            : propertyId // ignore: cast_nullable_to_non_nullable
                  as String,
        unitNumber: null == unitNumber
            ? _value.unitNumber
            : unitNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        rentStatus: null == rentStatus
            ? _value.rentStatus
            : rentStatus // ignore: cast_nullable_to_non_nullable
                  as String,
        sizeMeter: null == sizeMeter
            ? _value.sizeMeter
            : sizeMeter // ignore: cast_nullable_to_non_nullable
                  as double,
        sizeKorea: null == sizeKorea
            ? _value.sizeKorea
            : sizeKorea // ignore: cast_nullable_to_non_nullable
                  as double,
        useType: null == useType
            ? _value.useType
            : useType // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UnitImpl implements _Unit {
  const _$UnitImpl({
    required this.id,
    required this.propertyId,
    required this.unitNumber,
    required this.rentStatus,
    required this.sizeMeter,
    required this.sizeKorea,
    required this.useType,
    this.description,
  });

  factory _$UnitImpl.fromJson(Map<String, dynamic> json) =>
      _$$UnitImplFromJson(json);

  @override
  final String id;
  @override
  final String propertyId;
  @override
  final String unitNumber;
  @override
  final String rentStatus;
  @override
  final double sizeMeter;
  @override
  final double sizeKorea;
  @override
  final String useType;
  @override
  final String? description;

  @override
  String toString() {
    return 'Unit(id: $id, propertyId: $propertyId, unitNumber: $unitNumber, rentStatus: $rentStatus, sizeMeter: $sizeMeter, sizeKorea: $sizeKorea, useType: $useType, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnitImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.propertyId, propertyId) ||
                other.propertyId == propertyId) &&
            (identical(other.unitNumber, unitNumber) ||
                other.unitNumber == unitNumber) &&
            (identical(other.rentStatus, rentStatus) ||
                other.rentStatus == rentStatus) &&
            (identical(other.sizeMeter, sizeMeter) ||
                other.sizeMeter == sizeMeter) &&
            (identical(other.sizeKorea, sizeKorea) ||
                other.sizeKorea == sizeKorea) &&
            (identical(other.useType, useType) || other.useType == useType) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    propertyId,
    unitNumber,
    rentStatus,
    sizeMeter,
    sizeKorea,
    useType,
    description,
  );

  /// Create a copy of Unit
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UnitImplCopyWith<_$UnitImpl> get copyWith =>
      __$$UnitImplCopyWithImpl<_$UnitImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UnitImplToJson(this);
  }
}

abstract class _Unit implements Unit {
  const factory _Unit({
    required final String id,
    required final String propertyId,
    required final String unitNumber,
    required final String rentStatus,
    required final double sizeMeter,
    required final double sizeKorea,
    required final String useType,
    final String? description,
  }) = _$UnitImpl;

  factory _Unit.fromJson(Map<String, dynamic> json) = _$UnitImpl.fromJson;

  @override
  String get id;
  @override
  String get propertyId;
  @override
  String get unitNumber;
  @override
  String get rentStatus;
  @override
  double get sizeMeter;
  @override
  double get sizeKorea;
  @override
  String get useType;
  @override
  String? get description;

  /// Create a copy of Unit
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UnitImplCopyWith<_$UnitImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
