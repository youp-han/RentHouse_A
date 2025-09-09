// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'billing_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$billingControllerHash() => r'377734db1b0f925a32dfc93b2ec8f4d926a63a8c';

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

abstract class _$BillingController
    extends BuildlessAutoDisposeAsyncNotifier<List<Billing>> {
  late final String? searchQuery;

  FutureOr<List<Billing>> build({String? searchQuery});
}

/// See also [BillingController].
@ProviderFor(BillingController)
const billingControllerProvider = BillingControllerFamily();

/// See also [BillingController].
class BillingControllerFamily extends Family<AsyncValue<List<Billing>>> {
  /// See also [BillingController].
  const BillingControllerFamily();

  /// See also [BillingController].
  BillingControllerProvider call({String? searchQuery}) {
    return BillingControllerProvider(searchQuery: searchQuery);
  }

  @override
  BillingControllerProvider getProviderOverride(
    covariant BillingControllerProvider provider,
  ) {
    return call(searchQuery: provider.searchQuery);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'billingControllerProvider';
}

/// See also [BillingController].
class BillingControllerProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<BillingController, List<Billing>> {
  /// See also [BillingController].
  BillingControllerProvider({String? searchQuery})
    : this._internal(
        () => BillingController()..searchQuery = searchQuery,
        from: billingControllerProvider,
        name: r'billingControllerProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$billingControllerHash,
        dependencies: BillingControllerFamily._dependencies,
        allTransitiveDependencies:
            BillingControllerFamily._allTransitiveDependencies,
        searchQuery: searchQuery,
      );

  BillingControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.searchQuery,
  }) : super.internal();

  final String? searchQuery;

  @override
  FutureOr<List<Billing>> runNotifierBuild(
    covariant BillingController notifier,
  ) {
    return notifier.build(searchQuery: searchQuery);
  }

  @override
  Override overrideWith(BillingController Function() create) {
    return ProviderOverride(
      origin: this,
      override: BillingControllerProvider._internal(
        () => create()..searchQuery = searchQuery,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        searchQuery: searchQuery,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<BillingController, List<Billing>>
  createElement() {
    return _BillingControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BillingControllerProvider &&
        other.searchQuery == searchQuery;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, searchQuery.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin BillingControllerRef
    on AutoDisposeAsyncNotifierProviderRef<List<Billing>> {
  /// The parameter `searchQuery` of this provider.
  String? get searchQuery;
}

class _BillingControllerProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          BillingController,
          List<Billing>
        >
    with BillingControllerRef {
  _BillingControllerProviderElement(super.provider);

  @override
  String? get searchQuery => (origin as BillingControllerProvider).searchQuery;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
