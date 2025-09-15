import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:renthouse/features/payment/application/payment_controller.dart';
import 'package:renthouse/features/billing/application/billing_controller.dart';
import 'package:renthouse/core/utils/currency_formatter.dart';
import 'package:renthouse/features/settings/application/currency_controller.dart';
import 'package:intl/intl.dart';

class RevenueScreen extends ConsumerStatefulWidget {
  const RevenueScreen({super.key});

  @override
  ConsumerState<RevenueScreen> createState() => _RevenueScreenState();
}

class _RevenueScreenState extends ConsumerState<RevenueScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _dateFormat = DateFormat('yyyy-MM-dd');
  final _currencyFormat = NumberFormat('#,###');

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
        title: const Text('수익 관리'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '대시보드', icon: Icon(Icons.dashboard)),
            Tab(text: '수납 관리', icon: Icon(Icons.payment)),
            Tab(text: '청구 현황', icon: Icon(Icons.receipt_long)),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => context.go('/revenue/payment/new'),
            icon: const Icon(Icons.add),
            tooltip: '수납 등록',
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDashboardTab(),
          _buildPaymentTab(),
          _buildBillingStatusTab(),
        ],
      ),
    );
  }

  Widget _buildDashboardTab() {
    final now = DateTime.now();
    final statsAsync = ref.watch(monthlyPaymentStatsProvider(now.year, now.month));
    final billingAsync = ref.watch(billingControllerProvider());

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 이번 달 수익 현황
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.trending_up, color: Colors.green[600]),
                      const SizedBox(width: 8),
                      Text(
                        '이번 달 수익 현황 (${now.month}월)',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  statsAsync.when(
                    data: (stats) => _buildRevenueStats(stats),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (err, stack) => Text('오류: $err'),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 청구 현황 요약
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.receipt, color: Colors.blue[600]),
                      const SizedBox(width: 8),
                      Text(
                        '청구 현황 요약',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  billingAsync.when(
                    data: (billings) => _buildBillingStatusSummary(billings),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (err, stack) => Text('오류: $err'),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 빠른 액션 버튼들
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '빠른 작업',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => context.go('/revenue/payment/new'),
                          icon: const Icon(Icons.payment),
                          label: const Text('수납 등록'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => context.go('/billing'),
                          icon: const Icon(Icons.receipt_long),
                          label: const Text('청구서 관리'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _showBulkBillingDialog(),
                          icon: const Icon(Icons.auto_awesome),
                          label: const Text('일괄 청구 생성'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => context.go('/reports'),
                          icon: const Icon(Icons.analytics),
                          label: const Text('수익 보고서'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentTab() {
    final paymentsAsync = ref.watch(paymentControllerProvider);

    return Column(
      children: [
        // 필터 및 검색 바
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: '임차인 이름으로 검색...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {
                  // TODO: 필터 다이얼로그 표시
                },
                icon: const Icon(Icons.filter_list),
                tooltip: '필터',
              ),
            ],
          ),
        ),
        
        // 수납 목록
        Expanded(
          child: paymentsAsync.when(
            data: (payments) {
              if (payments.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.payment, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        '등록된 수납 내역이 없습니다',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: payments.length,
                itemBuilder: (context, index) {
                  final payment = payments[index];
                  return _buildPaymentListItem(payment);
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('오류: $err')),
          ),
        ),
      ],
    );
  }

  Widget _buildBillingStatusTab() {
    final billingAsync = ref.watch(billingControllerProvider());

    return billingAsync.when(
      data: (billings) {
        // 상태별로 그룹화 - 청구서 목록 화면과 동일한 로직 사용
        final statusGroups = <String, List<dynamic>>{};
        for (final billing in billings) {
          final status = _getBillingStatus(billing);
          statusGroups[status] = (statusGroups[status] ?? [])..add(billing);
        }

        return ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildStatusCard('발행됨 (ISSUED)', statusGroups['ISSUED'] ?? [], Colors.blue),
            _buildStatusCard('부분 납부 (PARTIALLY_PAID)', statusGroups['PARTIALLY_PAID'] ?? [], Colors.orange),
            _buildStatusCard('연체 (OVERDUE)', statusGroups['OVERDUE'] ?? [], Colors.red),
            _buildStatusCard('완납 (PAID)', statusGroups['PAID'] ?? [], Colors.green),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('오류: $err')),
    );
  }

  Widget _buildRevenueStats(Map<String, int> stats) {
    final totalAmount = stats['totalAmount'] ?? 0;
    final totalCount = stats['totalCount'] ?? 0;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem('총 수납액', CurrencyFormatter.format(totalAmount, ref.watch(currencyControllerProvider)), Colors.green),
            _buildStatItem('수납 건수', '$totalCount건', Colors.blue),
          ],
        ),
        const SizedBox(height: 16),
        const Divider(),
        const SizedBox(height: 16),
        Text('결제 수단별 현황', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        _buildPaymentMethodStats(stats),
      ],
    );
  }

  Widget _buildPaymentMethodStats(Map<String, int> stats) {
    final methods = ['CASH', 'TRANSFER', 'CARD', 'CHECK', 'OTHER'];
    
    return Column(
      children: methods.map((method) {
        final amount = stats[method] ?? 0;
        final methodName = _getMethodDisplayName(method);
        
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(methodName),
              Text(CurrencyFormatter.format(amount, ref.watch(currencyControllerProvider))),
            ],
          ),
        );
      }).toList(),
    );
  }

  String _getMethodDisplayName(String method) {
    switch (method) {
      case 'CASH': return '현금';
      case 'TRANSFER': return '계좌이체';
      case 'CARD': return '카드';
      case 'CHECK': return '수표';
      case 'OTHER': return '기타';
      default: return method;
    }
  }

  Widget _buildBillingStatusSummary(List<dynamic> billings) {
    final statusCounts = <String, int>{};
    final statusAmounts = <String, int>{};

    for (final billing in billings) {
      final status = _getBillingStatus(billing);  // 일관된 상태 계산 로직 사용
      statusCounts[status] = (statusCounts[status] ?? 0) + 1;
      statusAmounts[status] = (statusAmounts[status] ?? 0) + billing.totalAmount as int;
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem('연체', '${statusCounts['OVERDUE'] ?? 0}건', Colors.red),
            _buildStatItem('미납', '${statusCounts['ISSUED'] ?? 0}건', Colors.blue),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem('부분납', '${statusCounts['PARTIALLY_PAID'] ?? 0}건', Colors.orange),
            _buildStatItem('완납', '${statusCounts['PAID'] ?? 0}건', Colors.green),
          ],
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildPaymentListItem(dynamic payment) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green[100],
          child: Icon(Icons.payment, color: Colors.green[700]),
        ),
        title: Text(CurrencyFormatter.format(payment.amount, ref.watch(currencyControllerProvider))),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('결제일: ${_dateFormat.format(payment.paidDate)}'),
            Text('결제수단: ${_getMethodDisplayName(payment.method.toString().split('.').last.toUpperCase())}'),
            if (payment.memo?.isNotEmpty == true)
              Text('메모: ${payment.memo}'),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'details',
              child: ListTile(
                leading: Icon(Icons.info),
                title: Text('상세 보기'),
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: ListTile(
                leading: Icon(Icons.delete),
                title: Text('삭제'),
              ),
            ),
          ],
          onSelected: (value) async {
            if (value == 'delete') {
              final confirmed = await _showDeleteConfirmDialog();
              if (confirmed) {
                await ref.read(paymentControllerProvider.notifier)
                  .deletePayment(payment.id);
              }
            }
          },
        ),
        isThreeLine: true,
      ),
    );
  }

  Widget _buildStatusCard(String title, List<dynamic> billings, Color color) {
    final totalAmount = billings.fold<int>(0, (sum, billing) => sum + billing.totalAmount as int);
    
    return Card(
      child: ExpansionTile(
        leading: Icon(Icons.circle, color: color, size: 12),
        title: Text(title),
        subtitle: Text('${billings.length}건 · ${CurrencyFormatter.format(totalAmount, ref.watch(currencyControllerProvider))}'),
        children: billings.map<Widget>((billing) {
          return ListTile(
            title: Text('${billing.yearMonth} 청구서'),
            subtitle: Text(CurrencyFormatter.format(billing.totalAmount, ref.watch(currencyControllerProvider))),
            trailing: Text(_dateFormat.format(billing.dueDate)),
          );
        }).toList(),
      ),
    );
  }

  Future<bool> _showDeleteConfirmDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('수납 삭제'),
        content: const Text('정말로 이 수납 내역을 삭제하시겠습니까?\n연결된 배분 내역도 함께 삭제됩니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('삭제'),
          ),
        ],
      ),
    ) ?? false;
  }

  String _getBillingStatus(billing) {
    // 실제 청구서 객체에서 status 필드가 있다고 가정
    // 만약 없다면 paid, paidDate 등으로 상태를 추론
    if (billing.paid) {
      return 'PAID';
    } else if (billing.dueDate.isBefore(DateTime.now())) {
      return 'OVERDUE';
    } else {
      return 'ISSUED';
    }
  }

  void _showBulkBillingDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('일괄 청구 생성'),
        content: const Text('이번 달 청구서를 일괄 생성하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: 일괄 청구 생성 로직 구현
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('일괄 청구 생성 기능이 구현 예정입니다'),
                ),
              );
            },
            child: const Text('생성'),
          ),
        ],
      ),
    );
  }
}