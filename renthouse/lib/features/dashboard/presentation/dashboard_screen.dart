import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:renthouse/core/utils/currency_formatter.dart';
import 'package:renthouse/features/settings/application/currency_controller.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final isDesktop = screenWidth >= 1024;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;
    final isMobile = screenWidth < 768;
    final selectedCurrency = ref.watch(currencySettingProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('대시보드'),
        actions: [
          if (!isMobile) // 모바일에서는 검색창 숨김
            SizedBox(
              width: isDesktop ? 300 : 200,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: '임차인/계약/유닛 검색',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
            ),
          if (isMobile) // 모바일에서는 검색 아이콘만 표시
            IconButton(
              onPressed: () {
                // TODO: 검색 모달/페이지 열기
              },
              icon: const Icon(Icons.search),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // KPI Cards
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: isDesktop ? 4 : (isTablet ? 3 : 2),
              childAspectRatio: isDesktop ? 1.5 : (isMobile ? 1.1 : 1.3),
              crossAxisSpacing: isMobile ? 8 : 16,
              mainAxisSpacing: isMobile ? 8 : 16,
              children: [
                _KPI(title: '이번 달 청구 합계', value: CurrencyFormatter.format(0, selectedCurrency)),
                _KPI(title: '이번 달 수납 합계', value: CurrencyFormatter.format(0, selectedCurrency)),
                const _KPI(title: '미납 건수', value: '0'),
                const _KPI(title: '활성 계약 수', value: '0'),
              ],
            ),
            const SizedBox(height: 24.0),

            // Recent Activities
            Text(
              '최근 활동',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16.0),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TODO: 실제 활동 로그 테이블 구현
                    Container(
                      height: 200, // 임시 높이
                      alignment: Alignment.center,
                      child: const Text('최근 활동 로그 테이블 (구현 예정)'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24.0),

            // Quick Actions
            Text(
              '빠른 작업',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16.0),
            if (isMobile)
              // 모바일에서는 버튼을 세로로 배치
              Column(
                children: [
                  _QuickActionButton(
                    icon: Icons.business,
                    label: '자산 관리',
                    onPressed: () => context.go('/property'),
                  ),
                  const SizedBox(height: 12),
                  _QuickActionButton(
                    icon: Icons.add_box,
                    label: '신규 계약',
                    onPressed: () => context.go('/leases/new'),
                  ),
                  const SizedBox(height: 12),
                  _QuickActionButton(
                    icon: Icons.receipt_long,
                    label: '월 청구 생성',
                    onPressed: () => context.go('/billing/new'),
                  ),
                  const SizedBox(height: 12),
                  _QuickActionButton(
                    icon: Icons.picture_as_pdf,
                    label: '보고서 다운로드',
                    onPressed: () {},
                  ),
                ],
              )
            else
              // 태블릿/데스크톱에서는 Wrap으로 배치
              Wrap(
                spacing: 16.0,
                runSpacing: 16.0,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      context.go('/property');
                    },
                    icon: const Icon(Icons.business),
                    label: const Text('자산 관리'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.go('/leases/new');
                    },
                    icon: const Icon(Icons.add_box),
                    label: const Text('신규 계약'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.go('/billing/new');
                    },
                    icon: const Icon(Icons.receipt_long),
                    label: const Text('월 청구 생성'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text('보고서 다운로드'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _KPI extends StatelessWidget {
  final String title; 
  final String value;
  const _KPI({required this.title, required this.value});
  
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    
    return Card(
      margin: EdgeInsets.all(isMobile ? 4 : 8),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 8 : 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title, 
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontSize: isMobile ? 12 : 14,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            FittedBox(
              child: Text(
                value, 
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: isMobile ? 16 : 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  
  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }
}

