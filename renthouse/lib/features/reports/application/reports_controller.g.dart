// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reports_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$monthlyRevenueReportHash() =>
    r'8659e71fd29cd7a008510e1ec91e9525f308f0e3';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// 월별 수익 보고서 프로바이더
///
/// Copied from [monthlyRevenueReport].
@ProviderFor(monthlyRevenueReport)
const monthlyRevenueReportProvider = MonthlyRevenueReportFamily();

/// 월별 수익 보고서 프로바이더
///
/// Copied from [monthlyRevenueReport].
class MonthlyRevenueReportFamily
    extends Family<AsyncValue<MonthlyRevenueReport>> {
  /// 월별 수익 보고서 프로바이더
  ///
  /// Copied from [monthlyRevenueReport].
  const MonthlyRevenueReportFamily();

  /// 월별 수익 보고서 프로바이더
  ///
  /// Copied from [monthlyRevenueReport].
  MonthlyRevenueReportProvider call(String yearMonth) {
    return MonthlyRevenueReportProvider(yearMonth);
  }

  @override
  MonthlyRevenueReportProvider getProviderOverride(
    covariant MonthlyRevenueReportProvider provider,
  ) {
    return call(provider.yearMonth);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'monthlyRevenueReportProvider';
}

/// 월별 수익 보고서 프로바이더
///
/// Copied from [monthlyRevenueReport].
class MonthlyRevenueReportProvider
    extends AutoDisposeFutureProvider<MonthlyRevenueReport> {
  /// 월별 수익 보고서 프로바이더
  ///
  /// Copied from [monthlyRevenueReport].
  MonthlyRevenueReportProvider(String yearMonth)
    : this._internal(
        (ref) =>
            monthlyRevenueReport(ref as MonthlyRevenueReportRef, yearMonth),
        from: monthlyRevenueReportProvider,
        name: r'monthlyRevenueReportProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$monthlyRevenueReportHash,
        dependencies: MonthlyRevenueReportFamily._dependencies,
        allTransitiveDependencies:
            MonthlyRevenueReportFamily._allTransitiveDependencies,
        yearMonth: yearMonth,
      );

  MonthlyRevenueReportProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.yearMonth,
  }) : super.internal();

  final String yearMonth;

  @override
  Override overrideWith(
    FutureOr<MonthlyRevenueReport> Function(MonthlyRevenueReportRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MonthlyRevenueReportProvider._internal(
        (ref) => create(ref as MonthlyRevenueReportRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        yearMonth: yearMonth,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<MonthlyRevenueReport> createElement() {
    return _MonthlyRevenueReportProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MonthlyRevenueReportProvider &&
        other.yearMonth == yearMonth;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, yearMonth.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MonthlyRevenueReportRef
    on AutoDisposeFutureProviderRef<MonthlyRevenueReport> {
  /// The parameter `yearMonth` of this provider.
  String get yearMonth;
}

class _MonthlyRevenueReportProviderElement
    extends AutoDisposeFutureProviderElement<MonthlyRevenueReport>
    with MonthlyRevenueReportRef {
  _MonthlyRevenueReportProviderElement(super.provider);

  @override
  String get yearMonth => (origin as MonthlyRevenueReportProvider).yearMonth;
}

String _$overdueReportsHash() => r'f4e1102a78db1b2f7f714214dc71534e7f3a418c';

/// 연체 보고서 프로바이더
///
/// Copied from [overdueReports].
@ProviderFor(overdueReports)
final overdueReportsProvider =
    AutoDisposeFutureProvider<List<OverdueReport>>.internal(
      overdueReports,
      name: r'overdueReportsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$overdueReportsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef OverdueReportsRef = AutoDisposeFutureProviderRef<List<OverdueReport>>;
String _$occupancyReportsHash() => r'771bcba3d6e6c67eda249ebc776fbc91eb9ac841';

/// 점유율 보고서 프로바이더
///
/// Copied from [occupancyReports].
@ProviderFor(occupancyReports)
final occupancyReportsProvider =
    AutoDisposeFutureProvider<List<OccupancyReport>>.internal(
      occupancyReports,
      name: r'occupancyReportsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$occupancyReportsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef OccupancyReportsRef =
    AutoDisposeFutureProviderRef<List<OccupancyReport>>;
String _$reportsControllerHash() => r'0d7c4b0d42188b0527f69ed79962fe82ad4adefe';

/// See also [ReportsController].
@ProviderFor(ReportsController)
final reportsControllerProvider =
    AutoDisposeAsyncNotifierProvider<ReportsController, void>.internal(
      ReportsController.new,
      name: r'reportsControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$reportsControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ReportsController = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
