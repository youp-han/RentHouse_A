// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'billing.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Billing _$BillingFromJson(Map<String, dynamic> json) {
  return _Billing.fromJson(json);
}

/// @nodoc
mixin _$Billing {
  String get id => throw _privateConstructorUsedError;
  String get leaseId => throw _privateConstructorUsedError;
  String get yearMonth => throw _privateConstructorUsedError;
  DateTime get issueDate => throw _privateConstructorUsedError;
  DateTime get dueDate => throw _privateConstructorUsedError;
  bool get paid => throw _privateConstructorUsedError;
  DateTime? get paidDate => throw _privateConstructorUsedError;
  int get totalAmount => throw _privateConstructorUsedError;
  List<BillingItem> get items =>
      throw _privateConstructorUsedError; // Phase 2: 새로운 필드들
  BillingStatus get status => throw _privateConstructorUsedError;

  /// Serializes this Billing to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Billing
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BillingCopyWith<Billing> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BillingCopyWith<$Res> {
  factory $BillingCopyWith(Billing value, $Res Function(Billing) then) =
      _$BillingCopyWithImpl<$Res, Billing>;
  @useResult
  $Res call({
    String id,
    String leaseId,
    String yearMonth,
    DateTime issueDate,
    DateTime dueDate,
    bool paid,
    DateTime? paidDate,
    int totalAmount,
    List<BillingItem> items,
    BillingStatus status,
  });
}

/// @nodoc
class _$BillingCopyWithImpl<$Res, $Val extends Billing>
    implements $BillingCopyWith<$Res> {
  _$BillingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Billing
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? leaseId = null,
    Object? yearMonth = null,
    Object? issueDate = null,
    Object? dueDate = null,
    Object? paid = null,
    Object? paidDate = freezed,
    Object? totalAmount = null,
    Object? items = null,
    Object? status = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            leaseId: null == leaseId
                ? _value.leaseId
                : leaseId // ignore: cast_nullable_to_non_nullable
                      as String,
            yearMonth: null == yearMonth
                ? _value.yearMonth
                : yearMonth // ignore: cast_nullable_to_non_nullable
                      as String,
            issueDate: null == issueDate
                ? _value.issueDate
                : issueDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            dueDate: null == dueDate
                ? _value.dueDate
                : dueDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            paid: null == paid
                ? _value.paid
                : paid // ignore: cast_nullable_to_non_nullable
                      as bool,
            paidDate: freezed == paidDate
                ? _value.paidDate
                : paidDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            totalAmount: null == totalAmount
                ? _value.totalAmount
                : totalAmount // ignore: cast_nullable_to_non_nullable
                      as int,
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<BillingItem>,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as BillingStatus,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BillingImplCopyWith<$Res> implements $BillingCopyWith<$Res> {
  factory _$$BillingImplCopyWith(
    _$BillingImpl value,
    $Res Function(_$BillingImpl) then,
  ) = __$$BillingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String leaseId,
    String yearMonth,
    DateTime issueDate,
    DateTime dueDate,
    bool paid,
    DateTime? paidDate,
    int totalAmount,
    List<BillingItem> items,
    BillingStatus status,
  });
}

/// @nodoc
class __$$BillingImplCopyWithImpl<$Res>
    extends _$BillingCopyWithImpl<$Res, _$BillingImpl>
    implements _$$BillingImplCopyWith<$Res> {
  __$$BillingImplCopyWithImpl(
    _$BillingImpl _value,
    $Res Function(_$BillingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Billing
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? leaseId = null,
    Object? yearMonth = null,
    Object? issueDate = null,
    Object? dueDate = null,
    Object? paid = null,
    Object? paidDate = freezed,
    Object? totalAmount = null,
    Object? items = null,
    Object? status = null,
  }) {
    return _then(
      _$BillingImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        leaseId: null == leaseId
            ? _value.leaseId
            : leaseId // ignore: cast_nullable_to_non_nullable
                  as String,
        yearMonth: null == yearMonth
            ? _value.yearMonth
            : yearMonth // ignore: cast_nullable_to_non_nullable
                  as String,
        issueDate: null == issueDate
            ? _value.issueDate
            : issueDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        dueDate: null == dueDate
            ? _value.dueDate
            : dueDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        paid: null == paid
            ? _value.paid
            : paid // ignore: cast_nullable_to_non_nullable
                  as bool,
        paidDate: freezed == paidDate
            ? _value.paidDate
            : paidDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        totalAmount: null == totalAmount
            ? _value.totalAmount
            : totalAmount // ignore: cast_nullable_to_non_nullable
                  as int,
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<BillingItem>,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as BillingStatus,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BillingImpl implements _Billing {
  const _$BillingImpl({
    required this.id,
    required this.leaseId,
    required this.yearMonth,
    required this.issueDate,
    required this.dueDate,
    this.paid = false,
    this.paidDate,
    required this.totalAmount,
    final List<BillingItem> items = const [],
    this.status = BillingStatus.draft,
  }) : _items = items;

  factory _$BillingImpl.fromJson(Map<String, dynamic> json) =>
      _$$BillingImplFromJson(json);

  @override
  final String id;
  @override
  final String leaseId;
  @override
  final String yearMonth;
  @override
  final DateTime issueDate;
  @override
  final DateTime dueDate;
  @override
  @JsonKey()
  final bool paid;
  @override
  final DateTime? paidDate;
  @override
  final int totalAmount;
  final List<BillingItem> _items;
  @override
  @JsonKey()
  List<BillingItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  // Phase 2: 새로운 필드들
  @override
  @JsonKey()
  final BillingStatus status;

  @override
  String toString() {
    return 'Billing(id: $id, leaseId: $leaseId, yearMonth: $yearMonth, issueDate: $issueDate, dueDate: $dueDate, paid: $paid, paidDate: $paidDate, totalAmount: $totalAmount, items: $items, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BillingImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.leaseId, leaseId) || other.leaseId == leaseId) &&
            (identical(other.yearMonth, yearMonth) ||
                other.yearMonth == yearMonth) &&
            (identical(other.issueDate, issueDate) ||
                other.issueDate == issueDate) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.paid, paid) || other.paid == paid) &&
            (identical(other.paidDate, paidDate) ||
                other.paidDate == paidDate) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    leaseId,
    yearMonth,
    issueDate,
    dueDate,
    paid,
    paidDate,
    totalAmount,
    const DeepCollectionEquality().hash(_items),
    status,
  );

  /// Create a copy of Billing
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BillingImplCopyWith<_$BillingImpl> get copyWith =>
      __$$BillingImplCopyWithImpl<_$BillingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BillingImplToJson(this);
  }
}

abstract class _Billing implements Billing {
  const factory _Billing({
    required final String id,
    required final String leaseId,
    required final String yearMonth,
    required final DateTime issueDate,
    required final DateTime dueDate,
    final bool paid,
    final DateTime? paidDate,
    required final int totalAmount,
    final List<BillingItem> items,
    final BillingStatus status,
  }) = _$BillingImpl;

  factory _Billing.fromJson(Map<String, dynamic> json) = _$BillingImpl.fromJson;

  @override
  String get id;
  @override
  String get leaseId;
  @override
  String get yearMonth;
  @override
  DateTime get issueDate;
  @override
  DateTime get dueDate;
  @override
  bool get paid;
  @override
  DateTime? get paidDate;
  @override
  int get totalAmount;
  @override
  List<BillingItem> get items; // Phase 2: 새로운 필드들
  @override
  BillingStatus get status;

  /// Create a copy of Billing
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BillingImplCopyWith<_$BillingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
