import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1024;

    return Scaffold(
      appBar: AppBar(
        title: const Text('대시보드'),
        actions: [
          SizedBox(
            width: isDesktop ? 300 : 150, // 데스크톱에서 검색창 너비 조절
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
              crossAxisCount: isDesktop ? 4 : 2,
              childAspectRatio: isDesktop ? 1.5 : 1.2, // 데스크톱에서 카드 비율 조정
              children: const [
                _KPI(title: '이번 달 청구 합계', value: '₩0'),
                _KPI(title: '이번 달 수납 합계', value: '₩0'),
                _KPI(title: '미납 건수', value: '0'),
                _KPI(title: '활성 계약 수', value: '0'),
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
  final String title; final String value;
  const _KPI({required this.title, required this.value});
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(value, style: Theme.of(context).textTheme.headlineSmall),
          ],
        ),
      ),
    );
  }
}

