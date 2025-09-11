// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Payment _$PaymentFromJson(Map<String, dynamic> json) {
  return _Payment.fromJson(json);
}

/// @nodoc
mixin _$Payment {
  String get id => throw _privateConstructorUsedError;
  String get tenantId => throw _privateConstructorUsedError;
  PaymentMethod get method => throw _privateConstructorUsedError;
  int get amount => throw _privateConstructorUsedError;
  DateTime get paidDate => throw _privateConstructorUsedError;
  String? get memo => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this Payment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Payment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentCopyWith<Payment> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentCopyWith<$Res> {
  factory $PaymentCopyWith(Payment value, $Res Function(Payment) then) =
      _$PaymentCopyWithImpl<$Res, Payment>;
  @useResult
  $Res call({
    String id,
    String tenantId,
    PaymentMethod method,
    int amount,
    DateTime paidDate,
    String? memo,
    DateTime createdAt,
  });
}

/// @nodoc
class _$PaymentCopyWithImpl<$Res, $Val extends Payment>
    implements $PaymentCopyWith<$Res> {
  _$PaymentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Payment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tenantId = null,
    Object? method = null,
    Object? amount = null,
    Object? paidDate = null,
    Object? memo = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            tenantId: null == tenantId
                ? _value.tenantId
                : tenantId // ignore: cast_nullable_to_non_nullable
                      as String,
            method: null == method
                ? _value.method
                : method // ignore: cast_nullable_to_non_nullable
                      as PaymentMethod,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as int,
            paidDate: null == paidDate
                ? _value.paidDate
                : paidDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            memo: freezed == memo
                ? _value.memo
                : memo // ignore: cast_nullable_to_non_nullable
                      as String?,
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
abstract class _$$PaymentImplCopyWith<$Res> implements $PaymentCopyWith<$Res> {
  factory _$$PaymentImplCopyWith(
    _$PaymentImpl value,
    $Res Function(_$PaymentImpl) then,
  ) = __$$PaymentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String tenantId,
    PaymentMethod method,
    int amount,
    DateTime paidDate,
    String? memo,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$PaymentImplCopyWithImpl<$Res>
    extends _$PaymentCopyWithImpl<$Res, _$PaymentImpl>
    implements _$$PaymentImplCopyWith<$Res> {
  __$$PaymentImplCopyWithImpl(
    _$PaymentImpl _value,
    $Res Function(_$PaymentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Payment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tenantId = null,
    Object? method = null,
    Object? amount = null,
    Object? paidDate = null,
    Object? memo = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _$PaymentImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        tenantId: null == tenantId
            ? _value.tenantId
            : tenantId // ignore: cast_nullable_to_non_nullable
                  as String,
        method: null == method
            ? _value.method
            : method // ignore: cast_nullable_to_non_nullable
                  as PaymentMethod,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as int,
        paidDate: null == paidDate
            ? _value.paidDate
            : paidDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        memo: freezed == memo
            ? _value.memo
            : memo // ignore: cast_nullable_to_non_nullable
                  as String?,
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
class _$PaymentImpl implements _Payment {
  const _$PaymentImpl({
    required this.id,
    required this.tenantId,
    required this.method,
    required this.amount,
    required this.paidDate,
    this.memo,
    required this.createdAt,
  });

  factory _$PaymentImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentImplFromJson(json);

  @override
  final String id;
  @override
  final String tenantId;
  @override
  final PaymentMethod method;
  @override
  final int amount;
  @override
  final DateTime paidDate;
  @override
  final String? memo;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'Payment(id: $id, tenantId: $tenantId, method: $method, amount: $amount, paidDate: $paidDate, memo: $memo, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tenantId, tenantId) ||
                other.tenantId == tenantId) &&
            (identical(other.method, method) || other.method == method) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.paidDate, paidDate) ||
                other.paidDate == paidDate) &&
            (identical(other.memo, memo) || other.memo == memo) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    tenantId,
    method,
    amount,
    paidDate,
    memo,
    createdAt,
  );

  /// Create a copy of Payment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentImplCopyWith<_$PaymentImpl> get copyWith =>
      __$$PaymentImplCopyWithImpl<_$PaymentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentImplToJson(this);
  }
}

abstract class _Payment implements Payment {
  const factory _Payment({
    required final String id,
    required final String tenantId,
    required final PaymentMethod method,
    required final int amount,
    required final DateTime paidDate,
    final String? memo,
    required final DateTime createdAt,
  }) = _$PaymentImpl;

  factory _Payment.fromJson(Map<String, dynamic> json) = _$PaymentImpl.fromJson;

  @override
  String get id;
  @override
  String get tenantId;
  @override
  PaymentMethod get method;
  @override
  int get amount;
  @override
  DateTime get paidDate;
  @override
  String? get memo;
  @override
  DateTime get createdAt;

  /// Create a copy of Payment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentImplCopyWith<_$PaymentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreatePaymentRequest _$CreatePaymentRequestFromJson(Map<String, dynamic> json) {
  return _CreatePaymentRequest.fromJson(json);
}

/// @nodoc
mixin _$CreatePaymentRequest {
  String get tenantId => throw _privateConstructorUsedError;
  PaymentMethod get method => throw _privateConstructorUsedError;
  int get amount => throw _privateConstructorUsedError;
  DateTime get paidDate => throw _privateConstructorUsedError;
  String? get memo => throw _privateConstructorUsedError; // 수동 배분용 (선택사항)
  List<PaymentAllocationRequest>? get manualAllocations =>
      throw _privateConstructorUsedError;

  /// Serializes this CreatePaymentRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreatePaymentRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreatePaymentRequestCopyWith<CreatePaymentRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreatePaymentRequestCopyWith<$Res> {
  factory $CreatePaymentRequestCopyWith(
    CreatePaymentRequest value,
    $Res Function(CreatePaymentRequest) then,
  ) = _$CreatePaymentRequestCopyWithImpl<$Res, CreatePaymentRequest>;
  @useResult
  $Res call({
    String tenantId,
    PaymentMethod method,
    int amount,
    DateTime paidDate,
    String? memo,
    List<PaymentAllocationRequest>? manualAllocations,
  });
}

/// @nodoc
class _$CreatePaymentRequestCopyWithImpl<
  $Res,
  $Val extends CreatePaymentRequest
>
    implements $CreatePaymentRequestCopyWith<$Res> {
  _$CreatePaymentRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreatePaymentRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tenantId = null,
    Object? method = null,
    Object? amount = null,
    Object? paidDate = null,
    Object? memo = freezed,
    Object? manualAllocations = freezed,
  }) {
    return _then(
      _value.copyWith(
            tenantId: null == tenantId
                ? _value.tenantId
                : tenantId // ignore: cast_nullable_to_non_nullable
                      as String,
            method: null == method
                ? _value.method
                : method // ignore: cast_nullable_to_non_nullable
                      as PaymentMethod,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as int,
            paidDate: null == paidDate
                ? _value.paidDate
                : paidDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            memo: freezed == memo
                ? _value.memo
                : memo // ignore: cast_nullable_to_non_nullable
                      as String?,
            manualAllocations: freezed == manualAllocations
                ? _value.manualAllocations
                : manualAllocations // ignore: cast_nullable_to_non_nullable
                      as List<PaymentAllocationRequest>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CreatePaymentRequestImplCopyWith<$Res>
    implements $CreatePaymentRequestCopyWith<$Res> {
  factory _$$CreatePaymentRequestImplCopyWith(
    _$CreatePaymentRequestImpl value,
    $Res Function(_$CreatePaymentRequestImpl) then,
  ) = __$$CreatePaymentRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String tenantId,
    PaymentMethod method,
    int amount,
    DateTime paidDate,
    String? memo,
    List<PaymentAllocationRequest>? manualAllocations,
  });
}

/// @nodoc
class __$$CreatePaymentRequestImplCopyWithImpl<$Res>
    extends _$CreatePaymentRequestCopyWithImpl<$Res, _$CreatePaymentRequestImpl>
    implements _$$CreatePaymentRequestImplCopyWith<$Res> {
  __$$CreatePaymentRequestImplCopyWithImpl(
    _$CreatePaymentRequestImpl _value,
    $Res Function(_$CreatePaymentRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreatePaymentRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tenantId = null,
    Object? method = null,
    Object? amount = null,
    Object? paidDate = null,
    Object? memo = freezed,
    Object? manualAllocations = freezed,
  }) {
    return _then(
      _$CreatePaymentRequestImpl(
        tenantId: null == tenantId
            ? _value.tenantId
            : tenantId // ignore: cast_nullable_to_non_nullable
                  as String,
        method: null == method
            ? _value.method
            : method // ignore: cast_nullable_to_non_nullable
                  as PaymentMethod,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as int,
        paidDate: null == paidDate
            ? _value.paidDate
            : paidDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        memo: freezed == memo
            ? _value.memo
            : memo // ignore: cast_nullable_to_non_nullable
                  as String?,
        manualAllocations: freezed == manualAllocations
            ? _value._manualAllocations
            : manualAllocations // ignore: cast_nullable_to_non_nullable
                  as List<PaymentAllocationRequest>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CreatePaymentRequestImpl implements _CreatePaymentRequest {
  const _$CreatePaymentRequestImpl({
    required this.tenantId,
    required this.method,
    required this.amount,
    required this.paidDate,
    this.memo,
    final List<PaymentAllocationRequest>? manualAllocations,
  }) : _manualAllocations = manualAllocations;

  factory _$CreatePaymentRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreatePaymentRequestImplFromJson(json);

  @override
  final String tenantId;
  @override
  final PaymentMethod method;
  @override
  final int amount;
  @override
  final DateTime paidDate;
  @override
  final String? memo;
  // 수동 배분용 (선택사항)
  final List<PaymentAllocationRequest>? _manualAllocations;
  // 수동 배분용 (선택사항)
  @override
  List<PaymentAllocationRequest>? get manualAllocations {
    final value = _manualAllocations;
    if (value == null) return null;
    if (_manualAllocations is EqualUnmodifiableListView)
      return _manualAllocations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'CreatePaymentRequest(tenantId: $tenantId, method: $method, amount: $amount, paidDate: $paidDate, memo: $memo, manualAllocations: $manualAllocations)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreatePaymentRequestImpl &&
            (identical(other.tenantId, tenantId) ||
                other.tenantId == tenantId) &&
            (identical(other.method, method) || other.method == method) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.paidDate, paidDate) ||
                other.paidDate == paidDate) &&
            (identical(other.memo, memo) || other.memo == memo) &&
            const DeepCollectionEquality().equals(
              other._manualAllocations,
              _manualAllocations,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    tenantId,
    method,
    amount,
    paidDate,
    memo,
    const DeepCollectionEquality().hash(_manualAllocations),
  );

  /// Create a copy of CreatePaymentRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreatePaymentRequestImplCopyWith<_$CreatePaymentRequestImpl>
  get copyWith =>
      __$$CreatePaymentRequestImplCopyWithImpl<_$CreatePaymentRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CreatePaymentRequestImplToJson(this);
  }
}

abstract class _CreatePaymentRequest implements CreatePaymentRequest {
  const factory _CreatePaymentRequest({
    required final String tenantId,
    required final PaymentMethod method,
    required final int amount,
    required final DateTime paidDate,
    final String? memo,
    final List<PaymentAllocationRequest>? manualAllocations,
  }) = _$CreatePaymentRequestImpl;

  factory _CreatePaymentRequest.fromJson(Map<String, dynamic> json) =
      _$CreatePaymentRequestImpl.fromJson;

  @override
  String get tenantId;
  @override
  PaymentMethod get method;
  @override
  int get amount;
  @override
  DateTime get paidDate;
  @override
  String? get memo; // 수동 배분용 (선택사항)
  @override
  List<PaymentAllocationRequest>? get manualAllocations;

  /// Create a copy of CreatePaymentRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreatePaymentRequestImplCopyWith<_$CreatePaymentRequestImpl>
  get copyWith => throw _privateConstructorUsedError;
}

PaymentAllocationRequest _$PaymentAllocationRequestFromJson(
  Map<String, dynamic> json,
) {
  return _PaymentAllocationRequest.fromJson(json);
}

/// @nodoc
mixin _$PaymentAllocationRequest {
  String get billingId => throw _privateConstructorUsedError;
  int get amount => throw _privateConstructorUsedError;

  /// Serializes this PaymentAllocationRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaymentAllocationRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentAllocationRequestCopyWith<PaymentAllocationRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentAllocationRequestCopyWith<$Res> {
  factory $PaymentAllocationRequestCopyWith(
    PaymentAllocationRequest value,
    $Res Function(PaymentAllocationRequest) then,
  ) = _$PaymentAllocationRequestCopyWithImpl<$Res, PaymentAllocationRequest>;
  @useResult
  $Res call({String billingId, int amount});
}

/// @nodoc
class _$PaymentAllocationRequestCopyWithImpl<
  $Res,
  $Val extends PaymentAllocationRequest
>
    implements $PaymentAllocationRequestCopyWith<$Res> {
  _$PaymentAllocationRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentAllocationRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? billingId = null, Object? amount = null}) {
    return _then(
      _value.copyWith(
            billingId: null == billingId
                ? _value.billingId
                : billingId // ignore: cast_nullable_to_non_nullable
                      as String,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PaymentAllocationRequestImplCopyWith<$Res>
    implements $PaymentAllocationRequestCopyWith<$Res> {
  factory _$$PaymentAllocationRequestImplCopyWith(
    _$PaymentAllocationRequestImpl value,
    $Res Function(_$PaymentAllocationRequestImpl) then,
  ) = __$$PaymentAllocationRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String billingId, int amount});
}

/// @nodoc
class __$$PaymentAllocationRequestImplCopyWithImpl<$Res>
    extends
        _$PaymentAllocationRequestCopyWithImpl<
          $Res,
          _$PaymentAllocationRequestImpl
        >
    implements _$$PaymentAllocationRequestImplCopyWith<$Res> {
  __$$PaymentAllocationRequestImplCopyWithImpl(
    _$PaymentAllocationRequestImpl _value,
    $Res Function(_$PaymentAllocationRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaymentAllocationRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? billingId = null, Object? amount = null}) {
    return _then(
      _$PaymentAllocationRequestImpl(
        billingId: null == billingId
            ? _value.billingId
            : billingId // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentAllocationRequestImpl implements _PaymentAllocationRequest {
  const _$PaymentAllocationRequestImpl({
    required this.billingId,
    required this.amount,
  });

  factory _$PaymentAllocationRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentAllocationRequestImplFromJson(json);

  @override
  final String billingId;
  @override
  final int amount;

  @override
  String toString() {
    return 'PaymentAllocationRequest(billingId: $billingId, amount: $amount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentAllocationRequestImpl &&
            (identical(other.billingId, billingId) ||
                other.billingId == billingId) &&
            (identical(other.amount, amount) || other.amount == amount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, billingId, amount);

  /// Create a copy of PaymentAllocationRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentAllocationRequestImplCopyWith<_$PaymentAllocationRequestImpl>
  get copyWith =>
      __$$PaymentAllocationRequestImplCopyWithImpl<
        _$PaymentAllocationRequestImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentAllocationRequestImplToJson(this);
  }
}

abstract class _PaymentAllocationRequest implements PaymentAllocationRequest {
  const factory _PaymentAllocationRequest({
    required final String billingId,
    required final int amount,
  }) = _$PaymentAllocationRequestImpl;

  factory _PaymentAllocationRequest.fromJson(Map<String, dynamic> json) =
      _$PaymentAllocationRequestImpl.fromJson;

  @override
  String get billingId;
  @override
  int get amount;

  /// Create a copy of PaymentAllocationRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentAllocationRequestImplCopyWith<_$PaymentAllocationRequestImpl>
  get copyWith => throw _privateConstructorUsedError;
}
