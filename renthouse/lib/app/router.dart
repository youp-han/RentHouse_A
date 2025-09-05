import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
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
    GoRoute(path: '/', redirect: (_, __) => '/admin/dashboard'),
    GoRoute(path: '/admin/dashboard', builder: (c, s) => const DashboardScreen()),
    GoRoute(path: '/property', builder: (c, s) => const PropertyListScreen()),
    GoRoute(path: '/property/new', builder: (c, s) => const PropertyFormScreen()),
  ],
);
