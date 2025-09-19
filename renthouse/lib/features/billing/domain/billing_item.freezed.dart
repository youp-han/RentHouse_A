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
  String? get itemName =>
      throw _privateConstructorUsedError; // 템플릿 이름을 직접 저장 (템플릿을 찾을 수 없을 때 사용)
  int get quantity => throw _privateConstructorUsedError; // 수량
  int get unitPrice => throw _privateConstructorUsedError; // 단가
  int get tax => throw _privateConstructorUsedError; // 세금
  String? get memo => throw _privateConstructorUsedError;

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
    int quantity,
    int unitPrice,
    int tax,
    String? memo,
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
    Object? quantity = null,
    Object? unitPrice = null,
    Object? tax = null,
    Object? memo = freezed,
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
            quantity: null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as int,
            unitPrice: null == unitPrice
                ? _value.unitPrice
                : unitPrice // ignore: cast_nullable_to_non_nullable
                      as int,
            tax: null == tax
                ? _value.tax
                : tax // ignore: cast_nullable_to_non_nullable
                      as int,
            memo: freezed == memo
                ? _value.memo
                : memo // ignore: cast_nullable_to_non_nullable
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
    int quantity,
    int unitPrice,
    int tax,
    String? memo,
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
    Object? quantity = null,
    Object? unitPrice = null,
    Object? tax = null,
    Object? memo = freezed,
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
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as int,
        unitPrice: null == unitPrice
            ? _value.unitPrice
            : unitPrice // ignore: cast_nullable_to_non_nullable
                  as int,
        tax: null == tax
            ? _value.tax
            : tax // ignore: cast_nullable_to_non_nullable
                  as int,
        memo: freezed == memo
            ? _value.memo
            : memo // ignore: cast_nullable_to_non_nullable
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
    this.quantity = 1,
    this.unitPrice = 0,
    this.tax = 0,
    this.memo,
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
  // 템플릿 이름을 직접 저장 (템플릿을 찾을 수 없을 때 사용)
  @override
  @JsonKey()
  final int quantity;
  // 수량
  @override
  @JsonKey()
  final int unitPrice;
  // 단가
  @override
  @JsonKey()
  final int tax;
  // 세금
  @override
  final String? memo;

  @override
  String toString() {
    return 'BillingItem(id: $id, billingId: $billingId, billTemplateId: $billTemplateId, amount: $amount, itemName: $itemName, quantity: $quantity, unitPrice: $unitPrice, tax: $tax, memo: $memo)';
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
                other.itemName == itemName) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice) &&
            (identical(other.tax, tax) || other.tax == tax) &&
            (identical(other.memo, memo) || other.memo == memo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    billingId,
    billTemplateId,
    amount,
    itemName,
    quantity,
    unitPrice,
    tax,
    memo,
  );

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
    final int quantity,
    final int unitPrice,
    final int tax,
    final String? memo,
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
  String? get itemName; // 템플릿 이름을 직접 저장 (템플릿을 찾을 수 없을 때 사용)
  @override
  int get quantity; // 수량
  @override
  int get unitPrice; // 단가
  @override
  int get tax; // 세금
  @override
  String? get memo;

  /// Create a copy of BillingItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BillingItemImplCopyWith<_$BillingItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
