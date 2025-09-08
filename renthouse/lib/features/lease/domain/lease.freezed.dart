// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lease.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Lease _$LeaseFromJson(Map<String, dynamic> json) {
  return _Lease.fromJson(json);
}

/// @nodoc
mixin _$Lease {
  String get id => throw _privateConstructorUsedError;
  String get tenantId => throw _privateConstructorUsedError;
  String get unitId => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;
  int get deposit => throw _privateConstructorUsedError;
  int get monthlyRent => throw _privateConstructorUsedError;
  LeaseType get leaseType => throw _privateConstructorUsedError;
  LeaseStatus get leaseStatus => throw _privateConstructorUsedError;
  String? get contractNotes => throw _privateConstructorUsedError;

  /// Serializes this Lease to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Lease
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LeaseCopyWith<Lease> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LeaseCopyWith<$Res> {
  factory $LeaseCopyWith(Lease value, $Res Function(Lease) then) =
      _$LeaseCopyWithImpl<$Res, Lease>;
  @useResult
  $Res call({
    String id,
    String tenantId,
    String unitId,
    DateTime startDate,
    DateTime endDate,
    int deposit,
    int monthlyRent,
    LeaseType leaseType,
    LeaseStatus leaseStatus,
    String? contractNotes,
  });
}

/// @nodoc
class _$LeaseCopyWithImpl<$Res, $Val extends Lease>
    implements $LeaseCopyWith<$Res> {
  _$LeaseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Lease
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tenantId = null,
    Object? unitId = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? deposit = null,
    Object? monthlyRent = null,
    Object? leaseType = null,
    Object? leaseStatus = null,
    Object? contractNotes = freezed,
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
            unitId: null == unitId
                ? _value.unitId
                : unitId // ignore: cast_nullable_to_non_nullable
                      as String,
            startDate: null == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            endDate: null == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            deposit: null == deposit
                ? _value.deposit
                : deposit // ignore: cast_nullable_to_non_nullable
                      as int,
            monthlyRent: null == monthlyRent
                ? _value.monthlyRent
                : monthlyRent // ignore: cast_nullable_to_non_nullable
                      as int,
            leaseType: null == leaseType
                ? _value.leaseType
                : leaseType // ignore: cast_nullable_to_non_nullable
                      as LeaseType,
            leaseStatus: null == leaseStatus
                ? _value.leaseStatus
                : leaseStatus // ignore: cast_nullable_to_non_nullable
                      as LeaseStatus,
            contractNotes: freezed == contractNotes
                ? _value.contractNotes
                : contractNotes // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LeaseImplCopyWith<$Res> implements $LeaseCopyWith<$Res> {
  factory _$$LeaseImplCopyWith(
    _$LeaseImpl value,
    $Res Function(_$LeaseImpl) then,
  ) = __$$LeaseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String tenantId,
    String unitId,
    DateTime startDate,
    DateTime endDate,
    int deposit,
    int monthlyRent,
    LeaseType leaseType,
    LeaseStatus leaseStatus,
    String? contractNotes,
  });
}

/// @nodoc
class __$$LeaseImplCopyWithImpl<$Res>
    extends _$LeaseCopyWithImpl<$Res, _$LeaseImpl>
    implements _$$LeaseImplCopyWith<$Res> {
  __$$LeaseImplCopyWithImpl(
    _$LeaseImpl _value,
    $Res Function(_$LeaseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Lease
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tenantId = null,
    Object? unitId = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? deposit = null,
    Object? monthlyRent = null,
    Object? leaseType = null,
    Object? leaseStatus = null,
    Object? contractNotes = freezed,
  }) {
    return _then(
      _$LeaseImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        tenantId: null == tenantId
            ? _value.tenantId
            : tenantId // ignore: cast_nullable_to_non_nullable
                  as String,
        unitId: null == unitId
            ? _value.unitId
            : unitId // ignore: cast_nullable_to_non_nullable
                  as String,
        startDate: null == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endDate: null == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        deposit: null == deposit
            ? _value.deposit
            : deposit // ignore: cast_nullable_to_non_nullable
                  as int,
        monthlyRent: null == monthlyRent
            ? _value.monthlyRent
            : monthlyRent // ignore: cast_nullable_to_non_nullable
                  as int,
        leaseType: null == leaseType
            ? _value.leaseType
            : leaseType // ignore: cast_nullable_to_non_nullable
                  as LeaseType,
        leaseStatus: null == leaseStatus
            ? _value.leaseStatus
            : leaseStatus // ignore: cast_nullable_to_non_nullable
                  as LeaseStatus,
        contractNotes: freezed == contractNotes
            ? _value.contractNotes
            : contractNotes // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LeaseImpl implements _Lease {
  const _$LeaseImpl({
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

  factory _$LeaseImpl.fromJson(Map<String, dynamic> json) =>
      _$$LeaseImplFromJson(json);

  @override
  final String id;
  @override
  final String tenantId;
  @override
  final String unitId;
  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  @override
  final int deposit;
  @override
  final int monthlyRent;
  @override
  final LeaseType leaseType;
  @override
  final LeaseStatus leaseStatus;
  @override
  final String? contractNotes;

  @override
  String toString() {
    return 'Lease(id: $id, tenantId: $tenantId, unitId: $unitId, startDate: $startDate, endDate: $endDate, deposit: $deposit, monthlyRent: $monthlyRent, leaseType: $leaseType, leaseStatus: $leaseStatus, contractNotes: $contractNotes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LeaseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tenantId, tenantId) ||
                other.tenantId == tenantId) &&
            (identical(other.unitId, unitId) || other.unitId == unitId) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.deposit, deposit) || other.deposit == deposit) &&
            (identical(other.monthlyRent, monthlyRent) ||
                other.monthlyRent == monthlyRent) &&
            (identical(other.leaseType, leaseType) ||
                other.leaseType == leaseType) &&
            (identical(other.leaseStatus, leaseStatus) ||
                other.leaseStatus == leaseStatus) &&
            (identical(other.contractNotes, contractNotes) ||
                other.contractNotes == contractNotes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
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

  /// Create a copy of Lease
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LeaseImplCopyWith<_$LeaseImpl> get copyWith =>
      __$$LeaseImplCopyWithImpl<_$LeaseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LeaseImplToJson(this);
  }
}

abstract class _Lease implements Lease {
  const factory _Lease({
    required final String id,
    required final String tenantId,
    required final String unitId,
    required final DateTime startDate,
    required final DateTime endDate,
    required final int deposit,
    required final int monthlyRent,
    required final LeaseType leaseType,
    required final LeaseStatus leaseStatus,
    final String? contractNotes,
  }) = _$LeaseImpl;

  factory _Lease.fromJson(Map<String, dynamic> json) = _$LeaseImpl.fromJson;

  @override
  String get id;
  @override
  String get tenantId;
  @override
  String get unitId;
  @override
  DateTime get startDate;
  @override
  DateTime get endDate;
  @override
  int get deposit;
  @override
  int get monthlyRent;
  @override
  LeaseType get leaseType;
  @override
  LeaseStatus get leaseStatus;
  @override
  String? get contractNotes;

  /// Create a copy of Lease
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LeaseImplCopyWith<_$LeaseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
