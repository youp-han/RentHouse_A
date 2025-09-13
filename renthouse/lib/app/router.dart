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
import 'package:renthouse/features/property/data/property_repository.dart';
import 'package:renthouse/features/property/presentation/property_detail_screen.dart';

import 'package:renthouse/features/property/presentation/unit_form_screen.dart';
import 'package:renthouse/features/tenant/application/tenant_controller.dart';
import 'package:renthouse/features/tenant/presentation/tenant_form_screen.dart';
import 'package:renthouse/features/tenant/presentation/tenant_list_screen.dart';
import 'package:renthouse/features/tenant/domain/tenant.dart';
import '../core/auth/auth_state.dart';
import '../features/dashboard/presentation/dashboard_screen.dart';
import '../features/property/presentation/property_list_screen.dart';
import '../features/property/presentation/property_form_screen.dart';
import 'package:renthouse/features/auth/presentation/login_screen.dart' as new_login;
import 'package:renthouse/features/auth/presentation/register_screen.dart';
import 'package:renthouse/features/settings/presentation/settings_screen.dart';
import 'package:renthouse/features/settings/presentation/profile_screen.dart';
import 'package:renthouse/features/settings/presentation/currency_screen.dart';
import 'package:renthouse/features/payment/presentation/revenue_screen.dart';
import 'package:renthouse/features/payment/presentation/payment_form_screen.dart';
import 'package:renthouse/features/payment/presentation/payment_list_screen.dart';
import 'package:renthouse/features/reports/presentation/reports_screen.dart';

final authState = AuthState.instance;

final router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final loggedIn = authState.isLoggedIn;
    final loggingIn = state.matchedLocation == '/login';
    final registering = state.matchedLocation == '/register';
    
    if (!loggedIn && !loggingIn && !registering) return '/login';
    if (loggedIn && (loggingIn || registering)) return '/admin/dashboard';
    return null;
  },
  routes: [
    GoRoute(path: '/login', builder: (c, s) => const new_login.LoginScreen()),
    GoRoute(path: '/register', builder: (c, s) => const RegisterScreen()),
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
            
          ]
        ),

        // Tenant Routes
        GoRoute(
          path: '/tenants',
          builder: (c, s) => const TenantListScreen(),
          routes: [
            GoRoute(path: 'new', builder: (c, s) => const TenantFormScreen()),
            
            GoRoute(
                path: 'edit/:id',
                builder: (context, state) {
                  final tenantId = state.pathParameters['id']!;
                  return Consumer(builder: (context, ref, child) {
                    final tenantsFuture = ref.watch(tenantControllerProvider.future);
                    return FutureBuilder<List<Tenant>>(
                      future: tenantsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Scaffold(body: Center(child: CircularProgressIndicator()));
                        } else if (snapshot.hasError) {
                          return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
                        } else if (snapshot.hasData) {
                          final tenants = snapshot.data!;
                          Tenant? tenant;
                          for (var t in tenants) {
                            if (t.id == tenantId) {
                              tenant = t;
                              break;
                            }
                          }
                          if (tenant == null) {
                            return const Scaffold(body: Center(child: Text('Tenant not found')));
                          }
                          return TenantFormScreen(tenant: tenant);
                        }
                        return const Scaffold(body: Center(child: Text('Unknown state')));
                      },
                    );
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
                    final billing = ref.watch(billingControllerProvider()).value?.firstWhereOrNull((b) => b.id == billingId);
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

        // Revenue Management Routes
        GoRoute(
          path: '/revenue',
          builder: (c, s) => const RevenueScreen(),
          routes: [
            GoRoute(
              path: 'payment',
              builder: (c, s) => const PaymentListScreen(),
            ),
            GoRoute(
              path: 'payment/new',
              builder: (c, s) => const PaymentFormScreen(),
            ),
          ],
        ),

        // Reports Routes
        GoRoute(
          path: '/reports',
          builder: (c, s) => const ReportsScreen(),
        ),

        // Settings Routes
        GoRoute(
          path: '/settings',
          builder: (c, s) => const SettingsScreen(),
          routes: [
            GoRoute(
              path: 'profile',
              builder: (c, s) => const ProfileScreen(),
            ),
            GoRoute(
              path: 'currency',
              builder: (c, s) => const CurrencyScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);