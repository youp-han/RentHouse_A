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
import 'package:renthouse/features/lease/presentation/lease_detail_screen.dart';
import 'package:renthouse/features/lease/presentation/lease_list_screen.dart';
import 'package:renthouse/features/property/data/property_repository.dart';
import 'package:renthouse/features/property/presentation/property_detail_screen.dart';
import 'package:renthouse/features/property/presentation/unit_detail_screen.dart';
import 'package:renthouse/features/property/presentation/unit_form_screen.dart';
import 'package:renthouse/features/tenant/application/tenant_controller.dart';
import 'package:renthouse/features/tenant/presentation/tenant_form_screen.dart';
import 'package:renthouse/features/tenant/presentation/tenant_detail_screen.dart';
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
        
        // Property Routes
        GoRoute(
          path: '/property',
          builder: (c, s) => const PropertyListScreen(),
          routes: [
            GoRoute(path: 'new', builder: (c, s) => const PropertyFormScreen()),
            GoRoute(
                path: ':id',
                builder: (context, state) {
                  final propertyId = state.pathParameters['id']!;
                  return PropertyDetailScreen(propertyId: propertyId);
                }),
            GoRoute(
                path: 'edit/:id',
                builder: (context, state) {
                  final propertyId = state.pathParameters['id']!;
                  return Consumer(builder: (context, ref, child) {
                    final propertyAsync = ref.watch(propertyDetailProvider(propertyId));
                    return propertyAsync.when(
                      data: (property) {
                        if (property == null) {
                          return const Scaffold(body: Center(child: Text('Property not found')));
                        }
                        return PropertyFormScreen(property: property);
                      },
                      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
                      error: (err, stack) => Scaffold(body: Center(child: Text('Error: $err'))),
                    );
                  });
                }),
            GoRoute(
                path: ':id/units/add',
                builder: (context, state) {
                  final propertyId = state.pathParameters['id']!;
                  return UnitFormScreen(propertyId: propertyId);
                }),
            GoRoute(
                path: ':id/units/edit/:unitId',
                builder: (context, state) {
                  final propertyId = state.pathParameters['id']!;
                  final unitId = state.pathParameters['unitId']!;
                  return UnitFormScreen(propertyId: propertyId, unitId: unitId);
                }),
            GoRoute(
                path: ':id/units/:unitId',
                builder: (context, state) {
                  final propertyId = state.pathParameters['id']!;
                  final unitId = state.pathParameters['unitId']!;
                  return UnitDetailScreen(
                      propertyId: propertyId, unitId: unitId);
                }),
          ]
        ),

        // Tenant Routes
        GoRoute(
          path: '/tenants',
          builder: (c, s) => const TenantListScreen(),
          routes: [
            GoRoute(path: 'new', builder: (c, s) => const TenantFormScreen()),
            GoRoute(
                path: ':id',
                builder: (context, state) {
                  final tenantId = state.pathParameters['id']!;
                  return TenantDetailScreen(tenantId: tenantId);
                }),
            GoRoute(
                path: 'edit/:id',
                builder: (context, state) {
                  final tenantId = state.pathParameters['id']!;
                  return Consumer(builder: (context, ref, child) {
                    final tenant = ref.watch(tenantControllerProvider).value?.firstWhereOrNull((t) => t.id == tenantId);
                    if (tenant == null) {
                      return const Scaffold(
                        body: Center(
                          child: Text('Tenant not found'),
                        ),
                      );
                    }
                    return TenantFormScreen(tenant: tenant);
                  });
                }),
          ]
        ),

        // Lease Routes
        GoRoute(
          path: '/leases',
          builder: (c, s) => const LeaseListScreen(),
          routes: [
            GoRoute(path: 'new', builder: (c, s) => const LeaseFormScreen()),
            GoRoute(
                path: ':id',
                builder: (context, state) {
                  final leaseId = state.pathParameters['id']!;
                  return LeaseDetailScreen(leaseId: leaseId);
                }),
            GoRoute(
                path: 'edit/:id',
                builder: (context, state) {
                  final leaseId = state.pathParameters['id']!;
                  return Consumer(builder: (context, ref, child) {
                    final lease = ref.watch(leaseControllerProvider).value?.firstWhereOrNull((l) => l.id == leaseId);
                    if (lease == null) {
                      return const Scaffold(
                        body: Center(
                          child: Text('Lease not found'),
                        ),
                      );
                    }
                    return LeaseFormScreen(lease: lease);
                  });
                }),
          ]
        ),

        // Billing Routes
        GoRoute(
          path: '/billing',
          builder: (c, s) => const BillingListScreen(),
          routes: [
            GoRoute(path: 'new', builder: (c, s) => const BillingFormScreen()),
            GoRoute(
                path: 'edit/:id',
                builder: (context, state) {
                  final billingId = state.pathParameters['id']!;
                  return Consumer(builder: (context, ref, child) {
                    final billing = ref.watch(billingControllerProvider).value?.firstWhereOrNull((b) => b.id == billingId);
                    if (billing == null) {
                      return const Scaffold(
                        body: Center(
                          child: Text('Billing not found'),
                        ),
                      );
                    }
                    return BillingFormScreen(billing: billing);
                  });
                }),
            GoRoute(path: 'templates', builder: (c, s) => const BillTemplateListScreen()),
            GoRoute(path: 'templates/new', builder: (c, s) => const BillTemplateFormScreen()),
            GoRoute(
                path: 'templates/edit/:id',
                builder: (context, state) {
                  final templateId = state.pathParameters['id']!;
                  return Consumer(builder: (context, ref, child) {
                    final template = ref.watch(billTemplateControllerProvider).value?.firstWhereOrNull((t) => t.id == templateId);
                    if (template == null) {
                      return const Scaffold(
                        body: Center(
                          child: Text('Template not found'),
                        ),
                      );
                    }
                    return BillTemplateFormScreen(template: template);
                  });
                }),
          ]
        ),
      ],
    ),
  ],
);