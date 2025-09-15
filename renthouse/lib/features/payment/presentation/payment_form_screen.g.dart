// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_form_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$billingDisplayHash() => r'12615c18c139641b682035f98541b2a38b13e535';

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

/// See also [billingDisplay].
@ProviderFor(billingDisplay)
const billingDisplayProvider = BillingDisplayFamily();

/// See also [billingDisplay].
class BillingDisplayFamily extends Family<AsyncValue<String>> {
  /// See also [billingDisplay].
  const BillingDisplayFamily();

  /// See also [billingDisplay].
  BillingDisplayProvider call(Billing billing) {
    return BillingDisplayProvider(billing);
  }

  @override
  BillingDisplayProvider getProviderOverride(
    covariant BillingDisplayProvider provider,
  ) {
    return call(provider.billing);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'billingDisplayProvider';
}

/// See also [billingDisplay].
class BillingDisplayProvider extends AutoDisposeFutureProvider<String> {
  /// See also [billingDisplay].
  BillingDisplayProvider(Billing billing)
    : this._internal(
        (ref) => billingDisplay(ref as BillingDisplayRef, billing),
        from: billingDisplayProvider,
        name: r'billingDisplayProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$billingDisplayHash,
        dependencies: BillingDisplayFamily._dependencies,
        allTransitiveDependencies:
            BillingDisplayFamily._allTransitiveDependencies,
        billing: billing,
      );

  BillingDisplayProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.billing,
  }) : super.internal();

  final Billing billing;

  @override
  Override overrideWith(
    FutureOr<String> Function(BillingDisplayRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BillingDisplayProvider._internal(
        (ref) => create(ref as BillingDisplayRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        billing: billing,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<String> createElement() {
    return _BillingDisplayProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BillingDisplayProvider && other.billing == billing;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, billing.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin BillingDisplayRef on AutoDisposeFutureProviderRef<String> {
  /// The parameter `billing` of this provider.
  Billing get billing;
}

class _BillingDisplayProviderElement
    extends AutoDisposeFutureProviderElement<String>
    with BillingDisplayRef {
  _BillingDisplayProviderElement(super.provider);

  @override
  Billing get billing => (origin as BillingDisplayProvider).billing;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
