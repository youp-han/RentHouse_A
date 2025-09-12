// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'property.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BillingItem _$BillingItemFromJson(Map<String, dynamic> json) {
  return _BillingItem.fromJson(json);
}

/// @nodoc
mixin _$BillingItem {
  String get name => throw _privateConstructorUsedError;
  int get amount => throw _privateConstructorUsedError;
  bool get isEnabled => throw _privateConstructorUsedError;

  /// Serializes this BillingItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BillingItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BillingItemCopyWith<BillingItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BillingItemCopyWith<$Res> {
  factory $BillingItemCopyWith(
    BillingItem value,
    $Res Function(BillingItem) then,
  ) = _$BillingItemCopyWithImpl<$Res, BillingItem>;
  @useResult
  $Res call({String name, int amount, bool isEnabled});
}

/// @nodoc
class _$BillingItemCopyWithImpl<$Res, $Val extends BillingItem>
    implements $BillingItemCopyWith<$Res> {
  _$BillingItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BillingItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? amount = null,
    Object? isEnabled = null,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as int,
            isEnabled: null == isEnabled
                ? _value.isEnabled
                : isEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BillingItemImplCopyWith<$Res>
    implements $BillingItemCopyWith<$Res> {
  factory _$$BillingItemImplCopyWith(
    _$BillingItemImpl value,
    $Res Function(_$BillingItemImpl) then,
  ) = __$$BillingItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, int amount, bool isEnabled});
}

/// @nodoc
class __$$BillingItemImplCopyWithImpl<$Res>
    extends _$BillingItemCopyWithImpl<$Res, _$BillingItemImpl>
    implements _$$BillingItemImplCopyWith<$Res> {
  __$$BillingItemImplCopyWithImpl(
    _$BillingItemImpl _value,
    $Res Function(_$BillingItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BillingItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? amount = null,
    Object? isEnabled = null,
  }) {
    return _then(
      _$BillingItemImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as int,
        isEnabled: null == isEnabled
            ? _value.isEnabled
            : isEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BillingItemImpl implements _BillingItem {
  const _$BillingItemImpl({
    required this.name,
    required this.amount,
    this.isEnabled = true,
  });

  factory _$BillingItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$BillingItemImplFromJson(json);

  @override
  final String name;
  @override
  final int amount;
  @override
  @JsonKey()
  final bool isEnabled;

  @override
  String toString() {
    return 'BillingItem(name: $name, amount: $amount, isEnabled: $isEnabled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BillingItemImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.isEnabled, isEnabled) ||
                other.isEnabled == isEnabled));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, amount, isEnabled);

  /// Create a copy of BillingItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BillingItemImplCopyWith<_$BillingItemImpl> get copyWith =>
      __$$BillingItemImplCopyWithImpl<_$BillingItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BillingItemImplToJson(this);
  }
}

abstract class _BillingItem implements BillingItem {
  const factory _BillingItem({
    required final String name,
    required final int amount,
    final bool isEnabled,
  }) = _$BillingItemImpl;

  factory _BillingItem.fromJson(Map<String, dynamic> json) =
      _$BillingItemImpl.fromJson;

  @override
  String get name;
  @override
  int get amount;
  @override
  bool get isEnabled;

  /// Create a copy of BillingItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BillingItemImplCopyWith<_$BillingItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Property _$PropertyFromJson(Map<String, dynamic> json) {
  return _Property.fromJson(json);
}

/// @nodoc
mixin _$Property {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError; // 주소 구조 변경 (task136)
  String? get zipCode => throw _privateConstructorUsedError; // 우편번호
  String? get address1 => throw _privateConstructorUsedError; // 주소1
  String? get address2 => throw _privateConstructorUsedError; // 상세주소
  @Deprecated('Use fullAddress getter instead')
  String? get address => throw _privateConstructorUsedError; // 기존 호환성을 위해 유지
  // 자산 유형을 enum으로 변경 (task132)
  PropertyType get propertyType =>
      throw _privateConstructorUsedError; // 계약 종류 추가 (task135)
  ContractType get contractType =>
      throw _privateConstructorUsedError; // 층수 필드 제거됨 (task133)
  int get totalUnits => throw _privateConstructorUsedError;
  int get rent =>
      throw _privateConstructorUsedError; // 소유자 정보 추가 (task134) - 고객관리 기능과 연동 예정
  String? get ownerId => throw _privateConstructorUsedError;
  String? get ownerName => throw _privateConstructorUsedError;
  String? get ownerPhone => throw _privateConstructorUsedError;
  String? get ownerEmail =>
      throw _privateConstructorUsedError; // 청구 목록 선택 기능 (추가 요구사항)
  List<BillingItem> get defaultBillingItems =>
      throw _privateConstructorUsedError;
  List<Unit> get units => throw _privateConstructorUsedError;

  /// Serializes this Property to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Property
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PropertyCopyWith<Property> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PropertyCopyWith<$Res> {
  factory $PropertyCopyWith(Property value, $Res Function(Property) then) =
      _$PropertyCopyWithImpl<$Res, Property>;
  @useResult
  $Res call({
    String id,
    String name,
    String? zipCode,
    String? address1,
    String? address2,
    @Deprecated('Use fullAddress getter instead') String? address,
    PropertyType propertyType,
    ContractType contractType,
    int totalUnits,
    int rent,
    String? ownerId,
    String? ownerName,
    String? ownerPhone,
    String? ownerEmail,
    List<BillingItem> defaultBillingItems,
    List<Unit> units,
  });
}

/// @nodoc
class _$PropertyCopyWithImpl<$Res, $Val extends Property>
    implements $PropertyCopyWith<$Res> {
  _$PropertyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Property
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? zipCode = freezed,
    Object? address1 = freezed,
    Object? address2 = freezed,
    Object? address = freezed,
    Object? propertyType = null,
    Object? contractType = null,
    Object? totalUnits = null,
    Object? rent = null,
    Object? ownerId = freezed,
    Object? ownerName = freezed,
    Object? ownerPhone = freezed,
    Object? ownerEmail = freezed,
    Object? defaultBillingItems = null,
    Object? units = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            zipCode: freezed == zipCode
                ? _value.zipCode
                : zipCode // ignore: cast_nullable_to_non_nullable
                      as String?,
            address1: freezed == address1
                ? _value.address1
                : address1 // ignore: cast_nullable_to_non_nullable
                      as String?,
            address2: freezed == address2
                ? _value.address2
                : address2 // ignore: cast_nullable_to_non_nullable
                      as String?,
            address: freezed == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String?,
            propertyType: null == propertyType
                ? _value.propertyType
                : propertyType // ignore: cast_nullable_to_non_nullable
                      as PropertyType,
            contractType: null == contractType
                ? _value.contractType
                : contractType // ignore: cast_nullable_to_non_nullable
                      as ContractType,
            totalUnits: null == totalUnits
                ? _value.totalUnits
                : totalUnits // ignore: cast_nullable_to_non_nullable
                      as int,
            rent: null == rent
                ? _value.rent
                : rent // ignore: cast_nullable_to_non_nullable
                      as int,
            ownerId: freezed == ownerId
                ? _value.ownerId
                : ownerId // ignore: cast_nullable_to_non_nullable
                      as String?,
            ownerName: freezed == ownerName
                ? _value.ownerName
                : ownerName // ignore: cast_nullable_to_non_nullable
                      as String?,
            ownerPhone: freezed == ownerPhone
                ? _value.ownerPhone
                : ownerPhone // ignore: cast_nullable_to_non_nullable
                      as String?,
            ownerEmail: freezed == ownerEmail
                ? _value.ownerEmail
                : ownerEmail // ignore: cast_nullable_to_non_nullable
                      as String?,
            defaultBillingItems: null == defaultBillingItems
                ? _value.defaultBillingItems
                : defaultBillingItems // ignore: cast_nullable_to_non_nullable
                      as List<BillingItem>,
            units: null == units
                ? _value.units
                : units // ignore: cast_nullable_to_non_nullable
                      as List<Unit>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PropertyImplCopyWith<$Res>
    implements $PropertyCopyWith<$Res> {
  factory _$$PropertyImplCopyWith(
    _$PropertyImpl value,
    $Res Function(_$PropertyImpl) then,
  ) = __$$PropertyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String? zipCode,
    String? address1,
    String? address2,
    @Deprecated('Use fullAddress getter instead') String? address,
    PropertyType propertyType,
    ContractType contractType,
    int totalUnits,
    int rent,
    String? ownerId,
    String? ownerName,
    String? ownerPhone,
    String? ownerEmail,
    List<BillingItem> defaultBillingItems,
    List<Unit> units,
  });
}

/// @nodoc
class __$$PropertyImplCopyWithImpl<$Res>
    extends _$PropertyCopyWithImpl<$Res, _$PropertyImpl>
    implements _$$PropertyImplCopyWith<$Res> {
  __$$PropertyImplCopyWithImpl(
    _$PropertyImpl _value,
    $Res Function(_$PropertyImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Property
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? zipCode = freezed,
    Object? address1 = freezed,
    Object? address2 = freezed,
    Object? address = freezed,
    Object? propertyType = null,
    Object? contractType = null,
    Object? totalUnits = null,
    Object? rent = null,
    Object? ownerId = freezed,
    Object? ownerName = freezed,
    Object? ownerPhone = freezed,
    Object? ownerEmail = freezed,
    Object? defaultBillingItems = null,
    Object? units = null,
  }) {
    return _then(
      _$PropertyImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        zipCode: freezed == zipCode
            ? _value.zipCode
            : zipCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        address1: freezed == address1
            ? _value.address1
            : address1 // ignore: cast_nullable_to_non_nullable
                  as String?,
        address2: freezed == address2
            ? _value.address2
            : address2 // ignore: cast_nullable_to_non_nullable
                  as String?,
        address: freezed == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String?,
        propertyType: null == propertyType
            ? _value.propertyType
            : propertyType // ignore: cast_nullable_to_non_nullable
                  as PropertyType,
        contractType: null == contractType
            ? _value.contractType
            : contractType // ignore: cast_nullable_to_non_nullable
                  as ContractType,
        totalUnits: null == totalUnits
            ? _value.totalUnits
            : totalUnits // ignore: cast_nullable_to_non_nullable
                  as int,
        rent: null == rent
            ? _value.rent
            : rent // ignore: cast_nullable_to_non_nullable
                  as int,
        ownerId: freezed == ownerId
            ? _value.ownerId
            : ownerId // ignore: cast_nullable_to_non_nullable
                  as String?,
        ownerName: freezed == ownerName
            ? _value.ownerName
            : ownerName // ignore: cast_nullable_to_non_nullable
                  as String?,
        ownerPhone: freezed == ownerPhone
            ? _value.ownerPhone
            : ownerPhone // ignore: cast_nullable_to_non_nullable
                  as String?,
        ownerEmail: freezed == ownerEmail
            ? _value.ownerEmail
            : ownerEmail // ignore: cast_nullable_to_non_nullable
                  as String?,
        defaultBillingItems: null == defaultBillingItems
            ? _value._defaultBillingItems
            : defaultBillingItems // ignore: cast_nullable_to_non_nullable
                  as List<BillingItem>,
        units: null == units
            ? _value._units
            : units // ignore: cast_nullable_to_non_nullable
                  as List<Unit>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PropertyImpl extends _Property {
  const _$PropertyImpl({
    required this.id,
    required this.name,
    this.zipCode,
    this.address1,
    this.address2,
    @Deprecated('Use fullAddress getter instead') this.address,
    this.propertyType = PropertyType.villa,
    this.contractType = ContractType.wolse,
    required this.totalUnits,
    this.rent = 0,
    this.ownerId,
    this.ownerName,
    this.ownerPhone,
    this.ownerEmail,
    final List<BillingItem> defaultBillingItems = const [],
    final List<Unit> units = const [],
  }) : _defaultBillingItems = defaultBillingItems,
       _units = units,
       super._();

  factory _$PropertyImpl.fromJson(Map<String, dynamic> json) =>
      _$$PropertyImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  // 주소 구조 변경 (task136)
  @override
  final String? zipCode;
  // 우편번호
  @override
  final String? address1;
  // 주소1
  @override
  final String? address2;
  // 상세주소
  @override
  @Deprecated('Use fullAddress getter instead')
  final String? address;
  // 기존 호환성을 위해 유지
  // 자산 유형을 enum으로 변경 (task132)
  @override
  @JsonKey()
  final PropertyType propertyType;
  // 계약 종류 추가 (task135)
  @override
  @JsonKey()
  final ContractType contractType;
  // 층수 필드 제거됨 (task133)
  @override
  final int totalUnits;
  @override
  @JsonKey()
  final int rent;
  // 소유자 정보 추가 (task134) - 고객관리 기능과 연동 예정
  @override
  final String? ownerId;
  @override
  final String? ownerName;
  @override
  final String? ownerPhone;
  @override
  final String? ownerEmail;
  // 청구 목록 선택 기능 (추가 요구사항)
  final List<BillingItem> _defaultBillingItems;
  // 청구 목록 선택 기능 (추가 요구사항)
  @override
  @JsonKey()
  List<BillingItem> get defaultBillingItems {
    if (_defaultBillingItems is EqualUnmodifiableListView)
      return _defaultBillingItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_defaultBillingItems);
  }

  final List<Unit> _units;
  @override
  @JsonKey()
  List<Unit> get units {
    if (_units is EqualUnmodifiableListView) return _units;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_units);
  }

  @override
  String toString() {
    return 'Property(id: $id, name: $name, zipCode: $zipCode, address1: $address1, address2: $address2, address: $address, propertyType: $propertyType, contractType: $contractType, totalUnits: $totalUnits, rent: $rent, ownerId: $ownerId, ownerName: $ownerName, ownerPhone: $ownerPhone, ownerEmail: $ownerEmail, defaultBillingItems: $defaultBillingItems, units: $units)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PropertyImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.zipCode, zipCode) || other.zipCode == zipCode) &&
            (identical(other.address1, address1) ||
                other.address1 == address1) &&
            (identical(other.address2, address2) ||
                other.address2 == address2) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.propertyType, propertyType) ||
                other.propertyType == propertyType) &&
            (identical(other.contractType, contractType) ||
                other.contractType == contractType) &&
            (identical(other.totalUnits, totalUnits) ||
                other.totalUnits == totalUnits) &&
            (identical(other.rent, rent) || other.rent == rent) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.ownerName, ownerName) ||
                other.ownerName == ownerName) &&
            (identical(other.ownerPhone, ownerPhone) ||
                other.ownerPhone == ownerPhone) &&
            (identical(other.ownerEmail, ownerEmail) ||
                other.ownerEmail == ownerEmail) &&
            const DeepCollectionEquality().equals(
              other._defaultBillingItems,
              _defaultBillingItems,
            ) &&
            const DeepCollectionEquality().equals(other._units, _units));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    zipCode,
    address1,
    address2,
    address,
    propertyType,
    contractType,
    totalUnits,
    rent,
    ownerId,
    ownerName,
    ownerPhone,
    ownerEmail,
    const DeepCollectionEquality().hash(_defaultBillingItems),
    const DeepCollectionEquality().hash(_units),
  );

  /// Create a copy of Property
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PropertyImplCopyWith<_$PropertyImpl> get copyWith =>
      __$$PropertyImplCopyWithImpl<_$PropertyImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PropertyImplToJson(this);
  }
}

abstract class _Property extends Property {
  const factory _Property({
    required final String id,
    required final String name,
    final String? zipCode,
    final String? address1,
    final String? address2,
    @Deprecated('Use fullAddress getter instead') final String? address,
    final PropertyType propertyType,
    final ContractType contractType,
    required final int totalUnits,
    final int rent,
    final String? ownerId,
    final String? ownerName,
    final String? ownerPhone,
    final String? ownerEmail,
    final List<BillingItem> defaultBillingItems,
    final List<Unit> units,
  }) = _$PropertyImpl;
  const _Property._() : super._();

  factory _Property.fromJson(Map<String, dynamic> json) =
      _$PropertyImpl.fromJson;

  @override
  String get id;
  @override
  String get name; // 주소 구조 변경 (task136)
  @override
  String? get zipCode; // 우편번호
  @override
  String? get address1; // 주소1
  @override
  String? get address2; // 상세주소
  @override
  @Deprecated('Use fullAddress getter instead')
  String? get address; // 기존 호환성을 위해 유지
  // 자산 유형을 enum으로 변경 (task132)
  @override
  PropertyType get propertyType; // 계약 종류 추가 (task135)
  @override
  ContractType get contractType; // 층수 필드 제거됨 (task133)
  @override
  int get totalUnits;
  @override
  int get rent; // 소유자 정보 추가 (task134) - 고객관리 기능과 연동 예정
  @override
  String? get ownerId;
  @override
  String? get ownerName;
  @override
  String? get ownerPhone;
  @override
  String? get ownerEmail; // 청구 목록 선택 기능 (추가 요구사항)
  @override
  List<BillingItem> get defaultBillingItems;
  @override
  List<Unit> get units;

  /// Create a copy of Property
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PropertyImplCopyWith<_$PropertyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
