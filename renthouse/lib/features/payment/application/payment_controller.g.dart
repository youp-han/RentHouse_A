// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$paymentsByTenantHash() => r'07aedda04ee1f8b04ea90d70b492246c1d73e889';

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

/// See also [paymentsByTenant].
@ProviderFor(paymentsByTenant)
const paymentsByTenantProvider = PaymentsByTenantFamily();

/// See also [paymentsByTenant].
class PaymentsByTenantFamily extends Family<AsyncValue<List<Payment>>> {
  /// See also [paymentsByTenant].
  const PaymentsByTenantFamily();

  /// See also [paymentsByTenant].
  PaymentsByTenantProvider call(String tenantId) {
    return PaymentsByTenantProvider(tenantId);
  }

  @override
  PaymentsByTenantProvider getProviderOverride(
    covariant PaymentsByTenantProvider provider,
  ) {
    return call(provider.tenantId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'paymentsByTenantProvider';
}

/// See also [paymentsByTenant].
class PaymentsByTenantProvider
    extends AutoDisposeFutureProvider<List<Payment>> {
  /// See also [paymentsByTenant].
  PaymentsByTenantProvider(String tenantId)
    : this._internal(
        (ref) => paymentsByTenant(ref as PaymentsByTenantRef, tenantId),
        from: paymentsByTenantProvider,
        name: r'paymentsByTenantProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$paymentsByTenantHash,
        dependencies: PaymentsByTenantFamily._dependencies,
        allTransitiveDependencies:
            PaymentsByTenantFamily._allTransitiveDependencies,
        tenantId: tenantId,
      );

  PaymentsByTenantProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.tenantId,
  }) : super.internal();

  final String tenantId;

  @override
  Override overrideWith(
    FutureOr<List<Payment>> Function(PaymentsByTenantRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PaymentsByTenantProvider._internal(
        (ref) => create(ref as PaymentsByTenantRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        tenantId: tenantId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Payment>> createElement() {
    return _PaymentsByTenantProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PaymentsByTenantProvider && other.tenantId == tenantId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, tenantId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PaymentsByTenantRef on AutoDisposeFutureProviderRef<List<Payment>> {
  /// The parameter `tenantId` of this provider.
  String get tenantId;
}

class _PaymentsByTenantProviderElement
    extends AutoDisposeFutureProviderElement<List<Payment>>
    with PaymentsByTenantRef {
  _PaymentsByTenantProviderElement(super.provider);

  @override
  String get tenantId => (origin as PaymentsByTenantProvider).tenantId;
}

String _$autoAllocationPreviewHash() =>
    r'633dc1e52fbc787e167f553a39a417cda1decb3e';

/// See also [autoAllocationPreview].
@ProviderFor(autoAllocationPreview)
const autoAllocationPreviewProvider = AutoAllocationPreviewFamily();

/// See also [autoAllocationPreview].
class AutoAllocationPreviewFamily
    extends Family<AsyncValue<AutoAllocationResult>> {
  /// See also [autoAllocationPreview].
  const AutoAllocationPreviewFamily();

  /// See also [autoAllocationPreview].
  AutoAllocationPreviewProvider call(String tenantId, int amount) {
    return AutoAllocationPreviewProvider(tenantId, amount);
  }

  @override
  AutoAllocationPreviewProvider getProviderOverride(
    covariant AutoAllocationPreviewProvider provider,
  ) {
    return call(provider.tenantId, provider.amount);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'autoAllocationPreviewProvider';
}

/// See also [autoAllocationPreview].
class AutoAllocationPreviewProvider
    extends AutoDisposeFutureProvider<AutoAllocationResult> {
  /// See also [autoAllocationPreview].
  AutoAllocationPreviewProvider(String tenantId, int amount)
    : this._internal(
        (ref) => autoAllocationPreview(
          ref as AutoAllocationPreviewRef,
          tenantId,
          amount,
        ),
        from: autoAllocationPreviewProvider,
        name: r'autoAllocationPreviewProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$autoAllocationPreviewHash,
        dependencies: AutoAllocationPreviewFamily._dependencies,
        allTransitiveDependencies:
            AutoAllocationPreviewFamily._allTransitiveDependencies,
        tenantId: tenantId,
        amount: amount,
      );

  AutoAllocationPreviewProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.tenantId,
    required this.amount,
  }) : super.internal();

  final String tenantId;
  final int amount;

  @override
  Override overrideWith(
    FutureOr<AutoAllocationResult> Function(AutoAllocationPreviewRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AutoAllocationPreviewProvider._internal(
        (ref) => create(ref as AutoAllocationPreviewRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        tenantId: tenantId,
        amount: amount,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<AutoAllocationResult> createElement() {
    return _AutoAllocationPreviewProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AutoAllocationPreviewProvider &&
        other.tenantId == tenantId &&
        other.amount == amount;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, tenantId.hashCode);
    hash = _SystemHash.combine(hash, amount.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AutoAllocationPreviewRef
    on AutoDisposeFutureProviderRef<AutoAllocationResult> {
  /// The parameter `tenantId` of this provider.
  String get tenantId;

  /// The parameter `amount` of this provider.
  int get amount;
}

class _AutoAllocationPreviewProviderElement
    extends AutoDisposeFutureProviderElement<AutoAllocationResult>
    with AutoAllocationPreviewRef {
  _AutoAllocationPreviewProviderElement(super.provider);

  @override
  String get tenantId => (origin as AutoAllocationPreviewProvider).tenantId;
  @override
  int get amount => (origin as AutoAllocationPreviewProvider).amount;
}

String _$paymentAllocationsHash() =>
    r'b36892e11a3e9157975d5389d8cb87e0b8259286';

/// See also [paymentAllocations].
@ProviderFor(paymentAllocations)
const paymentAllocationsProvider = PaymentAllocationsFamily();

/// See also [paymentAllocations].
class PaymentAllocationsFamily
    extends Family<AsyncValue<List<PaymentAllocation>>> {
  /// See also [paymentAllocations].
  const PaymentAllocationsFamily();

  /// See also [paymentAllocations].
  PaymentAllocationsProvider call(String paymentId) {
    return PaymentAllocationsProvider(paymentId);
  }

  @override
  PaymentAllocationsProvider getProviderOverride(
    covariant PaymentAllocationsProvider provider,
  ) {
    return call(provider.paymentId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'paymentAllocationsProvider';
}

/// See also [paymentAllocations].
class PaymentAllocationsProvider
    extends AutoDisposeFutureProvider<List<PaymentAllocation>> {
  /// See also [paymentAllocations].
  PaymentAllocationsProvider(String paymentId)
    : this._internal(
        (ref) => paymentAllocations(ref as PaymentAllocationsRef, paymentId),
        from: paymentAllocationsProvider,
        name: r'paymentAllocationsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$paymentAllocationsHash,
        dependencies: PaymentAllocationsFamily._dependencies,
        allTransitiveDependencies:
            PaymentAllocationsFamily._allTransitiveDependencies,
        paymentId: paymentId,
      );

  PaymentAllocationsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.paymentId,
  }) : super.internal();

  final String paymentId;

  @override
  Override overrideWith(
    FutureOr<List<PaymentAllocation>> Function(PaymentAllocationsRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PaymentAllocationsProvider._internal(
        (ref) => create(ref as PaymentAllocationsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        paymentId: paymentId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<PaymentAllocation>> createElement() {
    return _PaymentAllocationsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PaymentAllocationsProvider && other.paymentId == paymentId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, paymentId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PaymentAllocationsRef
    on AutoDisposeFutureProviderRef<List<PaymentAllocation>> {
  /// The parameter `paymentId` of this provider.
  String get paymentId;
}

class _PaymentAllocationsProviderElement
    extends AutoDisposeFutureProviderElement<List<PaymentAllocation>>
    with PaymentAllocationsRef {
  _PaymentAllocationsProviderElement(super.provider);

  @override
  String get paymentId => (origin as PaymentAllocationsProvider).paymentId;
}

String _$billingAllocationsHash() =>
    r'c0341087ef0fa8aac55b129cd2db1451d45fbd94';

/// See also [billingAllocations].
@ProviderFor(billingAllocations)
const billingAllocationsProvider = BillingAllocationsFamily();

/// See also [billingAllocations].
class BillingAllocationsFamily
    extends Family<AsyncValue<List<PaymentAllocation>>> {
  /// See also [billingAllocations].
  const BillingAllocationsFamily();

  /// See also [billingAllocations].
  BillingAllocationsProvider call(String billingId) {
    return BillingAllocationsProvider(billingId);
  }

  @override
  BillingAllocationsProvider getProviderOverride(
    covariant BillingAllocationsProvider provider,
  ) {
    return call(provider.billingId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'billingAllocationsProvider';
}

/// See also [billingAllocations].
class BillingAllocationsProvider
    extends AutoDisposeFutureProvider<List<PaymentAllocation>> {
  /// See also [billingAllocations].
  BillingAllocationsProvider(String billingId)
    : this._internal(
        (ref) => billingAllocations(ref as BillingAllocationsRef, billingId),
        from: billingAllocationsProvider,
        name: r'billingAllocationsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$billingAllocationsHash,
        dependencies: BillingAllocationsFamily._dependencies,
        allTransitiveDependencies:
            BillingAllocationsFamily._allTransitiveDependencies,
        billingId: billingId,
      );

  BillingAllocationsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.billingId,
  }) : super.internal();

  final String billingId;

  @override
  Override overrideWith(
    FutureOr<List<PaymentAllocation>> Function(BillingAllocationsRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BillingAllocationsProvider._internal(
        (ref) => create(ref as BillingAllocationsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        billingId: billingId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<PaymentAllocation>> createElement() {
    return _BillingAllocationsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BillingAllocationsProvider && other.billingId == billingId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, billingId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin BillingAllocationsRef
    on AutoDisposeFutureProviderRef<List<PaymentAllocation>> {
  /// The parameter `billingId` of this provider.
  String get billingId;
}

class _BillingAllocationsProviderElement
    extends AutoDisposeFutureProviderElement<List<PaymentAllocation>>
    with BillingAllocationsRef {
  _BillingAllocationsProviderElement(super.provider);

  @override
  String get billingId => (origin as BillingAllocationsProvider).billingId;
}

String _$monthlyPaymentStatsHash() =>
    r'2dabc135a9429ec4a5c19ba5a1115075918a5167';

/// See also [monthlyPaymentStats].
@ProviderFor(monthlyPaymentStats)
const monthlyPaymentStatsProvider = MonthlyPaymentStatsFamily();

/// See also [monthlyPaymentStats].
class MonthlyPaymentStatsFamily extends Family<AsyncValue<Map<String, int>>> {
  /// See also [monthlyPaymentStats].
  const MonthlyPaymentStatsFamily();

  /// See also [monthlyPaymentStats].
  MonthlyPaymentStatsProvider call(int year, int month) {
    return MonthlyPaymentStatsProvider(year, month);
  }

  @override
  MonthlyPaymentStatsProvider getProviderOverride(
    covariant MonthlyPaymentStatsProvider provider,
  ) {
    return call(provider.year, provider.month);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'monthlyPaymentStatsProvider';
}

/// See also [monthlyPaymentStats].
class MonthlyPaymentStatsProvider
    extends AutoDisposeFutureProvider<Map<String, int>> {
  /// See also [monthlyPaymentStats].
  MonthlyPaymentStatsProvider(int year, int month)
    : this._internal(
        (ref) =>
            monthlyPaymentStats(ref as MonthlyPaymentStatsRef, year, month),
        from: monthlyPaymentStatsProvider,
        name: r'monthlyPaymentStatsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$monthlyPaymentStatsHash,
        dependencies: MonthlyPaymentStatsFamily._dependencies,
        allTransitiveDependencies:
            MonthlyPaymentStatsFamily._allTransitiveDependencies,
        year: year,
        month: month,
      );

  MonthlyPaymentStatsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.year,
    required this.month,
  }) : super.internal();

  final int year;
  final int month;

  @override
  Override overrideWith(
    FutureOr<Map<String, int>> Function(MonthlyPaymentStatsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MonthlyPaymentStatsProvider._internal(
        (ref) => create(ref as MonthlyPaymentStatsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        year: year,
        month: month,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<String, int>> createElement() {
    return _MonthlyPaymentStatsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MonthlyPaymentStatsProvider &&
        other.year == year &&
        other.month == month;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, year.hashCode);
    hash = _SystemHash.combine(hash, month.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MonthlyPaymentStatsRef on AutoDisposeFutureProviderRef<Map<String, int>> {
  /// The parameter `year` of this provider.
  int get year;

  /// The parameter `month` of this provider.
  int get month;
}

class _MonthlyPaymentStatsProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, int>>
    with MonthlyPaymentStatsRef {
  _MonthlyPaymentStatsProviderElement(super.provider);

  @override
  int get year => (origin as MonthlyPaymentStatsProvider).year;
  @override
  int get month => (origin as MonthlyPaymentStatsProvider).month;
}

String _$paymentControllerHash() => r'dd1159e49ccc668aa3c403c5e255852b69cb0bf0';

/// See also [PaymentController].
@ProviderFor(PaymentController)
final paymentControllerProvider =
    AutoDisposeAsyncNotifierProvider<PaymentController, List<Payment>>.internal(
      PaymentController.new,
      name: r'paymentControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$paymentControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PaymentController = AutoDisposeAsyncNotifier<List<Payment>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
