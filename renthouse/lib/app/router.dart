import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:renthouse/app/main_layout.dart';
import 'package:renthouse/features/billing/application/bill_template_controller.dart';
import 'package:renthouse/features/billing/application/billing_controller.dart';
import 'package:renthouse/features/billing/presentation/bill_template_form_screen.dart';
import 'package:renthouse/features/billing/presentation/bill_template_list_screen.dart';
import 'package:renthouse/features/billing/presentation/billing_form_screen.dart';
import 'package:renthouse/features/billing/presentation/billing_list_screen.dart';
import 'package:renthouse/features/lease/application/lease_controller.dart';
import 'package:renthouse/features/lease/presentation/lease_form_screen.dart';
import 'package:renthouse/features/lease/presentation/lease_list_screen.dart';
import 'package:renthouse/features/property/application/property_controller.dart';
import 'package:renthouse/features/property/presentation/property_detail_screen.dart';
import 'package:renthouse/features/tenant/application/tenant_controller.dart';
import 'package:renthouse/features/tenant/presentation/tenant_form_screen.dart';
import 'package:renthouse/features/tenant/presentation/tenant_list_screen.dart';
import '../core/auth/auth_state.dart';
import '../features/dashboard/presentation/dashboard_screen.dart';
import '../features/property/presentation/property_list_screen.dart';
import '../features/property/presentation/property_form_screen.dart';
import '../features/auth/login_screen.dart';

final authState = AuthState.instance; // 간단 싱글톤(초기 PoC용)

final router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final loggedIn = authState.isLoggedIn;
    final loggingIn = state.matchedLocation == '/login';
    if (!loggedIn && !loggingIn) return '/login';
    if (loggedIn && loggingIn) return '/admin/dashboard';
    return null;
  },
  routes: [
    GoRoute(path: '/login', builder: (c, s) => const LoginScreen()),
    ShellRoute(
      builder: (context, state, child) {
        return MainLayout(child: child);
      },
      routes: [
        GoRoute(path: '/', redirect: (_, __) => '/admin/dashboard'),
        GoRoute(path: '/admin/dashboard', builder: (c, s) => const DashboardScreen()),
        GoRoute(path: '/property', builder: (c, s) => const PropertyListScreen()),
        GoRoute(path: '/tenants', builder: (c, s) => const TenantListScreen()),
        GoRoute(path: '/leases', builder: (c, s) => const LeaseListScreen()),
        GoRoute(path: '/billing', builder: (c, s) => const BillingListScreen()),
      ],
    ),
    GoRoute(path: '/property/new', builder: (c, s) => const PropertyFormScreen()),
    GoRoute(
        path: '/property/:id',
        builder: (context, state) {
          final propertyId = state.pathParameters['id']!;
          final container = ProviderScope.containerOf(context);
          final property =
              container.read(propertyListControllerProvider.notifier).properties.firstWhereOrNull((p) => p.id == propertyId);

          if (property == null) {
            return const Scaffold(
              body: Center(
                child: Text('Property not found'),
              ),
            );
          }
          return PropertyDetailScreen(property: property);
        }),
    GoRoute(
        path: '/property/edit/:id',
        builder: (context, state) {
          final propertyId = state.pathParameters['id']!;
          final container = ProviderScope.containerOf(context);
          final property =
              container.read(propertyListControllerProvider.notifier).properties.firstWhereOrNull((p) => p.id == propertyId);

          if (property == null) {
            return const Scaffold(
              body: Center(
                child: Text('Property not found'),
              ),
            );
          }
          return PropertyFormScreen(property: property);
        }),
    GoRoute(path: '/tenants/new', builder: (c, s) => const TenantFormScreen()),
    GoRoute(
        path: '/tenants/edit/:id',
        builder: (context, state) {
          final tenantId = state.pathParameters['id']!;
          final container = ProviderScope.containerOf(context);
          final tenant = 
              container.read(tenantControllerProvider).value?.firstWhereOrNull((t) => t.id == tenantId);

          if (tenant == null) {
            return const Scaffold(
              body: Center(
                child: Text('Tenant not found'),
              ),
            );
          }
          return TenantFormScreen(tenant: tenant);
        }),
    GoRoute(path: '/leases/new', builder: (c, s) => const LeaseFormScreen()),
    GoRoute(
        path: '/leases/edit/:id',
        builder: (context, state) {
          final leaseId = state.pathParameters['id']!;
          final container = ProviderScope.containerOf(context);
          final lease = 
              container.read(leaseControllerProvider).value?.firstWhereOrNull((l) => l.id == leaseId);

          if (lease == null) {
            return const Scaffold(
              body: Center(
                child: Text('Lease not found'),
              ),
            );
          }
          return LeaseFormScreen(lease: lease);
        }),
    GoRoute(path: '/billing/templates', builder: (c, s) => const BillTemplateListScreen()),
    GoRoute(path: '/billing/templates/new', builder: (c, s) => const BillTemplateFormScreen()),
    GoRoute(
        path: '/billing/templates/edit/:id',
        builder: (context, state) {
          final templateId = state.pathParameters['id']!;
          final container = ProviderScope.containerOf(context);
          final template = 
              container.read(billTemplateControllerProvider).value?.firstWhereOrNull((t) => t.id == templateId);

          if (template == null) {
            return const Scaffold(
              body: Center(
                child: Text('Template not found'),
              ),
            );
          }
          return BillTemplateFormScreen(template: template);
        }),
    GoRoute(path: '/billing/new', builder: (c, s) => const BillingFormScreen()),
    GoRoute(
        path: '/billing/edit/:id',
        builder: (context, state) {
          final billingId = state.pathParameters['id']!;
          final container = ProviderScope.containerOf(context);
          final billing = 
              container.read(billingControllerProvider).value?.firstWhereOrNull((b) => b.id == billingId);

          if (billing == null) {
            return const Scaffold(
              body: Center(
                child: Text('Billing not found'),
              ),
            );
          }
          return BillingFormScreen(billing: billing);
        }),
  ],
);
