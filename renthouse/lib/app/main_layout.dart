import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainLayout extends StatelessWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouter.of(context).routeInformationProvider.value.uri.toString();
    final selectedIndex = _calculateSelectedIndex(location);
    final mediaQuery = MediaQuery.of(context);
    
    // 더 정교한 반응형 로직
    final screenWidth = mediaQuery.size.width;
    final orientation = mediaQuery.orientation;
    
    // 데스크톱 모드: 가로 ≥ 1024px
    final isDesktop = screenWidth >= 1024;
    
    // 태블릿 가로 모드: 가로 768px~1023px이면서 가로 방향
    final isTabletLandscape = screenWidth >= 768 && screenWidth < 1024 && orientation == Orientation.landscape;
    
    // 사이드 네비게이션 사용 조건
    final useSideNavigation = isDesktop || isTabletLandscape;
    
    // 모바일/세로/좁은 화면: 하단 네비게이션 사용
    final useBottomNavigation = !useSideNavigation;

    return Scaffold(
      body: Row(
        children: [
          if (useSideNavigation)
            NavigationRail(
              selectedIndex: selectedIndex,
              onDestinationSelected: (index) {
                _onDestinationSelected(context, index);
              },
              labelType: isDesktop 
                ? NavigationRailLabelType.all 
                : NavigationRailLabelType.selected,
              minWidth: isDesktop ? 80 : 60,
              groupAlignment: isDesktop ? -0.5 : -1.0,
              leading: isDesktop 
                ? const SizedBox(height: 8) 
                : null,
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
                NavigationRailDestination(
                  icon: Icon(Icons.trending_up_outlined),
                  selectedIcon: Icon(Icons.trending_up),
                  label: Text('수익관리'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.settings_outlined),
                  selectedIcon: Icon(Icons.settings),
                  label: Text('설정'),
                ),
              ],
            ),
          if (useSideNavigation) const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: child,
          ),
        ],
      ),
      bottomNavigationBar: useBottomNavigation
          ? BottomNavigationBar(
              currentIndex: selectedIndex,
              onTap: (index) {
                _onDestinationSelected(context, index);
              },
              type: BottomNavigationBarType.fixed,
              selectedFontSize: 11,
              unselectedFontSize: 10,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard_outlined),
                  activeIcon: Icon(Icons.dashboard),
                  label: '홈',
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
                BottomNavigationBarItem(
                  icon: Icon(Icons.trending_up_outlined),
                  activeIcon: Icon(Icons.trending_up),
                  label: '수익',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings_outlined),
                  activeIcon: Icon(Icons.settings),
                  label: '설정',
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
    } else if (index == 5) {
      context.go('/revenue');
    } else if (index == 6) {
      context.go('/settings');
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
    } else if (location.startsWith('/revenue')) {
      return 5;
    } else if (location.startsWith('/settings')) {
      return 6;
    }
    return 0;
  }
}
