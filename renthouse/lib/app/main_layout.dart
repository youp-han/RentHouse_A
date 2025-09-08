import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainLayout extends StatelessWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouter.of(context).routeInformationProvider.value.uri.toString();
    final selectedIndex = _calculateSelectedIndex(location);
    final isLargeScreen = MediaQuery.of(context).size.width >= 600; // Breakpoint for large screens

    return Scaffold(
      body: Row(
        children: [
          if (isLargeScreen)
            NavigationRail(
              selectedIndex: selectedIndex,
              onDestinationSelected: (index) {
                _onDestinationSelected(context, index);
              },
              labelType: NavigationRailLabelType.all,
              destinations: const <NavigationRailDestination>[
                NavigationRailDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard),
                  label: Text('대시보드'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.business_outlined),
                  selectedIcon: Icon(Icons.business),
                  label: Text('자산'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.people_outline),
                  selectedIcon: Icon(Icons.people),
                  label: Text('임차인'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.article_outlined),
                  selectedIcon: Icon(Icons.article),
                  label: Text('계약'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.receipt_long_outlined),
                  selectedIcon: Icon(Icons.receipt_long),
                  label: Text('청구'),
                ),
              ],
            ),
          if (isLargeScreen) const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: child,
          ),
        ],
      ),
      bottomNavigationBar: !isLargeScreen
          ? BottomNavigationBar(
              currentIndex: selectedIndex,
              onTap: (index) {
                _onDestinationSelected(context, index);
              },
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard_outlined),
                  activeIcon: Icon(Icons.dashboard),
                  label: '대시보드',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.business_outlined),
                  activeIcon: Icon(Icons.business),
                  label: '자산',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.people_outline),
                  activeIcon: Icon(Icons.people),
                  label: '임차인',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.article_outlined),
                  activeIcon: Icon(Icons.article),
                  label: '계약',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.receipt_long_outlined),
                  activeIcon: Icon(Icons.receipt_long),
                  label: '청구',
                ),
              ],
            )
          : null,
    );
  }

  void _onDestinationSelected(BuildContext context, int index) {
    if (index == 0) {
      context.go('/admin/dashboard');
    } else if (index == 1) {
      context.go('/property');
    } else if (index == 2) {
      context.go('/tenants');
    } else if (index == 3) {
      context.go('/leases');
    } else if (index == 4) {
      context.go('/billing');
    }
  }

  int _calculateSelectedIndex(String location) {
    if (location.startsWith('/admin/dashboard')) {
      return 0;
    } else if (location.startsWith('/property')) {
      return 1;
    } else if (location.startsWith('/tenants')) {
      return 2;
    } else if (location.startsWith('/leases')) {
      return 3;
    } else if (location.startsWith('/billing')) {
      return 4;
    }
    return 0;
  }
}
