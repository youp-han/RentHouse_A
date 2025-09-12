import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:renthouse/features/reports/application/reports_controller.dart';
import 'package:renthouse/core/utils/currency_formatter.dart';
import 'package:renthouse/features/settings/domain/currency.dart';
import 'package:intl/intl.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedYearMonth = DateFormat('yyyy-MM').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('보고서'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '월별 수익', icon: Icon(Icons.trending_up)),
            Tab(text: '연체 현황', icon: Icon(Icons.warning)),
            Tab(text: '점유율', icon: Icon(Icons.home)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMonthlyRevenueTab(),
          _buildOverdueTab(),
          _buildOccupancyTab(),
        ],
      ),
    );
  }

  Widget _buildMonthlyRevenueTab() {
    final monthlyReportAsync = ref.watch(monthlyRevenueReportProvider(_selectedYearMonth));

    return Column(
      children: [
        // 월 선택 헤더
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Text('조회 월: ', style: TextStyle(fontSize: 16)),
              DropdownButton<String>(
                value: _selectedYearMonth,
                items: _generateYearMonthList().map((yearMonth) {
                  return DropdownMenuItem(
                    value: yearMonth,
                    child: Text(yearMonth),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedYearMonth = value;
                    });
                  }
                },
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        // 보고서 내용
        Expanded(
          child: monthlyReportAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('오류: $err')),
            data: (report) => _buildMonthlyRevenueContent(report),
          ),
        ),
      ],
    );
  }

  Widget _buildMonthlyRevenueContent(dynamic report) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 주요 지표 카드들
        Row(
          children: [
            Expanded(child: _buildMetricCard('총 청구액', report.totalBilledAmount, Icons.receipt)),
            const SizedBox(width: 8),
            Expanded(child: _buildMetricCard('총 수납액', report.totalReceivedAmount, Icons.payments)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _buildMetricCard('미납액', report.pendingAmount, Icons.pending_actions)),
            const SizedBox(width: 8),
            Expanded(child: _buildMetricCard('연체액', report.overdueAmount, Icons.warning_amber)),
          ],
        ),
        const SizedBox(height: 16),
        
        // 수납률 표시
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('수납률', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: report.collectionRate / 100,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    report.collectionRate >= 90 ? Colors.green : 
                    report.collectionRate >= 70 ? Colors.orange : Colors.red,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${report.collectionRate.toStringAsFixed(1)}%',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        
        // 전년 대비 증감률 (데이터가 있는 경우만)
        if (report.previousYearBilledAmount != null)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('전년 동월 대비', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _buildGrowthRateRow('청구액', report.calculatedBilledGrowthRate),
                  const SizedBox(height: 8),
                  _buildGrowthRateRow('수납액', report.calculatedReceivedGrowthRate),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildOverdueTab() {
    final overdueReportsAsync = ref.watch(overdueReportsProvider);

    return overdueReportsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('오류: $err')),
      data: (reports) => reports.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, size: 64, color: Colors.green),
                  SizedBox(height: 16),
                  Text('연체된 청구서가 없습니다!', style: TextStyle(fontSize: 18)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: reports.length,
              itemBuilder: (context, index) {
                final report = reports[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ExpansionTile(
                    title: Text(report.tenantName),
                    subtitle: Text('${report.propertyName} - ${report.unitNumber}'),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          CurrencyFormatter.format(report.overdueAmount, Currency.krw),
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                        ),
                        Text('${report.overdueDays}일 연체', style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                    children: report.overdueList.map((billing) {
                      return ListTile(
                        dense: true,
                        title: Text('${billing.yearMonth} 청구서'),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(CurrencyFormatter.format(billing.amount, Currency.krw)),
                            Text('${billing.overdueDays}일', style: const TextStyle(fontSize: 11)),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildOccupancyTab() {
    final occupancyReportsAsync = ref.watch(occupancyReportsProvider);

    return occupancyReportsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('오류: $err')),
      data: (reports) => ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: reports.length,
        itemBuilder: (context, index) {
          final report = reports[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    report.propertyName,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildOccupancyMetric('총 유닛', '${report.totalUnits}개'),
                      ),
                      Expanded(
                        child: _buildOccupancyMetric('임대 중', '${report.occupiedUnits}개'),
                      ),
                      Expanded(
                        child: _buildOccupancyMetric('공실', '${report.vacantUnits}개'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // 점유율 표시
                  Text('점유율', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: report.occupancyRate / 100,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      report.occupancyRate >= 90 ? Colors.green :
                      report.occupancyRate >= 70 ? Colors.orange : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('${report.occupancyRate.toStringAsFixed(1)}%'),
                  const SizedBox(height: 16),
                  // 수익 손실 정보
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('잠재 수익', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(CurrencyFormatter.format(report.potentialMonthlyRevenue, Currency.krw)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('실제 수익', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(CurrencyFormatter.format(report.actualMonthlyRevenue, Currency.krw)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.red[200]!),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.trending_down, color: Colors.red, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '수익 손실: ${CurrencyFormatter.format(report.revenueloss, Currency.krw)}',
                          style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMetricCard(String title, int amount, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: Theme.of(context).primaryColor),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 4),
            Text(
              CurrencyFormatter.format(amount, Currency.krw),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrowthRateRow(String title, double rate) {
    final isPositive = rate > 0;
    return Row(
      children: [
        Expanded(child: Text(title)),
        Icon(
          isPositive ? Icons.trending_up : Icons.trending_down,
          color: isPositive ? Colors.green : Colors.red,
          size: 16,
        ),
        const SizedBox(width: 4),
        Text(
          '${rate >= 0 ? '+' : ''}${rate.toStringAsFixed(1)}%',
          style: TextStyle(
            color: isPositive ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildOccupancyMetric(String title, String value) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  List<String> _generateYearMonthList() {
    final now = DateTime.now();
    final list = <String>[];
    
    // 현재 월부터 과거 12개월까지
    for (int i = 0; i < 12; i++) {
      final date = DateTime(now.year, now.month - i, 1);
      list.add(DateFormat('yyyy-MM').format(date));
    }
    
    return list;
  }
}