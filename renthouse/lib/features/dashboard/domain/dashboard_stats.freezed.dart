// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DashboardStats _$DashboardStatsFromJson(Map<String, dynamic> json) {
  return _DashboardStats.fromJson(json);
}

/// @nodoc
mixin _$DashboardStats {
  int get currentMonthBillingAmount =>
      throw _privateConstructorUsedError; // 이번 달 청구 합계
  int get currentMonthPaymentAmount =>
      throw _privateConstructorUsedError; // 이번 달 수납 합계
  int get unpaidCount => throw _privateConstructorUsedError; // 미납 건수
  int get unpaidAmount => throw _privateConstructorUsedError; // 총 미납액
  int get activeLeaseCount => throw _privateConstructorUsedError; // 활성 계약 수
  int get overdueCount => throw _privateConstructorUsedError; // 연체 건수
  int get overdueAmount => throw _privateConstructorUsedError; // 연체 금액
  int get overduePercentage => throw _privateConstructorUsedError; // 연체 비중 (%)
  int get currentMonthOverdueRate =>
      throw _privateConstructorUsedError; // 이번 달 연체율 (%)
  DateTime get lastUpdated => throw _privateConstructorUsedError;

  /// Serializes this DashboardStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DashboardStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DashboardStatsCopyWith<DashboardStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardStatsCopyWith<$Res> {
  factory $DashboardStatsCopyWith(
    DashboardStats value,
    $Res Function(DashboardStats) then,
  ) = _$DashboardStatsCopyWithImpl<$Res, DashboardStats>;
  @useResult
  $Res call({
    int currentMonthBillingAmount,
    int currentMonthPaymentAmount,
    int unpaidCount,
    int unpaidAmount,
    int activeLeaseCount,
    int overdueCount,
    int overdueAmount,
    int overduePercentage,
    int currentMonthOverdueRate,
    DateTime lastUpdated,
  });
}

/// @nodoc
class _$DashboardStatsCopyWithImpl<$Res, $Val extends DashboardStats>
    implements $DashboardStatsCopyWith<$Res> {
  _$DashboardStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DashboardStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentMonthBillingAmount = null,
    Object? currentMonthPaymentAmount = null,
    Object? unpaidCount = null,
    Object? unpaidAmount = null,
    Object? activeLeaseCount = null,
    Object? overdueCount = null,
    Object? overdueAmount = null,
    Object? overduePercentage = null,
    Object? currentMonthOverdueRate = null,
    Object? lastUpdated = null,
  }) {
    return _then(
      _value.copyWith(
            currentMonthBillingAmount: null == currentMonthBillingAmount
                ? _value.currentMonthBillingAmount
                : currentMonthBillingAmount // ignore: cast_nullable_to_non_nullable
                      as int,
            currentMonthPaymentAmount: null == currentMonthPaymentAmount
                ? _value.currentMonthPaymentAmount
                : currentMonthPaymentAmount // ignore: cast_nullable_to_non_nullable
                      as int,
            unpaidCount: null == unpaidCount
                ? _value.unpaidCount
                : unpaidCount // ignore: cast_nullable_to_non_nullable
                      as int,
            unpaidAmount: null == unpaidAmount
                ? _value.unpaidAmount
                : unpaidAmount // ignore: cast_nullable_to_non_nullable
                      as int,
            activeLeaseCount: null == activeLeaseCount
                ? _value.activeLeaseCount
                : activeLeaseCount // ignore: cast_nullable_to_non_nullable
                      as int,
            overdueCount: null == overdueCount
                ? _value.overdueCount
                : overdueCount // ignore: cast_nullable_to_non_nullable
                      as int,
            overdueAmount: null == overdueAmount
                ? _value.overdueAmount
                : overdueAmount // ignore: cast_nullable_to_non_nullable
                      as int,
            overduePercentage: null == overduePercentage
                ? _value.overduePercentage
                : overduePercentage // ignore: cast_nullable_to_non_nullable
                      as int,
            currentMonthOverdueRate: null == currentMonthOverdueRate
                ? _value.currentMonthOverdueRate
                : currentMonthOverdueRate // ignore: cast_nullable_to_non_nullable
                      as int,
            lastUpdated: null == lastUpdated
                ? _value.lastUpdated
                : lastUpdated // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DashboardStatsImplCopyWith<$Res>
    implements $DashboardStatsCopyWith<$Res> {
  factory _$$DashboardStatsImplCopyWith(
    _$DashboardStatsImpl value,
    $Res Function(_$DashboardStatsImpl) then,
  ) = __$$DashboardStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int currentMonthBillingAmount,
    int currentMonthPaymentAmount,
    int unpaidCount,
    int unpaidAmount,
    int activeLeaseCount,
    int overdueCount,
    int overdueAmount,
    int overduePercentage,
    int currentMonthOverdueRate,
    DateTime lastUpdated,
  });
}

/// @nodoc
class __$$DashboardStatsImplCopyWithImpl<$Res>
    extends _$DashboardStatsCopyWithImpl<$Res, _$DashboardStatsImpl>
    implements _$$DashboardStatsImplCopyWith<$Res> {
  __$$DashboardStatsImplCopyWithImpl(
    _$DashboardStatsImpl _value,
    $Res Function(_$DashboardStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DashboardStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentMonthBillingAmount = null,
    Object? currentMonthPaymentAmount = null,
    Object? unpaidCount = null,
    Object? unpaidAmount = null,
    Object? activeLeaseCount = null,
    Object? overdueCount = null,
    Object? overdueAmount = null,
    Object? overduePercentage = null,
    Object? currentMonthOverdueRate = null,
    Object? lastUpdated = null,
  }) {
    return _then(
      _$DashboardStatsImpl(
        currentMonthBillingAmount: null == currentMonthBillingAmount
            ? _value.currentMonthBillingAmount
            : currentMonthBillingAmount // ignore: cast_nullable_to_non_nullable
                  as int,
        currentMonthPaymentAmount: null == currentMonthPaymentAmount
            ? _value.currentMonthPaymentAmount
            : currentMonthPaymentAmount // ignore: cast_nullable_to_non_nullable
                  as int,
        unpaidCount: null == unpaidCount
            ? _value.unpaidCount
            : unpaidCount // ignore: cast_nullable_to_non_nullable
                  as int,
        unpaidAmount: null == unpaidAmount
            ? _value.unpaidAmount
            : unpaidAmount // ignore: cast_nullable_to_non_nullable
                  as int,
        activeLeaseCount: null == activeLeaseCount
            ? _value.activeLeaseCount
            : activeLeaseCount // ignore: cast_nullable_to_non_nullable
                  as int,
        overdueCount: null == overdueCount
            ? _value.overdueCount
            : overdueCount // ignore: cast_nullable_to_non_nullable
                  as int,
        overdueAmount: null == overdueAmount
            ? _value.overdueAmount
            : overdueAmount // ignore: cast_nullable_to_non_nullable
                  as int,
        overduePercentage: null == overduePercentage
            ? _value.overduePercentage
            : overduePercentage // ignore: cast_nullable_to_non_nullable
                  as int,
        currentMonthOverdueRate: null == currentMonthOverdueRate
            ? _value.currentMonthOverdueRate
            : currentMonthOverdueRate // ignore: cast_nullable_to_non_nullable
                  as int,
        lastUpdated: null == lastUpdated
            ? _value.lastUpdated
            : lastUpdated // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DashboardStatsImpl implements _DashboardStats {
  const _$DashboardStatsImpl({
    required this.currentMonthBillingAmount,
    required this.currentMonthPaymentAmount,
    required this.unpaidCount,
    required this.unpaidAmount,
    required this.activeLeaseCount,
    required this.overdueCount,
    required this.overdueAmount,
    required this.overduePercentage,
    required this.currentMonthOverdueRate,
    required this.lastUpdated,
  });

  factory _$DashboardStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$DashboardStatsImplFromJson(json);

  @override
  final int currentMonthBillingAmount;
  // 이번 달 청구 합계
  @override
  final int currentMonthPaymentAmount;
  // 이번 달 수납 합계
  @override
  final int unpaidCount;
  // 미납 건수
  @override
  final int unpaidAmount;
  // 총 미납액
  @override
  final int activeLeaseCount;
  // 활성 계약 수
  @override
  final int overdueCount;
  // 연체 건수
  @override
  final int overdueAmount;
  // 연체 금액
  @override
  final int overduePercentage;
  // 연체 비중 (%)
  @override
  final int currentMonthOverdueRate;
  // 이번 달 연체율 (%)
  @override
  final DateTime lastUpdated;

  @override
  String toString() {
    return 'DashboardStats(currentMonthBillingAmount: $currentMonthBillingAmount, currentMonthPaymentAmount: $currentMonthPaymentAmount, unpaidCount: $unpaidCount, unpaidAmount: $unpaidAmount, activeLeaseCount: $activeLeaseCount, overdueCount: $overdueCount, overdueAmount: $overdueAmount, overduePercentage: $overduePercentage, currentMonthOverdueRate: $currentMonthOverdueRate, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardStatsImpl &&
            (identical(
                  other.currentMonthBillingAmount,
                  currentMonthBillingAmount,
                ) ||
                other.currentMonthBillingAmount == currentMonthBillingAmount) &&
            (identical(
                  other.currentMonthPaymentAmount,
                  currentMonthPaymentAmount,
                ) ||
                other.currentMonthPaymentAmount == currentMonthPaymentAmount) &&
            (identical(other.unpaidCount, unpaidCount) ||
                other.unpaidCount == unpaidCount) &&
            (identical(other.unpaidAmount, unpaidAmount) ||
                other.unpaidAmount == unpaidAmount) &&
            (identical(other.activeLeaseCount, activeLeaseCount) ||
                other.activeLeaseCount == activeLeaseCount) &&
            (identical(other.overdueCount, overdueCount) ||
                other.overdueCount == overdueCount) &&
            (identical(other.overdueAmount, overdueAmount) ||
                other.overdueAmount == overdueAmount) &&
            (identical(other.overduePercentage, overduePercentage) ||
                other.overduePercentage == overduePercentage) &&
            (identical(
                  other.currentMonthOverdueRate,
                  currentMonthOverdueRate,
                ) ||
                other.currentMonthOverdueRate == currentMonthOverdueRate) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    currentMonthBillingAmount,
    currentMonthPaymentAmount,
    unpaidCount,
    unpaidAmount,
    activeLeaseCount,
    overdueCount,
    overdueAmount,
    overduePercentage,
    currentMonthOverdueRate,
    lastUpdated,
  );

  /// Create a copy of DashboardStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardStatsImplCopyWith<_$DashboardStatsImpl> get copyWith =>
      __$$DashboardStatsImplCopyWithImpl<_$DashboardStatsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DashboardStatsImplToJson(this);
  }
}

abstract class _DashboardStats implements DashboardStats {
  const factory _DashboardStats({
    required final int currentMonthBillingAmount,
    required final int currentMonthPaymentAmount,
    required final int unpaidCount,
    required final int unpaidAmount,
    required final int activeLeaseCount,
    required final int overdueCount,
    required final int overdueAmount,
    required final int overduePercentage,
    required final int currentMonthOverdueRate,
    required final DateTime lastUpdated,
  }) = _$DashboardStatsImpl;

  factory _DashboardStats.fromJson(Map<String, dynamic> json) =
      _$DashboardStatsImpl.fromJson;

  @override
  int get currentMonthBillingAmount; // 이번 달 청구 합계
  @override
  int get currentMonthPaymentAmount; // 이번 달 수납 합계
  @override
  int get unpaidCount; // 미납 건수
  @override
  int get unpaidAmount; // 총 미납액
  @override
  int get activeLeaseCount; // 활성 계약 수
  @override
  int get overdueCount; // 연체 건수
  @override
  int get overdueAmount; // 연체 금액
  @override
  int get overduePercentage; // 연체 비중 (%)
  @override
  int get currentMonthOverdueRate; // 이번 달 연체율 (%)
  @override
  DateTime get lastUpdated;

  /// Create a copy of DashboardStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DashboardStatsImplCopyWith<_$DashboardStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
