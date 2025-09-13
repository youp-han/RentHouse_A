import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:renthouse/core/utils/currency_formatter.dart';
import 'package:renthouse/features/settings/application/currency_controller.dart';
import 'package:renthouse/features/dashboard/application/dashboard_controller.dart';
import 'package:renthouse/features/activity/application/activity_log_service.dart';
import 'package:renthouse/features/activity/domain/activity_log.dart';
import 'package:intl/intl.dart';

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
    final dashboardStatsAsync = ref.watch(dashboardControllerProvider);

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
            dashboardStatsAsync.when(
              loading: () => GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: isDesktop ? 4 : (isTablet ? 3 : 2),
                childAspectRatio: isDesktop ? 1.5 : (isMobile ? 1.1 : 1.3),
                crossAxisSpacing: isMobile ? 8 : 16,
                mainAxisSpacing: isMobile ? 8 : 16,
                children: [
                  const _KPI(title: '이번 달 청구 합계', value: '로딩 중...', isLoading: true),
                  const _KPI(title: '이번 달 수납 합계', value: '로딩 중...', isLoading: true),
                  const _KPI(title: '이번 달 미납액', value: '로딩 중...', isLoading: true),
                  const _KPI(title: '연체 비중', value: '로딩 중...', isLoading: true),
                  const _KPI(title: '미납 건수', value: '로딩 중...', isLoading: true),
                  const _KPI(title: '활성 계약 수', value: '로딩 중...', isLoading: true),
                ],
              ),
              error: (err, stack) => Container(
                padding: const EdgeInsets.all(16),
                child: Text('데이터 로딩 오류: $err'),
              ),
              data: (stats) => GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: isDesktop ? 4 : (isTablet ? 3 : 2),
                childAspectRatio: isDesktop ? 1.5 : (isMobile ? 1.1 : 1.3),
                crossAxisSpacing: isMobile ? 8 : 16,
                mainAxisSpacing: isMobile ? 8 : 16,
                children: [
                  _KPI(
                    title: '이번 달 청구 합계',
                    value: CurrencyFormatter.format(stats.currentMonthBillingAmount, selectedCurrency),
                    color: Colors.blue,
                  ),
                  _KPI(
                    title: '이번 달 수납 합계',
                    value: CurrencyFormatter.format(stats.currentMonthPaymentAmount, selectedCurrency),
                    color: Colors.green,
                  ),
                  _KPI(
                    title: '이번 달 미납액',
                    value: CurrencyFormatter.format(stats.unpaidAmount, selectedCurrency),
                    color: Colors.orange,
                    subtitle: '${stats.unpaidCount}건',
                  ),
                  _KPI(
                    title: '연체 비중',
                    value: '${stats.overduePercentage}%',
                    color: stats.overduePercentage > 20 ? Colors.red : (stats.overduePercentage > 10 ? Colors.orange : Colors.green),
                    subtitle: CurrencyFormatter.format(stats.overdueAmount, selectedCurrency),
                  ),
                  _KPI(
                    title: '총 미납 건수',
                    value: '${stats.unpaidCount}건',
                    color: Colors.grey,
                    subtitle: '연체: ${stats.overdueCount}건',
                  ),
                  _KPI(
                    title: '활성 계약 수',
                    value: '${stats.activeLeaseCount}개',
                    color: Colors.indigo,
                    subtitle: '업데이트: ${DateFormat('HH:mm').format(stats.lastUpdated)}',
                  ),
                ],
              ),
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
                    _RecentActivitiesWidget(),
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
  final String? subtitle;
  final Color? color;
  final bool isLoading;
  
  const _KPI({
    required this.title, 
    required this.value,
    this.subtitle,
    this.color,
    this.isLoading = false,
  });
  
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    final effectiveColor = color ?? Theme.of(context).primaryColor;
    
    return Card(
      margin: EdgeInsets.all(isMobile ? 4 : 8),
      elevation: 2,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              effectiveColor.withOpacity(0.1),
              effectiveColor.withOpacity(0.05),
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 8 : 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title, 
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontSize: isMobile ? 11 : 13,
                  color: effectiveColor.withOpacity(0.8),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              if (isLoading)
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(effectiveColor),
                  ),
                )
              else
                FittedBox(
                  child: Text(
                    value, 
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: isMobile ? 16 : 20,
                      fontWeight: FontWeight.bold,
                      color: effectiveColor,
                    ),
                  ),
                ),
              if (subtitle != null && !isLoading) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: isMobile ? 10 : 11,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
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



class _RecentActivitiesWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activityLogService = ref.watch(activityLogServiceProvider);
    
    return FutureBuilder<List<ActivityLog>>(
      future: activityLogService.getRecentActivityLogs(limit: 10),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: 200,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          );
        }
        
        if (snapshot.hasError) {
          return Container(
            height: 200,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.grey),
                const SizedBox(height: 8),
                Text('활동 로그를 불러올 수 없습니다', 
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey)),
              ],
            ),
          );
        }
        
        final activities = snapshot.data ?? [];
        
        if (activities.isEmpty) {
          return Container(
            height: 200,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.history, size: 48, color: Colors.grey),
                const SizedBox(height: 8),
                Text('최근 활동이 없습니다', 
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey)),
                const SizedBox(height: 4),
                Text('자산, 임차인, 청구서 등을 등록하면 활동 내역이 표시됩니다', 
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
              ],
            ),
          );
        }
        
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: activities.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final activity = activities[index];
            return ListTile(
              dense: true,
              leading: CircleAvatar(
                backgroundColor: Colors.blue,
                radius: 16,
                child: Icon(
                  Icons.info_outline,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              title: Text(
                activity.description,
                style: const TextStyle(fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                DateFormat('MM/dd HH:mm').format(activity.timestamp),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            );
          },
        );
      },
    );
  }
}
