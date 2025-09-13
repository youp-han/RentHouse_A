// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'receipt.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Receipt _$ReceiptFromJson(Map<String, dynamic> json) {
  return _Receipt.fromJson(json);
}

/// @nodoc
mixin _$Receipt {
  String get id => throw _privateConstructorUsedError;
  String get paymentId => throw _privateConstructorUsedError;
  String get tenantId => throw _privateConstructorUsedError;
  String get tenantName => throw _privateConstructorUsedError;
  String get tenantPhone => throw _privateConstructorUsedError;
  PaymentMethod get paymentMethod => throw _privateConstructorUsedError;
  int get totalAmount => throw _privateConstructorUsedError;
  DateTime get paidDate => throw _privateConstructorUsedError;
  DateTime get issuedDate => throw _privateConstructorUsedError;
  String? get memo => throw _privateConstructorUsedError;
  List<ReceiptItem> get items => throw _privateConstructorUsedError;

  /// Serializes this Receipt to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Receipt
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReceiptCopyWith<Receipt> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReceiptCopyWith<$Res> {
  factory $ReceiptCopyWith(Receipt value, $Res Function(Receipt) then) =
      _$ReceiptCopyWithImpl<$Res, Receipt>;
  @useResult
  $Res call({
    String id,
    String paymentId,
    String tenantId,
    String tenantName,
    String tenantPhone,
    PaymentMethod paymentMethod,
    int totalAmount,
    DateTime paidDate,
    DateTime issuedDate,
    String? memo,
    List<ReceiptItem> items,
  });
}

/// @nodoc
class _$ReceiptCopyWithImpl<$Res, $Val extends Receipt>
    implements $ReceiptCopyWith<$Res> {
  _$ReceiptCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Receipt
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? paymentId = null,
    Object? tenantId = null,
    Object? tenantName = null,
    Object? tenantPhone = null,
    Object? paymentMethod = null,
    Object? totalAmount = null,
    Object? paidDate = null,
    Object? issuedDate = null,
    Object? memo = freezed,
    Object? items = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            paymentId: null == paymentId
                ? _value.paymentId
                : paymentId // ignore: cast_nullable_to_non_nullable
                      as String,
            tenantId: null == tenantId
                ? _value.tenantId
                : tenantId // ignore: cast_nullable_to_non_nullable
                      as String,
            tenantName: null == tenantName
                ? _value.tenantName
                : tenantName // ignore: cast_nullable_to_non_nullable
                      as String,
            tenantPhone: null == tenantPhone
                ? _value.tenantPhone
                : tenantPhone // ignore: cast_nullable_to_non_nullable
                      as String,
            paymentMethod: null == paymentMethod
                ? _value.paymentMethod
                : paymentMethod // ignore: cast_nullable_to_non_nullable
                      as PaymentMethod,
            totalAmount: null == totalAmount
                ? _value.totalAmount
                : totalAmount // ignore: cast_nullable_to_non_nullable
                      as int,
            paidDate: null == paidDate
                ? _value.paidDate
                : paidDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            issuedDate: null == issuedDate
                ? _value.issuedDate
                : issuedDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            memo: freezed == memo
                ? _value.memo
                : memo // ignore: cast_nullable_to_non_nullable
                      as String?,
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<ReceiptItem>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReceiptImplCopyWith<$Res> implements $ReceiptCopyWith<$Res> {
  factory _$$ReceiptImplCopyWith(
    _$ReceiptImpl value,
    $Res Function(_$ReceiptImpl) then,
  ) = __$$ReceiptImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String paymentId,
    String tenantId,
    String tenantName,
    String tenantPhone,
    PaymentMethod paymentMethod,
    int totalAmount,
    DateTime paidDate,
    DateTime issuedDate,
    String? memo,
    List<ReceiptItem> items,
  });
}

/// @nodoc
class __$$ReceiptImplCopyWithImpl<$Res>
    extends _$ReceiptCopyWithImpl<$Res, _$ReceiptImpl>
    implements _$$ReceiptImplCopyWith<$Res> {
  __$$ReceiptImplCopyWithImpl(
    _$ReceiptImpl _value,
    $Res Function(_$ReceiptImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Receipt
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? paymentId = null,
    Object? tenantId = null,
    Object? tenantName = null,
    Object? tenantPhone = null,
    Object? paymentMethod = null,
    Object? totalAmount = null,
    Object? paidDate = null,
    Object? issuedDate = null,
    Object? memo = freezed,
    Object? items = null,
  }) {
    return _then(
      _$ReceiptImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        paymentId: null == paymentId
            ? _value.paymentId
            : paymentId // ignore: cast_nullable_to_non_nullable
                  as String,
        tenantId: null == tenantId
            ? _value.tenantId
            : tenantId // ignore: cast_nullable_to_non_nullable
                  as String,
        tenantName: null == tenantName
            ? _value.tenantName
            : tenantName // ignore: cast_nullable_to_non_nullable
                  as String,
        tenantPhone: null == tenantPhone
            ? _value.tenantPhone
            : tenantPhone // ignore: cast_nullable_to_non_nullable
                  as String,
        paymentMethod: null == paymentMethod
            ? _value.paymentMethod
            : paymentMethod // ignore: cast_nullable_to_non_nullable
                  as PaymentMethod,
        totalAmount: null == totalAmount
            ? _value.totalAmount
            : totalAmount // ignore: cast_nullable_to_non_nullable
                  as int,
        paidDate: null == paidDate
            ? _value.paidDate
            : paidDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        issuedDate: null == issuedDate
            ? _value.issuedDate
            : issuedDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        memo: freezed == memo
            ? _value.memo
            : memo // ignore: cast_nullable_to_non_nullable
                  as String?,
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<ReceiptItem>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReceiptImpl implements _Receipt {
  const _$ReceiptImpl({
    required this.id,
    required this.paymentId,
    required this.tenantId,
    required this.tenantName,
    required this.tenantPhone,
    required this.paymentMethod,
    required this.totalAmount,
    required this.paidDate,
    required this.issuedDate,
    this.memo,
    required final List<ReceiptItem> items,
  }) : _items = items;

  factory _$ReceiptImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReceiptImplFromJson(json);

  @override
  final String id;
  @override
  final String paymentId;
  @override
  final String tenantId;
  @override
  final String tenantName;
  @override
  final String tenantPhone;
  @override
  final PaymentMethod paymentMethod;
  @override
  final int totalAmount;
  @override
  final DateTime paidDate;
  @override
  final DateTime issuedDate;
  @override
  final String? memo;
  final List<ReceiptItem> _items;
  @override
  List<ReceiptItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'Receipt(id: $id, paymentId: $paymentId, tenantId: $tenantId, tenantName: $tenantName, tenantPhone: $tenantPhone, paymentMethod: $paymentMethod, totalAmount: $totalAmount, paidDate: $paidDate, issuedDate: $issuedDate, memo: $memo, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReceiptImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.paymentId, paymentId) ||
                other.paymentId == paymentId) &&
            (identical(other.tenantId, tenantId) ||
                other.tenantId == tenantId) &&
            (identical(other.tenantName, tenantName) ||
                other.tenantName == tenantName) &&
            (identical(other.tenantPhone, tenantPhone) ||
                other.tenantPhone == tenantPhone) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.paidDate, paidDate) ||
                other.paidDate == paidDate) &&
            (identical(other.issuedDate, issuedDate) ||
                other.issuedDate == issuedDate) &&
            (identical(other.memo, memo) || other.memo == memo) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    paymentId,
    tenantId,
    tenantName,
    tenantPhone,
    paymentMethod,
    totalAmount,
    paidDate,
    issuedDate,
    memo,
    const DeepCollectionEquality().hash(_items),
  );

  /// Create a copy of Receipt
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReceiptImplCopyWith<_$ReceiptImpl> get copyWith =>
      __$$ReceiptImplCopyWithImpl<_$ReceiptImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReceiptImplToJson(this);
  }
}

abstract class _Receipt implements Receipt {
  const factory _Receipt({
    required final String id,
    required final String paymentId,
    required final String tenantId,
    required final String tenantName,
    required final String tenantPhone,
    required final PaymentMethod paymentMethod,
    required final int totalAmount,
    required final DateTime paidDate,
    required final DateTime issuedDate,
    final String? memo,
    required final List<ReceiptItem> items,
  }) = _$ReceiptImpl;

  factory _Receipt.fromJson(Map<String, dynamic> json) = _$ReceiptImpl.fromJson;

  @override
  String get id;
  @override
  String get paymentId;
  @override
  String get tenantId;
  @override
  String get tenantName;
  @override
  String get tenantPhone;
  @override
  PaymentMethod get paymentMethod;
  @override
  int get totalAmount;
  @override
  DateTime get paidDate;
  @override
  DateTime get issuedDate;
  @override
  String? get memo;
  @override
  List<ReceiptItem> get items;

  /// Create a copy of Receipt
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReceiptImplCopyWith<_$ReceiptImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReceiptItem _$ReceiptItemFromJson(Map<String, dynamic> json) {
  return _ReceiptItem.fromJson(json);
}

/// @nodoc
mixin _$ReceiptItem {
  String get billingId => throw _privateConstructorUsedError;
  String get yearMonth => throw _privateConstructorUsedError;
  String get propertyName => throw _privateConstructorUsedError;
  String get unitNumber => throw _privateConstructorUsedError;
  int get amount => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;

  /// Serializes this ReceiptItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReceiptItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReceiptItemCopyWith<ReceiptItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReceiptItemCopyWith<$Res> {
  factory $ReceiptItemCopyWith(
    ReceiptItem value,
    $Res Function(ReceiptItem) then,
  ) = _$ReceiptItemCopyWithImpl<$Res, ReceiptItem>;
  @useResult
  $Res call({
    String billingId,
    String yearMonth,
    String propertyName,
    String unitNumber,
    int amount,
    String description,
  });
}

/// @nodoc
class _$ReceiptItemCopyWithImpl<$Res, $Val extends ReceiptItem>
    implements $ReceiptItemCopyWith<$Res> {
  _$ReceiptItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReceiptItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? billingId = null,
    Object? yearMonth = null,
    Object? propertyName = null,
    Object? unitNumber = null,
    Object? amount = null,
    Object? description = null,
  }) {
    return _then(
      _value.copyWith(
            billingId: null == billingId
                ? _value.billingId
                : billingId // ignore: cast_nullable_to_non_nullable
                      as String,
            yearMonth: null == yearMonth
                ? _value.yearMonth
                : yearMonth // ignore: cast_nullable_to_non_nullable
                      as String,
            propertyName: null == propertyName
                ? _value.propertyName
                : propertyName // ignore: cast_nullable_to_non_nullable
                      as String,
            unitNumber: null == unitNumber
                ? _value.unitNumber
                : unitNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as int,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReceiptItemImplCopyWith<$Res>
    implements $ReceiptItemCopyWith<$Res> {
  factory _$$ReceiptItemImplCopyWith(
    _$ReceiptItemImpl value,
    $Res Function(_$ReceiptItemImpl) then,
  ) = __$$ReceiptItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String billingId,
    String yearMonth,
    String propertyName,
    String unitNumber,
    int amount,
    String description,
  });
}

/// @nodoc
class __$$ReceiptItemImplCopyWithImpl<$Res>
    extends _$ReceiptItemCopyWithImpl<$Res, _$ReceiptItemImpl>
    implements _$$ReceiptItemImplCopyWith<$Res> {
  __$$ReceiptItemImplCopyWithImpl(
    _$ReceiptItemImpl _value,
    $Res Function(_$ReceiptItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReceiptItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? billingId = null,
    Object? yearMonth = null,
    Object? propertyName = null,
    Object? unitNumber = null,
    Object? amount = null,
    Object? description = null,
  }) {
    return _then(
      _$ReceiptItemImpl(
        billingId: null == billingId
            ? _value.billingId
            : billingId // ignore: cast_nullable_to_non_nullable
                  as String,
        yearMonth: null == yearMonth
            ? _value.yearMonth
            : yearMonth // ignore: cast_nullable_to_non_nullable
                  as String,
        propertyName: null == propertyName
            ? _value.propertyName
            : propertyName // ignore: cast_nullable_to_non_nullable
                  as String,
        unitNumber: null == unitNumber
            ? _value.unitNumber
            : unitNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as int,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReceiptItemImpl implements _ReceiptItem {
  const _$ReceiptItemImpl({
    required this.billingId,
    required this.yearMonth,
    required this.propertyName,
    required this.unitNumber,
    required this.amount,
    required this.description,
  });

  factory _$ReceiptItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReceiptItemImplFromJson(json);

  @override
  final String billingId;
  @override
  final String yearMonth;
  @override
  final String propertyName;
  @override
  final String unitNumber;
  @override
  final int amount;
  @override
  final String description;

  @override
  String toString() {
    return 'ReceiptItem(billingId: $billingId, yearMonth: $yearMonth, propertyName: $propertyName, unitNumber: $unitNumber, amount: $amount, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReceiptItemImpl &&
            (identical(other.billingId, billingId) ||
                other.billingId == billingId) &&
            (identical(other.yearMonth, yearMonth) ||
                other.yearMonth == yearMonth) &&
            (identical(other.propertyName, propertyName) ||
                other.propertyName == propertyName) &&
            (identical(other.unitNumber, unitNumber) ||
                other.unitNumber == unitNumber) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    billingId,
    yearMonth,
    propertyName,
    unitNumber,
    amount,
    description,
  );

  /// Create a copy of ReceiptItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReceiptItemImplCopyWith<_$ReceiptItemImpl> get copyWith =>
      __$$ReceiptItemImplCopyWithImpl<_$ReceiptItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReceiptItemImplToJson(this);
  }
}

abstract class _ReceiptItem implements ReceiptItem {
  const factory _ReceiptItem({
    required final String billingId,
    required final String yearMonth,
    required final String propertyName,
    required final String unitNumber,
    required final int amount,
    required final String description,
  }) = _$ReceiptItemImpl;

  factory _ReceiptItem.fromJson(Map<String, dynamic> json) =
      _$ReceiptItemImpl.fromJson;

  @override
  String get billingId;
  @override
  String get yearMonth;
  @override
  String get propertyName;
  @override
  String get unitNumber;
  @override
  int get amount;
  @override
  String get description;

  /// Create a copy of ReceiptItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReceiptItemImplCopyWith<_$ReceiptItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
