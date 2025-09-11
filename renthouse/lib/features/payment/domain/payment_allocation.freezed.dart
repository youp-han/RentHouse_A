// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_allocation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PaymentAllocation _$PaymentAllocationFromJson(Map<String, dynamic> json) {
  return _PaymentAllocation.fromJson(json);
}

/// @nodoc
mixin _$PaymentAllocation {
  String get id => throw _privateConstructorUsedError;
  String get paymentId => throw _privateConstructorUsedError;
  String get billingId => throw _privateConstructorUsedError;
  int get amount => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this PaymentAllocation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaymentAllocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentAllocationCopyWith<PaymentAllocation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentAllocationCopyWith<$Res> {
  factory $PaymentAllocationCopyWith(
    PaymentAllocation value,
    $Res Function(PaymentAllocation) then,
  ) = _$PaymentAllocationCopyWithImpl<$Res, PaymentAllocation>;
  @useResult
  $Res call({
    String id,
    String paymentId,
    String billingId,
    int amount,
    DateTime createdAt,
  });
}

/// @nodoc
class _$PaymentAllocationCopyWithImpl<$Res, $Val extends PaymentAllocation>
    implements $PaymentAllocationCopyWith<$Res> {
  _$PaymentAllocationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentAllocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? paymentId = null,
    Object? billingId = null,
    Object? amount = null,
    Object? createdAt = null,
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
            billingId: null == billingId
                ? _value.billingId
                : billingId // ignore: cast_nullable_to_non_nullable
                      as String,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as int,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PaymentAllocationImplCopyWith<$Res>
    implements $PaymentAllocationCopyWith<$Res> {
  factory _$$PaymentAllocationImplCopyWith(
    _$PaymentAllocationImpl value,
    $Res Function(_$PaymentAllocationImpl) then,
  ) = __$$PaymentAllocationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String paymentId,
    String billingId,
    int amount,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$PaymentAllocationImplCopyWithImpl<$Res>
    extends _$PaymentAllocationCopyWithImpl<$Res, _$PaymentAllocationImpl>
    implements _$$PaymentAllocationImplCopyWith<$Res> {
  __$$PaymentAllocationImplCopyWithImpl(
    _$PaymentAllocationImpl _value,
    $Res Function(_$PaymentAllocationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaymentAllocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? paymentId = null,
    Object? billingId = null,
    Object? amount = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$PaymentAllocationImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        paymentId: null == paymentId
            ? _value.paymentId
            : paymentId // ignore: cast_nullable_to_non_nullable
                  as String,
        billingId: null == billingId
            ? _value.billingId
            : billingId // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as int,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentAllocationImpl implements _PaymentAllocation {
  const _$PaymentAllocationImpl({
    required this.id,
    required this.paymentId,
    required this.billingId,
    required this.amount,
    required this.createdAt,
  });

  factory _$PaymentAllocationImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentAllocationImplFromJson(json);

  @override
  final String id;
  @override
  final String paymentId;
  @override
  final String billingId;
  @override
  final int amount;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'PaymentAllocation(id: $id, paymentId: $paymentId, billingId: $billingId, amount: $amount, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentAllocationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.paymentId, paymentId) ||
                other.paymentId == paymentId) &&
            (identical(other.billingId, billingId) ||
                other.billingId == billingId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, paymentId, billingId, amount, createdAt);

  /// Create a copy of PaymentAllocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentAllocationImplCopyWith<_$PaymentAllocationImpl> get copyWith =>
      __$$PaymentAllocationImplCopyWithImpl<_$PaymentAllocationImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentAllocationImplToJson(this);
  }
}

abstract class _PaymentAllocation implements PaymentAllocation {
  const factory _PaymentAllocation({
    required final String id,
    required final String paymentId,
    required final String billingId,
    required final int amount,
    required final DateTime createdAt,
  }) = _$PaymentAllocationImpl;

  factory _PaymentAllocation.fromJson(Map<String, dynamic> json) =
      _$PaymentAllocationImpl.fromJson;

  @override
  String get id;
  @override
  String get paymentId;
  @override
  String get billingId;
  @override
  int get amount;
  @override
  DateTime get createdAt;

  /// Create a copy of PaymentAllocation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentAllocationImplCopyWith<_$PaymentAllocationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PaymentAllocationPreview _$PaymentAllocationPreviewFromJson(
  Map<String, dynamic> json,
) {
  return _PaymentAllocationPreview.fromJson(json);
}

/// @nodoc
mixin _$PaymentAllocationPreview {
  String get billingId => throw _privateConstructorUsedError;
  String get yearMonth => throw _privateConstructorUsedError;
  int get billingAmount => throw _privateConstructorUsedError;
  int get paidAmount => throw _privateConstructorUsedError;
  int get allocationAmount => throw _privateConstructorUsedError;
  int get remainingAmount => throw _privateConstructorUsedError;

  /// Serializes this PaymentAllocationPreview to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaymentAllocationPreview
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentAllocationPreviewCopyWith<PaymentAllocationPreview> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentAllocationPreviewCopyWith<$Res> {
  factory $PaymentAllocationPreviewCopyWith(
    PaymentAllocationPreview value,
    $Res Function(PaymentAllocationPreview) then,
  ) = _$PaymentAllocationPreviewCopyWithImpl<$Res, PaymentAllocationPreview>;
  @useResult
  $Res call({
    String billingId,
    String yearMonth,
    int billingAmount,
    int paidAmount,
    int allocationAmount,
    int remainingAmount,
  });
}

/// @nodoc
class _$PaymentAllocationPreviewCopyWithImpl<
  $Res,
  $Val extends PaymentAllocationPreview
>
    implements $PaymentAllocationPreviewCopyWith<$Res> {
  _$PaymentAllocationPreviewCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentAllocationPreview
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? billingId = null,
    Object? yearMonth = null,
    Object? billingAmount = null,
    Object? paidAmount = null,
    Object? allocationAmount = null,
    Object? remainingAmount = null,
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
            billingAmount: null == billingAmount
                ? _value.billingAmount
                : billingAmount // ignore: cast_nullable_to_non_nullable
                      as int,
            paidAmount: null == paidAmount
                ? _value.paidAmount
                : paidAmount // ignore: cast_nullable_to_non_nullable
                      as int,
            allocationAmount: null == allocationAmount
                ? _value.allocationAmount
                : allocationAmount // ignore: cast_nullable_to_non_nullable
                      as int,
            remainingAmount: null == remainingAmount
                ? _value.remainingAmount
                : remainingAmount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PaymentAllocationPreviewImplCopyWith<$Res>
    implements $PaymentAllocationPreviewCopyWith<$Res> {
  factory _$$PaymentAllocationPreviewImplCopyWith(
    _$PaymentAllocationPreviewImpl value,
    $Res Function(_$PaymentAllocationPreviewImpl) then,
  ) = __$$PaymentAllocationPreviewImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String billingId,
    String yearMonth,
    int billingAmount,
    int paidAmount,
    int allocationAmount,
    int remainingAmount,
  });
}

/// @nodoc
class __$$PaymentAllocationPreviewImplCopyWithImpl<$Res>
    extends
        _$PaymentAllocationPreviewCopyWithImpl<
          $Res,
          _$PaymentAllocationPreviewImpl
        >
    implements _$$PaymentAllocationPreviewImplCopyWith<$Res> {
  __$$PaymentAllocationPreviewImplCopyWithImpl(
    _$PaymentAllocationPreviewImpl _value,
    $Res Function(_$PaymentAllocationPreviewImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaymentAllocationPreview
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? billingId = null,
    Object? yearMonth = null,
    Object? billingAmount = null,
    Object? paidAmount = null,
    Object? allocationAmount = null,
    Object? remainingAmount = null,
  }) {
    return _then(
      _$PaymentAllocationPreviewImpl(
        billingId: null == billingId
            ? _value.billingId
            : billingId // ignore: cast_nullable_to_non_nullable
                  as String,
        yearMonth: null == yearMonth
            ? _value.yearMonth
            : yearMonth // ignore: cast_nullable_to_non_nullable
                  as String,
        billingAmount: null == billingAmount
            ? _value.billingAmount
            : billingAmount // ignore: cast_nullable_to_non_nullable
                  as int,
        paidAmount: null == paidAmount
            ? _value.paidAmount
            : paidAmount // ignore: cast_nullable_to_non_nullable
                  as int,
        allocationAmount: null == allocationAmount
            ? _value.allocationAmount
            : allocationAmount // ignore: cast_nullable_to_non_nullable
                  as int,
        remainingAmount: null == remainingAmount
            ? _value.remainingAmount
            : remainingAmount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentAllocationPreviewImpl implements _PaymentAllocationPreview {
  const _$PaymentAllocationPreviewImpl({
    required this.billingId,
    required this.yearMonth,
    required this.billingAmount,
    required this.paidAmount,
    required this.allocationAmount,
    required this.remainingAmount,
  });

  factory _$PaymentAllocationPreviewImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentAllocationPreviewImplFromJson(json);

  @override
  final String billingId;
  @override
  final String yearMonth;
  @override
  final int billingAmount;
  @override
  final int paidAmount;
  @override
  final int allocationAmount;
  @override
  final int remainingAmount;

  @override
  String toString() {
    return 'PaymentAllocationPreview(billingId: $billingId, yearMonth: $yearMonth, billingAmount: $billingAmount, paidAmount: $paidAmount, allocationAmount: $allocationAmount, remainingAmount: $remainingAmount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentAllocationPreviewImpl &&
            (identical(other.billingId, billingId) ||
                other.billingId == billingId) &&
            (identical(other.yearMonth, yearMonth) ||
                other.yearMonth == yearMonth) &&
            (identical(other.billingAmount, billingAmount) ||
                other.billingAmount == billingAmount) &&
            (identical(other.paidAmount, paidAmount) ||
                other.paidAmount == paidAmount) &&
            (identical(other.allocationAmount, allocationAmount) ||
                other.allocationAmount == allocationAmount) &&
            (identical(other.remainingAmount, remainingAmount) ||
                other.remainingAmount == remainingAmount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    billingId,
    yearMonth,
    billingAmount,
    paidAmount,
    allocationAmount,
    remainingAmount,
  );

  /// Create a copy of PaymentAllocationPreview
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentAllocationPreviewImplCopyWith<_$PaymentAllocationPreviewImpl>
  get copyWith =>
      __$$PaymentAllocationPreviewImplCopyWithImpl<
        _$PaymentAllocationPreviewImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentAllocationPreviewImplToJson(this);
  }
}

abstract class _PaymentAllocationPreview implements PaymentAllocationPreview {
  const factory _PaymentAllocationPreview({
    required final String billingId,
    required final String yearMonth,
    required final int billingAmount,
    required final int paidAmount,
    required final int allocationAmount,
    required final int remainingAmount,
  }) = _$PaymentAllocationPreviewImpl;

  factory _PaymentAllocationPreview.fromJson(Map<String, dynamic> json) =
      _$PaymentAllocationPreviewImpl.fromJson;

  @override
  String get billingId;
  @override
  String get yearMonth;
  @override
  int get billingAmount;
  @override
  int get paidAmount;
  @override
  int get allocationAmount;
  @override
  int get remainingAmount;

  /// Create a copy of PaymentAllocationPreview
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentAllocationPreviewImplCopyWith<_$PaymentAllocationPreviewImpl>
  get copyWith => throw _privateConstructorUsedError;
}

AutoAllocationResult _$AutoAllocationResultFromJson(Map<String, dynamic> json) {
  return _AutoAllocationResult.fromJson(json);
}

/// @nodoc
mixin _$AutoAllocationResult {
  int get totalAmount => throw _privateConstructorUsedError;
  int get allocatedAmount => throw _privateConstructorUsedError;
  int get remainingAmount => throw _privateConstructorUsedError;
  List<PaymentAllocationPreview> get allocations =>
      throw _privateConstructorUsedError;

  /// Serializes this AutoAllocationResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AutoAllocationResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AutoAllocationResultCopyWith<AutoAllocationResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AutoAllocationResultCopyWith<$Res> {
  factory $AutoAllocationResultCopyWith(
    AutoAllocationResult value,
    $Res Function(AutoAllocationResult) then,
  ) = _$AutoAllocationResultCopyWithImpl<$Res, AutoAllocationResult>;
  @useResult
  $Res call({
    int totalAmount,
    int allocatedAmount,
    int remainingAmount,
    List<PaymentAllocationPreview> allocations,
  });
}

/// @nodoc
class _$AutoAllocationResultCopyWithImpl<
  $Res,
  $Val extends AutoAllocationResult
>
    implements $AutoAllocationResultCopyWith<$Res> {
  _$AutoAllocationResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AutoAllocationResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalAmount = null,
    Object? allocatedAmount = null,
    Object? remainingAmount = null,
    Object? allocations = null,
  }) {
    return _then(
      _value.copyWith(
            totalAmount: null == totalAmount
                ? _value.totalAmount
                : totalAmount // ignore: cast_nullable_to_non_nullable
                      as int,
            allocatedAmount: null == allocatedAmount
                ? _value.allocatedAmount
                : allocatedAmount // ignore: cast_nullable_to_non_nullable
                      as int,
            remainingAmount: null == remainingAmount
                ? _value.remainingAmount
                : remainingAmount // ignore: cast_nullable_to_non_nullable
                      as int,
            allocations: null == allocations
                ? _value.allocations
                : allocations // ignore: cast_nullable_to_non_nullable
                      as List<PaymentAllocationPreview>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AutoAllocationResultImplCopyWith<$Res>
    implements $AutoAllocationResultCopyWith<$Res> {
  factory _$$AutoAllocationResultImplCopyWith(
    _$AutoAllocationResultImpl value,
    $Res Function(_$AutoAllocationResultImpl) then,
  ) = __$$AutoAllocationResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int totalAmount,
    int allocatedAmount,
    int remainingAmount,
    List<PaymentAllocationPreview> allocations,
  });
}

/// @nodoc
class __$$AutoAllocationResultImplCopyWithImpl<$Res>
    extends _$AutoAllocationResultCopyWithImpl<$Res, _$AutoAllocationResultImpl>
    implements _$$AutoAllocationResultImplCopyWith<$Res> {
  __$$AutoAllocationResultImplCopyWithImpl(
    _$AutoAllocationResultImpl _value,
    $Res Function(_$AutoAllocationResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AutoAllocationResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalAmount = null,
    Object? allocatedAmount = null,
    Object? remainingAmount = null,
    Object? allocations = null,
  }) {
    return _then(
      _$AutoAllocationResultImpl(
        totalAmount: null == totalAmount
            ? _value.totalAmount
            : totalAmount // ignore: cast_nullable_to_non_nullable
                  as int,
        allocatedAmount: null == allocatedAmount
            ? _value.allocatedAmount
            : allocatedAmount // ignore: cast_nullable_to_non_nullable
                  as int,
        remainingAmount: null == remainingAmount
            ? _value.remainingAmount
            : remainingAmount // ignore: cast_nullable_to_non_nullable
                  as int,
        allocations: null == allocations
            ? _value._allocations
            : allocations // ignore: cast_nullable_to_non_nullable
                  as List<PaymentAllocationPreview>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AutoAllocationResultImpl implements _AutoAllocationResult {
  const _$AutoAllocationResultImpl({
    required this.totalAmount,
    required this.allocatedAmount,
    required this.remainingAmount,
    required final List<PaymentAllocationPreview> allocations,
  }) : _allocations = allocations;

  factory _$AutoAllocationResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$AutoAllocationResultImplFromJson(json);

  @override
  final int totalAmount;
  @override
  final int allocatedAmount;
  @override
  final int remainingAmount;
  final List<PaymentAllocationPreview> _allocations;
  @override
  List<PaymentAllocationPreview> get allocations {
    if (_allocations is EqualUnmodifiableListView) return _allocations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allocations);
  }

  @override
  String toString() {
    return 'AutoAllocationResult(totalAmount: $totalAmount, allocatedAmount: $allocatedAmount, remainingAmount: $remainingAmount, allocations: $allocations)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AutoAllocationResultImpl &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.allocatedAmount, allocatedAmount) ||
                other.allocatedAmount == allocatedAmount) &&
            (identical(other.remainingAmount, remainingAmount) ||
                other.remainingAmount == remainingAmount) &&
            const DeepCollectionEquality().equals(
              other._allocations,
              _allocations,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalAmount,
    allocatedAmount,
    remainingAmount,
    const DeepCollectionEquality().hash(_allocations),
  );

  /// Create a copy of AutoAllocationResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AutoAllocationResultImplCopyWith<_$AutoAllocationResultImpl>
  get copyWith =>
      __$$AutoAllocationResultImplCopyWithImpl<_$AutoAllocationResultImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AutoAllocationResultImplToJson(this);
  }
}

abstract class _AutoAllocationResult implements AutoAllocationResult {
  const factory _AutoAllocationResult({
    required final int totalAmount,
    required final int allocatedAmount,
    required final int remainingAmount,
    required final List<PaymentAllocationPreview> allocations,
  }) = _$AutoAllocationResultImpl;

  factory _AutoAllocationResult.fromJson(Map<String, dynamic> json) =
      _$AutoAllocationResultImpl.fromJson;

  @override
  int get totalAmount;
  @override
  int get allocatedAmount;
  @override
  int get remainingAmount;
  @override
  List<PaymentAllocationPreview> get allocations;

  /// Create a copy of AutoAllocationResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AutoAllocationResultImplCopyWith<_$AutoAllocationResultImpl>
  get copyWith => throw _privateConstructorUsedError;
}
