// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'billing_item.dart';

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
  String get id => throw _privateConstructorUsedError;
  String get billingId => throw _privateConstructorUsedError;
  String get billTemplateId => throw _privateConstructorUsedError;
  int get amount => throw _privateConstructorUsedError;
  String? get itemName => throw _privateConstructorUsedError;

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
  $Res call({
    String id,
    String billingId,
    String billTemplateId,
    int amount,
    String? itemName,
  });
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
    Object? id = null,
    Object? billingId = null,
    Object? billTemplateId = null,
    Object? amount = null,
    Object? itemName = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            billingId: null == billingId
                ? _value.billingId
                : billingId // ignore: cast_nullable_to_non_nullable
                      as String,
            billTemplateId: null == billTemplateId
                ? _value.billTemplateId
                : billTemplateId // ignore: cast_nullable_to_non_nullable
                      as String,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as int,
            itemName: freezed == itemName
                ? _value.itemName
                : itemName // ignore: cast_nullable_to_non_nullable
                      as String?,
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
  $Res call({
    String id,
    String billingId,
    String billTemplateId,
    int amount,
    String? itemName,
  });
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
    Object? id = null,
    Object? billingId = null,
    Object? billTemplateId = null,
    Object? amount = null,
    Object? itemName = freezed,
  }) {
    return _then(
      _$BillingItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        billingId: null == billingId
            ? _value.billingId
            : billingId // ignore: cast_nullable_to_non_nullable
                  as String,
        billTemplateId: null == billTemplateId
            ? _value.billTemplateId
            : billTemplateId // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as int,
        itemName: freezed == itemName
            ? _value.itemName
            : itemName // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BillingItemImpl implements _BillingItem {
  const _$BillingItemImpl({
    required this.id,
    required this.billingId,
    required this.billTemplateId,
    required this.amount,
    this.itemName,
  });

  factory _$BillingItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$BillingItemImplFromJson(json);

  @override
  final String id;
  @override
  final String billingId;
  @override
  final String billTemplateId;
  @override
  final int amount;
  @override
  final String? itemName;

  @override
  String toString() {
    return 'BillingItem(id: $id, billingId: $billingId, billTemplateId: $billTemplateId, amount: $amount, itemName: $itemName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BillingItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.billingId, billingId) ||
                other.billingId == billingId) &&
            (identical(other.billTemplateId, billTemplateId) ||
                other.billTemplateId == billTemplateId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.itemName, itemName) ||
                other.itemName == itemName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, billingId, billTemplateId, amount, itemName);

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
    required final String id,
    required final String billingId,
    required final String billTemplateId,
    required final int amount,
    final String? itemName,
  }) = _$BillingItemImpl;

  factory _BillingItem.fromJson(Map<String, dynamic> json) =
      _$BillingItemImpl.fromJson;

  @override
  String get id;
  @override
  String get billingId;
  @override
  String get billTemplateId;
  @override
  int get amount;
  @override
  String? get itemName;

  /// Create a copy of BillingItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BillingItemImplCopyWith<_$BillingItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
