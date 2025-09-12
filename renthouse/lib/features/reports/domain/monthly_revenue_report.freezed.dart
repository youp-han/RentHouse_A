// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'monthly_revenue_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MonthlyRevenueReport _$MonthlyRevenueReportFromJson(Map<String, dynamic> json) {
  return _MonthlyRevenueReport.fromJson(json);
}

/// @nodoc
mixin _$MonthlyRevenueReport {
  String get yearMonth => throw _privateConstructorUsedError; // YYYY-MM 형태
  int get totalBilledAmount => throw _privateConstructorUsedError; // 총 청구액
  int get totalReceivedAmount => throw _privateConstructorUsedError; // 총 수납액
  double get collectionRate => throw _privateConstructorUsedError; // 수납률 (%)
  int? get previousYearBilledAmount =>
      throw _privateConstructorUsedError; // 전년 동월 청구액
  int? get previousYearReceivedAmount =>
      throw _privateConstructorUsedError; // 전년 동월 수납액
  double? get billedAmountGrowthRate =>
      throw _privateConstructorUsedError; // 청구액 증감률 (%)
  double? get receivedAmountGrowthRate =>
      throw _privateConstructorUsedError; // 수납액 증감률 (%)
  int get pendingAmount => throw _privateConstructorUsedError; // 미납액
  int get overdueAmount => throw _privateConstructorUsedError;

  /// Serializes this MonthlyRevenueReport to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MonthlyRevenueReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MonthlyRevenueReportCopyWith<MonthlyRevenueReport> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MonthlyRevenueReportCopyWith<$Res> {
  factory $MonthlyRevenueReportCopyWith(
    MonthlyRevenueReport value,
    $Res Function(MonthlyRevenueReport) then,
  ) = _$MonthlyRevenueReportCopyWithImpl<$Res, MonthlyRevenueReport>;
  @useResult
  $Res call({
    String yearMonth,
    int totalBilledAmount,
    int totalReceivedAmount,
    double collectionRate,
    int? previousYearBilledAmount,
    int? previousYearReceivedAmount,
    double? billedAmountGrowthRate,
    double? receivedAmountGrowthRate,
    int pendingAmount,
    int overdueAmount,
  });
}

/// @nodoc
class _$MonthlyRevenueReportCopyWithImpl<
  $Res,
  $Val extends MonthlyRevenueReport
>
    implements $MonthlyRevenueReportCopyWith<$Res> {
  _$MonthlyRevenueReportCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MonthlyRevenueReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? yearMonth = null,
    Object? totalBilledAmount = null,
    Object? totalReceivedAmount = null,
    Object? collectionRate = null,
    Object? previousYearBilledAmount = freezed,
    Object? previousYearReceivedAmount = freezed,
    Object? billedAmountGrowthRate = freezed,
    Object? receivedAmountGrowthRate = freezed,
    Object? pendingAmount = null,
    Object? overdueAmount = null,
  }) {
    return _then(
      _value.copyWith(
            yearMonth: null == yearMonth
                ? _value.yearMonth
                : yearMonth // ignore: cast_nullable_to_non_nullable
                      as String,
            totalBilledAmount: null == totalBilledAmount
                ? _value.totalBilledAmount
                : totalBilledAmount // ignore: cast_nullable_to_non_nullable
                      as int,
            totalReceivedAmount: null == totalReceivedAmount
                ? _value.totalReceivedAmount
                : totalReceivedAmount // ignore: cast_nullable_to_non_nullable
                      as int,
            collectionRate: null == collectionRate
                ? _value.collectionRate
                : collectionRate // ignore: cast_nullable_to_non_nullable
                      as double,
            previousYearBilledAmount: freezed == previousYearBilledAmount
                ? _value.previousYearBilledAmount
                : previousYearBilledAmount // ignore: cast_nullable_to_non_nullable
                      as int?,
            previousYearReceivedAmount: freezed == previousYearReceivedAmount
                ? _value.previousYearReceivedAmount
                : previousYearReceivedAmount // ignore: cast_nullable_to_non_nullable
                      as int?,
            billedAmountGrowthRate: freezed == billedAmountGrowthRate
                ? _value.billedAmountGrowthRate
                : billedAmountGrowthRate // ignore: cast_nullable_to_non_nullable
                      as double?,
            receivedAmountGrowthRate: freezed == receivedAmountGrowthRate
                ? _value.receivedAmountGrowthRate
                : receivedAmountGrowthRate // ignore: cast_nullable_to_non_nullable
                      as double?,
            pendingAmount: null == pendingAmount
                ? _value.pendingAmount
                : pendingAmount // ignore: cast_nullable_to_non_nullable
                      as int,
            overdueAmount: null == overdueAmount
                ? _value.overdueAmount
                : overdueAmount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MonthlyRevenueReportImplCopyWith<$Res>
    implements $MonthlyRevenueReportCopyWith<$Res> {
  factory _$$MonthlyRevenueReportImplCopyWith(
    _$MonthlyRevenueReportImpl value,
    $Res Function(_$MonthlyRevenueReportImpl) then,
  ) = __$$MonthlyRevenueReportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String yearMonth,
    int totalBilledAmount,
    int totalReceivedAmount,
    double collectionRate,
    int? previousYearBilledAmount,
    int? previousYearReceivedAmount,
    double? billedAmountGrowthRate,
    double? receivedAmountGrowthRate,
    int pendingAmount,
    int overdueAmount,
  });
}

/// @nodoc
class __$$MonthlyRevenueReportImplCopyWithImpl<$Res>
    extends _$MonthlyRevenueReportCopyWithImpl<$Res, _$MonthlyRevenueReportImpl>
    implements _$$MonthlyRevenueReportImplCopyWith<$Res> {
  __$$MonthlyRevenueReportImplCopyWithImpl(
    _$MonthlyRevenueReportImpl _value,
    $Res Function(_$MonthlyRevenueReportImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MonthlyRevenueReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? yearMonth = null,
    Object? totalBilledAmount = null,
    Object? totalReceivedAmount = null,
    Object? collectionRate = null,
    Object? previousYearBilledAmount = freezed,
    Object? previousYearReceivedAmount = freezed,
    Object? billedAmountGrowthRate = freezed,
    Object? receivedAmountGrowthRate = freezed,
    Object? pendingAmount = null,
    Object? overdueAmount = null,
  }) {
    return _then(
      _$MonthlyRevenueReportImpl(
        yearMonth: null == yearMonth
            ? _value.yearMonth
            : yearMonth // ignore: cast_nullable_to_non_nullable
                  as String,
        totalBilledAmount: null == totalBilledAmount
            ? _value.totalBilledAmount
            : totalBilledAmount // ignore: cast_nullable_to_non_nullable
                  as int,
        totalReceivedAmount: null == totalReceivedAmount
            ? _value.totalReceivedAmount
            : totalReceivedAmount // ignore: cast_nullable_to_non_nullable
                  as int,
        collectionRate: null == collectionRate
            ? _value.collectionRate
            : collectionRate // ignore: cast_nullable_to_non_nullable
                  as double,
        previousYearBilledAmount: freezed == previousYearBilledAmount
            ? _value.previousYearBilledAmount
            : previousYearBilledAmount // ignore: cast_nullable_to_non_nullable
                  as int?,
        previousYearReceivedAmount: freezed == previousYearReceivedAmount
            ? _value.previousYearReceivedAmount
            : previousYearReceivedAmount // ignore: cast_nullable_to_non_nullable
                  as int?,
        billedAmountGrowthRate: freezed == billedAmountGrowthRate
            ? _value.billedAmountGrowthRate
            : billedAmountGrowthRate // ignore: cast_nullable_to_non_nullable
                  as double?,
        receivedAmountGrowthRate: freezed == receivedAmountGrowthRate
            ? _value.receivedAmountGrowthRate
            : receivedAmountGrowthRate // ignore: cast_nullable_to_non_nullable
                  as double?,
        pendingAmount: null == pendingAmount
            ? _value.pendingAmount
            : pendingAmount // ignore: cast_nullable_to_non_nullable
                  as int,
        overdueAmount: null == overdueAmount
            ? _value.overdueAmount
            : overdueAmount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MonthlyRevenueReportImpl extends _MonthlyRevenueReport {
  const _$MonthlyRevenueReportImpl({
    required this.yearMonth,
    required this.totalBilledAmount,
    required this.totalReceivedAmount,
    required this.collectionRate,
    this.previousYearBilledAmount,
    this.previousYearReceivedAmount,
    this.billedAmountGrowthRate,
    this.receivedAmountGrowthRate,
    required this.pendingAmount,
    required this.overdueAmount,
  }) : super._();

  factory _$MonthlyRevenueReportImpl.fromJson(Map<String, dynamic> json) =>
      _$$MonthlyRevenueReportImplFromJson(json);

  @override
  final String yearMonth;
  // YYYY-MM 형태
  @override
  final int totalBilledAmount;
  // 총 청구액
  @override
  final int totalReceivedAmount;
  // 총 수납액
  @override
  final double collectionRate;
  // 수납률 (%)
  @override
  final int? previousYearBilledAmount;
  // 전년 동월 청구액
  @override
  final int? previousYearReceivedAmount;
  // 전년 동월 수납액
  @override
  final double? billedAmountGrowthRate;
  // 청구액 증감률 (%)
  @override
  final double? receivedAmountGrowthRate;
  // 수납액 증감률 (%)
  @override
  final int pendingAmount;
  // 미납액
  @override
  final int overdueAmount;

  @override
  String toString() {
    return 'MonthlyRevenueReport(yearMonth: $yearMonth, totalBilledAmount: $totalBilledAmount, totalReceivedAmount: $totalReceivedAmount, collectionRate: $collectionRate, previousYearBilledAmount: $previousYearBilledAmount, previousYearReceivedAmount: $previousYearReceivedAmount, billedAmountGrowthRate: $billedAmountGrowthRate, receivedAmountGrowthRate: $receivedAmountGrowthRate, pendingAmount: $pendingAmount, overdueAmount: $overdueAmount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MonthlyRevenueReportImpl &&
            (identical(other.yearMonth, yearMonth) ||
                other.yearMonth == yearMonth) &&
            (identical(other.totalBilledAmount, totalBilledAmount) ||
                other.totalBilledAmount == totalBilledAmount) &&
            (identical(other.totalReceivedAmount, totalReceivedAmount) ||
                other.totalReceivedAmount == totalReceivedAmount) &&
            (identical(other.collectionRate, collectionRate) ||
                other.collectionRate == collectionRate) &&
            (identical(
                  other.previousYearBilledAmount,
                  previousYearBilledAmount,
                ) ||
                other.previousYearBilledAmount == previousYearBilledAmount) &&
            (identical(
                  other.previousYearReceivedAmount,
                  previousYearReceivedAmount,
                ) ||
                other.previousYearReceivedAmount ==
                    previousYearReceivedAmount) &&
            (identical(other.billedAmountGrowthRate, billedAmountGrowthRate) ||
                other.billedAmountGrowthRate == billedAmountGrowthRate) &&
            (identical(
                  other.receivedAmountGrowthRate,
                  receivedAmountGrowthRate,
                ) ||
                other.receivedAmountGrowthRate == receivedAmountGrowthRate) &&
            (identical(other.pendingAmount, pendingAmount) ||
                other.pendingAmount == pendingAmount) &&
            (identical(other.overdueAmount, overdueAmount) ||
                other.overdueAmount == overdueAmount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    yearMonth,
    totalBilledAmount,
    totalReceivedAmount,
    collectionRate,
    previousYearBilledAmount,
    previousYearReceivedAmount,
    billedAmountGrowthRate,
    receivedAmountGrowthRate,
    pendingAmount,
    overdueAmount,
  );

  /// Create a copy of MonthlyRevenueReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MonthlyRevenueReportImplCopyWith<_$MonthlyRevenueReportImpl>
  get copyWith =>
      __$$MonthlyRevenueReportImplCopyWithImpl<_$MonthlyRevenueReportImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MonthlyRevenueReportImplToJson(this);
  }
}

abstract class _MonthlyRevenueReport extends MonthlyRevenueReport {
  const factory _MonthlyRevenueReport({
    required final String yearMonth,
    required final int totalBilledAmount,
    required final int totalReceivedAmount,
    required final double collectionRate,
    final int? previousYearBilledAmount,
    final int? previousYearReceivedAmount,
    final double? billedAmountGrowthRate,
    final double? receivedAmountGrowthRate,
    required final int pendingAmount,
    required final int overdueAmount,
  }) = _$MonthlyRevenueReportImpl;
  const _MonthlyRevenueReport._() : super._();

  factory _MonthlyRevenueReport.fromJson(Map<String, dynamic> json) =
      _$MonthlyRevenueReportImpl.fromJson;

  @override
  String get yearMonth; // YYYY-MM 형태
  @override
  int get totalBilledAmount; // 총 청구액
  @override
  int get totalReceivedAmount; // 총 수납액
  @override
  double get collectionRate; // 수납률 (%)
  @override
  int? get previousYearBilledAmount; // 전년 동월 청구액
  @override
  int? get previousYearReceivedAmount; // 전년 동월 수납액
  @override
  double? get billedAmountGrowthRate; // 청구액 증감률 (%)
  @override
  double? get receivedAmountGrowthRate; // 수납액 증감률 (%)
  @override
  int get pendingAmount; // 미납액
  @override
  int get overdueAmount;

  /// Create a copy of MonthlyRevenueReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MonthlyRevenueReportImplCopyWith<_$MonthlyRevenueReportImpl>
  get copyWith => throw _privateConstructorUsedError;
}

OverdueReport _$OverdueReportFromJson(Map<String, dynamic> json) {
  return _OverdueReport.fromJson(json);
}

/// @nodoc
mixin _$OverdueReport {
  String get tenantId => throw _privateConstructorUsedError;
  String get tenantName => throw _privateConstructorUsedError;
  String get unitId => throw _privateConstructorUsedError;
  String get unitNumber => throw _privateConstructorUsedError;
  String get propertyName => throw _privateConstructorUsedError;
  int get overdueAmount => throw _privateConstructorUsedError; // 연체 금액
  int get overdueDays => throw _privateConstructorUsedError; // 연체 일수
  DateTime get oldestOverdueDate =>
      throw _privateConstructorUsedError; // 가장 오래된 연체 날짜
  List<OverdueBilling> get overdueList => throw _privateConstructorUsedError;

  /// Serializes this OverdueReport to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OverdueReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OverdueReportCopyWith<OverdueReport> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OverdueReportCopyWith<$Res> {
  factory $OverdueReportCopyWith(
    OverdueReport value,
    $Res Function(OverdueReport) then,
  ) = _$OverdueReportCopyWithImpl<$Res, OverdueReport>;
  @useResult
  $Res call({
    String tenantId,
    String tenantName,
    String unitId,
    String unitNumber,
    String propertyName,
    int overdueAmount,
    int overdueDays,
    DateTime oldestOverdueDate,
    List<OverdueBilling> overdueList,
  });
}

/// @nodoc
class _$OverdueReportCopyWithImpl<$Res, $Val extends OverdueReport>
    implements $OverdueReportCopyWith<$Res> {
  _$OverdueReportCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OverdueReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tenantId = null,
    Object? tenantName = null,
    Object? unitId = null,
    Object? unitNumber = null,
    Object? propertyName = null,
    Object? overdueAmount = null,
    Object? overdueDays = null,
    Object? oldestOverdueDate = null,
    Object? overdueList = null,
  }) {
    return _then(
      _value.copyWith(
            tenantId: null == tenantId
                ? _value.tenantId
                : tenantId // ignore: cast_nullable_to_non_nullable
                      as String,
            tenantName: null == tenantName
                ? _value.tenantName
                : tenantName // ignore: cast_nullable_to_non_nullable
                      as String,
            unitId: null == unitId
                ? _value.unitId
                : unitId // ignore: cast_nullable_to_non_nullable
                      as String,
            unitNumber: null == unitNumber
                ? _value.unitNumber
                : unitNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            propertyName: null == propertyName
                ? _value.propertyName
                : propertyName // ignore: cast_nullable_to_non_nullable
                      as String,
            overdueAmount: null == overdueAmount
                ? _value.overdueAmount
                : overdueAmount // ignore: cast_nullable_to_non_nullable
                      as int,
            overdueDays: null == overdueDays
                ? _value.overdueDays
                : overdueDays // ignore: cast_nullable_to_non_nullable
                      as int,
            oldestOverdueDate: null == oldestOverdueDate
                ? _value.oldestOverdueDate
                : oldestOverdueDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            overdueList: null == overdueList
                ? _value.overdueList
                : overdueList // ignore: cast_nullable_to_non_nullable
                      as List<OverdueBilling>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OverdueReportImplCopyWith<$Res>
    implements $OverdueReportCopyWith<$Res> {
  factory _$$OverdueReportImplCopyWith(
    _$OverdueReportImpl value,
    $Res Function(_$OverdueReportImpl) then,
  ) = __$$OverdueReportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String tenantId,
    String tenantName,
    String unitId,
    String unitNumber,
    String propertyName,
    int overdueAmount,
    int overdueDays,
    DateTime oldestOverdueDate,
    List<OverdueBilling> overdueList,
  });
}

/// @nodoc
class __$$OverdueReportImplCopyWithImpl<$Res>
    extends _$OverdueReportCopyWithImpl<$Res, _$OverdueReportImpl>
    implements _$$OverdueReportImplCopyWith<$Res> {
  __$$OverdueReportImplCopyWithImpl(
    _$OverdueReportImpl _value,
    $Res Function(_$OverdueReportImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OverdueReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tenantId = null,
    Object? tenantName = null,
    Object? unitId = null,
    Object? unitNumber = null,
    Object? propertyName = null,
    Object? overdueAmount = null,
    Object? overdueDays = null,
    Object? oldestOverdueDate = null,
    Object? overdueList = null,
  }) {
    return _then(
      _$OverdueReportImpl(
        tenantId: null == tenantId
            ? _value.tenantId
            : tenantId // ignore: cast_nullable_to_non_nullable
                  as String,
        tenantName: null == tenantName
            ? _value.tenantName
            : tenantName // ignore: cast_nullable_to_non_nullable
                  as String,
        unitId: null == unitId
            ? _value.unitId
            : unitId // ignore: cast_nullable_to_non_nullable
                  as String,
        unitNumber: null == unitNumber
            ? _value.unitNumber
            : unitNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        propertyName: null == propertyName
            ? _value.propertyName
            : propertyName // ignore: cast_nullable_to_non_nullable
                  as String,
        overdueAmount: null == overdueAmount
            ? _value.overdueAmount
            : overdueAmount // ignore: cast_nullable_to_non_nullable
                  as int,
        overdueDays: null == overdueDays
            ? _value.overdueDays
            : overdueDays // ignore: cast_nullable_to_non_nullable
                  as int,
        oldestOverdueDate: null == oldestOverdueDate
            ? _value.oldestOverdueDate
            : oldestOverdueDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        overdueList: null == overdueList
            ? _value._overdueList
            : overdueList // ignore: cast_nullable_to_non_nullable
                  as List<OverdueBilling>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OverdueReportImpl implements _OverdueReport {
  const _$OverdueReportImpl({
    required this.tenantId,
    required this.tenantName,
    required this.unitId,
    required this.unitNumber,
    required this.propertyName,
    required this.overdueAmount,
    required this.overdueDays,
    required this.oldestOverdueDate,
    required final List<OverdueBilling> overdueList,
  }) : _overdueList = overdueList;

  factory _$OverdueReportImpl.fromJson(Map<String, dynamic> json) =>
      _$$OverdueReportImplFromJson(json);

  @override
  final String tenantId;
  @override
  final String tenantName;
  @override
  final String unitId;
  @override
  final String unitNumber;
  @override
  final String propertyName;
  @override
  final int overdueAmount;
  // 연체 금액
  @override
  final int overdueDays;
  // 연체 일수
  @override
  final DateTime oldestOverdueDate;
  // 가장 오래된 연체 날짜
  final List<OverdueBilling> _overdueList;
  // 가장 오래된 연체 날짜
  @override
  List<OverdueBilling> get overdueList {
    if (_overdueList is EqualUnmodifiableListView) return _overdueList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_overdueList);
  }

  @override
  String toString() {
    return 'OverdueReport(tenantId: $tenantId, tenantName: $tenantName, unitId: $unitId, unitNumber: $unitNumber, propertyName: $propertyName, overdueAmount: $overdueAmount, overdueDays: $overdueDays, oldestOverdueDate: $oldestOverdueDate, overdueList: $overdueList)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OverdueReportImpl &&
            (identical(other.tenantId, tenantId) ||
                other.tenantId == tenantId) &&
            (identical(other.tenantName, tenantName) ||
                other.tenantName == tenantName) &&
            (identical(other.unitId, unitId) || other.unitId == unitId) &&
            (identical(other.unitNumber, unitNumber) ||
                other.unitNumber == unitNumber) &&
            (identical(other.propertyName, propertyName) ||
                other.propertyName == propertyName) &&
            (identical(other.overdueAmount, overdueAmount) ||
                other.overdueAmount == overdueAmount) &&
            (identical(other.overdueDays, overdueDays) ||
                other.overdueDays == overdueDays) &&
            (identical(other.oldestOverdueDate, oldestOverdueDate) ||
                other.oldestOverdueDate == oldestOverdueDate) &&
            const DeepCollectionEquality().equals(
              other._overdueList,
              _overdueList,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    tenantId,
    tenantName,
    unitId,
    unitNumber,
    propertyName,
    overdueAmount,
    overdueDays,
    oldestOverdueDate,
    const DeepCollectionEquality().hash(_overdueList),
  );

  /// Create a copy of OverdueReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OverdueReportImplCopyWith<_$OverdueReportImpl> get copyWith =>
      __$$OverdueReportImplCopyWithImpl<_$OverdueReportImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OverdueReportImplToJson(this);
  }
}

abstract class _OverdueReport implements OverdueReport {
  const factory _OverdueReport({
    required final String tenantId,
    required final String tenantName,
    required final String unitId,
    required final String unitNumber,
    required final String propertyName,
    required final int overdueAmount,
    required final int overdueDays,
    required final DateTime oldestOverdueDate,
    required final List<OverdueBilling> overdueList,
  }) = _$OverdueReportImpl;

  factory _OverdueReport.fromJson(Map<String, dynamic> json) =
      _$OverdueReportImpl.fromJson;

  @override
  String get tenantId;
  @override
  String get tenantName;
  @override
  String get unitId;
  @override
  String get unitNumber;
  @override
  String get propertyName;
  @override
  int get overdueAmount; // 연체 금액
  @override
  int get overdueDays; // 연체 일수
  @override
  DateTime get oldestOverdueDate; // 가장 오래된 연체 날짜
  @override
  List<OverdueBilling> get overdueList;

  /// Create a copy of OverdueReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OverdueReportImplCopyWith<_$OverdueReportImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OverdueBilling _$OverdueBillingFromJson(Map<String, dynamic> json) {
  return _OverdueBilling.fromJson(json);
}

/// @nodoc
mixin _$OverdueBilling {
  String get billingId => throw _privateConstructorUsedError;
  String get yearMonth => throw _privateConstructorUsedError;
  int get amount => throw _privateConstructorUsedError;
  DateTime get dueDate => throw _privateConstructorUsedError;
  int get overdueDays => throw _privateConstructorUsedError;

  /// Serializes this OverdueBilling to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OverdueBilling
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OverdueBillingCopyWith<OverdueBilling> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OverdueBillingCopyWith<$Res> {
  factory $OverdueBillingCopyWith(
    OverdueBilling value,
    $Res Function(OverdueBilling) then,
  ) = _$OverdueBillingCopyWithImpl<$Res, OverdueBilling>;
  @useResult
  $Res call({
    String billingId,
    String yearMonth,
    int amount,
    DateTime dueDate,
    int overdueDays,
  });
}

/// @nodoc
class _$OverdueBillingCopyWithImpl<$Res, $Val extends OverdueBilling>
    implements $OverdueBillingCopyWith<$Res> {
  _$OverdueBillingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OverdueBilling
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? billingId = null,
    Object? yearMonth = null,
    Object? amount = null,
    Object? dueDate = null,
    Object? overdueDays = null,
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
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as int,
            dueDate: null == dueDate
                ? _value.dueDate
                : dueDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            overdueDays: null == overdueDays
                ? _value.overdueDays
                : overdueDays // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OverdueBillingImplCopyWith<$Res>
    implements $OverdueBillingCopyWith<$Res> {
  factory _$$OverdueBillingImplCopyWith(
    _$OverdueBillingImpl value,
    $Res Function(_$OverdueBillingImpl) then,
  ) = __$$OverdueBillingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String billingId,
    String yearMonth,
    int amount,
    DateTime dueDate,
    int overdueDays,
  });
}

/// @nodoc
class __$$OverdueBillingImplCopyWithImpl<$Res>
    extends _$OverdueBillingCopyWithImpl<$Res, _$OverdueBillingImpl>
    implements _$$OverdueBillingImplCopyWith<$Res> {
  __$$OverdueBillingImplCopyWithImpl(
    _$OverdueBillingImpl _value,
    $Res Function(_$OverdueBillingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OverdueBilling
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? billingId = null,
    Object? yearMonth = null,
    Object? amount = null,
    Object? dueDate = null,
    Object? overdueDays = null,
  }) {
    return _then(
      _$OverdueBillingImpl(
        billingId: null == billingId
            ? _value.billingId
            : billingId // ignore: cast_nullable_to_non_nullable
                  as String,
        yearMonth: null == yearMonth
            ? _value.yearMonth
            : yearMonth // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as int,
        dueDate: null == dueDate
            ? _value.dueDate
            : dueDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        overdueDays: null == overdueDays
            ? _value.overdueDays
            : overdueDays // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OverdueBillingImpl implements _OverdueBilling {
  const _$OverdueBillingImpl({
    required this.billingId,
    required this.yearMonth,
    required this.amount,
    required this.dueDate,
    required this.overdueDays,
  });

  factory _$OverdueBillingImpl.fromJson(Map<String, dynamic> json) =>
      _$$OverdueBillingImplFromJson(json);

  @override
  final String billingId;
  @override
  final String yearMonth;
  @override
  final int amount;
  @override
  final DateTime dueDate;
  @override
  final int overdueDays;

  @override
  String toString() {
    return 'OverdueBilling(billingId: $billingId, yearMonth: $yearMonth, amount: $amount, dueDate: $dueDate, overdueDays: $overdueDays)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OverdueBillingImpl &&
            (identical(other.billingId, billingId) ||
                other.billingId == billingId) &&
            (identical(other.yearMonth, yearMonth) ||
                other.yearMonth == yearMonth) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.overdueDays, overdueDays) ||
                other.overdueDays == overdueDays));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    billingId,
    yearMonth,
    amount,
    dueDate,
    overdueDays,
  );

  /// Create a copy of OverdueBilling
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OverdueBillingImplCopyWith<_$OverdueBillingImpl> get copyWith =>
      __$$OverdueBillingImplCopyWithImpl<_$OverdueBillingImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$OverdueBillingImplToJson(this);
  }
}

abstract class _OverdueBilling implements OverdueBilling {
  const factory _OverdueBilling({
    required final String billingId,
    required final String yearMonth,
    required final int amount,
    required final DateTime dueDate,
    required final int overdueDays,
  }) = _$OverdueBillingImpl;

  factory _OverdueBilling.fromJson(Map<String, dynamic> json) =
      _$OverdueBillingImpl.fromJson;

  @override
  String get billingId;
  @override
  String get yearMonth;
  @override
  int get amount;
  @override
  DateTime get dueDate;
  @override
  int get overdueDays;

  /// Create a copy of OverdueBilling
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OverdueBillingImplCopyWith<_$OverdueBillingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OccupancyReport _$OccupancyReportFromJson(Map<String, dynamic> json) {
  return _OccupancyReport.fromJson(json);
}

/// @nodoc
mixin _$OccupancyReport {
  String get propertyId => throw _privateConstructorUsedError;
  String get propertyName => throw _privateConstructorUsedError;
  int get totalUnits => throw _privateConstructorUsedError; // 총 유닛 수
  int get occupiedUnits => throw _privateConstructorUsedError; // 임대 중인 유닛 수
  int get vacantUnits => throw _privateConstructorUsedError; // 공실 유닛 수
  double get occupancyRate => throw _privateConstructorUsedError; // 점유율 (%)
  int get potentialMonthlyRevenue =>
      throw _privateConstructorUsedError; // 잠재 월 수익 (모든 유닛 임대 시)
  int get actualMonthlyRevenue => throw _privateConstructorUsedError; // 실제 월 수익
  int get revenueloss => throw _privateConstructorUsedError;

  /// Serializes this OccupancyReport to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OccupancyReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OccupancyReportCopyWith<OccupancyReport> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OccupancyReportCopyWith<$Res> {
  factory $OccupancyReportCopyWith(
    OccupancyReport value,
    $Res Function(OccupancyReport) then,
  ) = _$OccupancyReportCopyWithImpl<$Res, OccupancyReport>;
  @useResult
  $Res call({
    String propertyId,
    String propertyName,
    int totalUnits,
    int occupiedUnits,
    int vacantUnits,
    double occupancyRate,
    int potentialMonthlyRevenue,
    int actualMonthlyRevenue,
    int revenueloss,
  });
}

/// @nodoc
class _$OccupancyReportCopyWithImpl<$Res, $Val extends OccupancyReport>
    implements $OccupancyReportCopyWith<$Res> {
  _$OccupancyReportCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OccupancyReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? propertyId = null,
    Object? propertyName = null,
    Object? totalUnits = null,
    Object? occupiedUnits = null,
    Object? vacantUnits = null,
    Object? occupancyRate = null,
    Object? potentialMonthlyRevenue = null,
    Object? actualMonthlyRevenue = null,
    Object? revenueloss = null,
  }) {
    return _then(
      _value.copyWith(
            propertyId: null == propertyId
                ? _value.propertyId
                : propertyId // ignore: cast_nullable_to_non_nullable
                      as String,
            propertyName: null == propertyName
                ? _value.propertyName
                : propertyName // ignore: cast_nullable_to_non_nullable
                      as String,
            totalUnits: null == totalUnits
                ? _value.totalUnits
                : totalUnits // ignore: cast_nullable_to_non_nullable
                      as int,
            occupiedUnits: null == occupiedUnits
                ? _value.occupiedUnits
                : occupiedUnits // ignore: cast_nullable_to_non_nullable
                      as int,
            vacantUnits: null == vacantUnits
                ? _value.vacantUnits
                : vacantUnits // ignore: cast_nullable_to_non_nullable
                      as int,
            occupancyRate: null == occupancyRate
                ? _value.occupancyRate
                : occupancyRate // ignore: cast_nullable_to_non_nullable
                      as double,
            potentialMonthlyRevenue: null == potentialMonthlyRevenue
                ? _value.potentialMonthlyRevenue
                : potentialMonthlyRevenue // ignore: cast_nullable_to_non_nullable
                      as int,
            actualMonthlyRevenue: null == actualMonthlyRevenue
                ? _value.actualMonthlyRevenue
                : actualMonthlyRevenue // ignore: cast_nullable_to_non_nullable
                      as int,
            revenueloss: null == revenueloss
                ? _value.revenueloss
                : revenueloss // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OccupancyReportImplCopyWith<$Res>
    implements $OccupancyReportCopyWith<$Res> {
  factory _$$OccupancyReportImplCopyWith(
    _$OccupancyReportImpl value,
    $Res Function(_$OccupancyReportImpl) then,
  ) = __$$OccupancyReportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String propertyId,
    String propertyName,
    int totalUnits,
    int occupiedUnits,
    int vacantUnits,
    double occupancyRate,
    int potentialMonthlyRevenue,
    int actualMonthlyRevenue,
    int revenueloss,
  });
}

/// @nodoc
class __$$OccupancyReportImplCopyWithImpl<$Res>
    extends _$OccupancyReportCopyWithImpl<$Res, _$OccupancyReportImpl>
    implements _$$OccupancyReportImplCopyWith<$Res> {
  __$$OccupancyReportImplCopyWithImpl(
    _$OccupancyReportImpl _value,
    $Res Function(_$OccupancyReportImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OccupancyReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? propertyId = null,
    Object? propertyName = null,
    Object? totalUnits = null,
    Object? occupiedUnits = null,
    Object? vacantUnits = null,
    Object? occupancyRate = null,
    Object? potentialMonthlyRevenue = null,
    Object? actualMonthlyRevenue = null,
    Object? revenueloss = null,
  }) {
    return _then(
      _$OccupancyReportImpl(
        propertyId: null == propertyId
            ? _value.propertyId
            : propertyId // ignore: cast_nullable_to_non_nullable
                  as String,
        propertyName: null == propertyName
            ? _value.propertyName
            : propertyName // ignore: cast_nullable_to_non_nullable
                  as String,
        totalUnits: null == totalUnits
            ? _value.totalUnits
            : totalUnits // ignore: cast_nullable_to_non_nullable
                  as int,
        occupiedUnits: null == occupiedUnits
            ? _value.occupiedUnits
            : occupiedUnits // ignore: cast_nullable_to_non_nullable
                  as int,
        vacantUnits: null == vacantUnits
            ? _value.vacantUnits
            : vacantUnits // ignore: cast_nullable_to_non_nullable
                  as int,
        occupancyRate: null == occupancyRate
            ? _value.occupancyRate
            : occupancyRate // ignore: cast_nullable_to_non_nullable
                  as double,
        potentialMonthlyRevenue: null == potentialMonthlyRevenue
            ? _value.potentialMonthlyRevenue
            : potentialMonthlyRevenue // ignore: cast_nullable_to_non_nullable
                  as int,
        actualMonthlyRevenue: null == actualMonthlyRevenue
            ? _value.actualMonthlyRevenue
            : actualMonthlyRevenue // ignore: cast_nullable_to_non_nullable
                  as int,
        revenueloss: null == revenueloss
            ? _value.revenueloss
            : revenueloss // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OccupancyReportImpl extends _OccupancyReport {
  const _$OccupancyReportImpl({
    required this.propertyId,
    required this.propertyName,
    required this.totalUnits,
    required this.occupiedUnits,
    required this.vacantUnits,
    required this.occupancyRate,
    required this.potentialMonthlyRevenue,
    required this.actualMonthlyRevenue,
    required this.revenueloss,
  }) : super._();

  factory _$OccupancyReportImpl.fromJson(Map<String, dynamic> json) =>
      _$$OccupancyReportImplFromJson(json);

  @override
  final String propertyId;
  @override
  final String propertyName;
  @override
  final int totalUnits;
  // 총 유닛 수
  @override
  final int occupiedUnits;
  // 임대 중인 유닛 수
  @override
  final int vacantUnits;
  // 공실 유닛 수
  @override
  final double occupancyRate;
  // 점유율 (%)
  @override
  final int potentialMonthlyRevenue;
  // 잠재 월 수익 (모든 유닛 임대 시)
  @override
  final int actualMonthlyRevenue;
  // 실제 월 수익
  @override
  final int revenueloss;

  @override
  String toString() {
    return 'OccupancyReport(propertyId: $propertyId, propertyName: $propertyName, totalUnits: $totalUnits, occupiedUnits: $occupiedUnits, vacantUnits: $vacantUnits, occupancyRate: $occupancyRate, potentialMonthlyRevenue: $potentialMonthlyRevenue, actualMonthlyRevenue: $actualMonthlyRevenue, revenueloss: $revenueloss)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OccupancyReportImpl &&
            (identical(other.propertyId, propertyId) ||
                other.propertyId == propertyId) &&
            (identical(other.propertyName, propertyName) ||
                other.propertyName == propertyName) &&
            (identical(other.totalUnits, totalUnits) ||
                other.totalUnits == totalUnits) &&
            (identical(other.occupiedUnits, occupiedUnits) ||
                other.occupiedUnits == occupiedUnits) &&
            (identical(other.vacantUnits, vacantUnits) ||
                other.vacantUnits == vacantUnits) &&
            (identical(other.occupancyRate, occupancyRate) ||
                other.occupancyRate == occupancyRate) &&
            (identical(
                  other.potentialMonthlyRevenue,
                  potentialMonthlyRevenue,
                ) ||
                other.potentialMonthlyRevenue == potentialMonthlyRevenue) &&
            (identical(other.actualMonthlyRevenue, actualMonthlyRevenue) ||
                other.actualMonthlyRevenue == actualMonthlyRevenue) &&
            (identical(other.revenueloss, revenueloss) ||
                other.revenueloss == revenueloss));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    propertyId,
    propertyName,
    totalUnits,
    occupiedUnits,
    vacantUnits,
    occupancyRate,
    potentialMonthlyRevenue,
    actualMonthlyRevenue,
    revenueloss,
  );

  /// Create a copy of OccupancyReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OccupancyReportImplCopyWith<_$OccupancyReportImpl> get copyWith =>
      __$$OccupancyReportImplCopyWithImpl<_$OccupancyReportImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$OccupancyReportImplToJson(this);
  }
}

abstract class _OccupancyReport extends OccupancyReport {
  const factory _OccupancyReport({
    required final String propertyId,
    required final String propertyName,
    required final int totalUnits,
    required final int occupiedUnits,
    required final int vacantUnits,
    required final double occupancyRate,
    required final int potentialMonthlyRevenue,
    required final int actualMonthlyRevenue,
    required final int revenueloss,
  }) = _$OccupancyReportImpl;
  const _OccupancyReport._() : super._();

  factory _OccupancyReport.fromJson(Map<String, dynamic> json) =
      _$OccupancyReportImpl.fromJson;

  @override
  String get propertyId;
  @override
  String get propertyName;
  @override
  int get totalUnits; // 총 유닛 수
  @override
  int get occupiedUnits; // 임대 중인 유닛 수
  @override
  int get vacantUnits; // 공실 유닛 수
  @override
  double get occupancyRate; // 점유율 (%)
  @override
  int get potentialMonthlyRevenue; // 잠재 월 수익 (모든 유닛 임대 시)
  @override
  int get actualMonthlyRevenue; // 실제 월 수익
  @override
  int get revenueloss;

  /// Create a copy of OccupancyReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OccupancyReportImplCopyWith<_$OccupancyReportImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
