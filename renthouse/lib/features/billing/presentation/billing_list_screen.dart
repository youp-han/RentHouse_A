import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:renthouse/features/billing/application/billing_controller.dart';

final _searchQueryProvider = StateProvider<String>((ref) => '');
final _statusFilterProvider = StateProvider<String?>((ref) => null);

class BillingListScreen extends ConsumerStatefulWidget {
  const BillingListScreen({super.key});

  @override
  ConsumerState<BillingListScreen> createState() => _BillingListScreenState();
}

class _BillingListScreenState extends ConsumerState<BillingListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      ref.read(_searchQueryProvider.notifier).state = _searchController.text;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = ref.watch(_searchQueryProvider);
    final statusFilter = ref.watch(_statusFilterProvider);
    final billingsAsync = ref.watch(billingControllerProvider(searchQuery: searchQuery));

    return Scaffold(
      appBar: AppBar(
        title: const Text('청구서 목록'),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.auto_awesome),
            label: const Text('일괄 생성'),
            onPressed: () => _showBulkGenerationDialog(context),
          ),
          TextButton.icon(
            icon: const Icon(Icons.list_alt),
            label: const Text('템플릿 관리'),
            onPressed: () {
              context.go('/billing/templates');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 검색 및 필터 섹션
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: '계약 ID, 연월로 검색',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (value) {
                          ref.read(_searchQueryProvider.notifier).state = value;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    FilledButton(
                      onPressed: () {
                        context.go('/billing/new');
                      },
                      child: const Text('+ 신규 청구'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // 상태 필터 칩들
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('전체', null, statusFilter),
                      const SizedBox(width: 8),
                      _buildFilterChip('미발행', 'DRAFT', statusFilter),
                      const SizedBox(width: 8),
                      _buildFilterChip('발행됨', 'ISSUED', statusFilter),
                      const SizedBox(width: 8),
                      _buildFilterChip('부분납부', 'PARTIALLY_PAID', statusFilter),
                      const SizedBox(width: 8),
                      _buildFilterChip('완납', 'PAID', statusFilter),
                      const SizedBox(width: 8),
                      _buildFilterChip('연체', 'OVERDUE', statusFilter),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: billingsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('오류: $err')),
              data: (billings) {
                // 상태 필터링 적용
                final filteredBillings = statusFilter == null 
                  ? billings 
                  : billings.where((billing) => _getBillingStatus(billing) == statusFilter).toList();
                
                return filteredBillings.isEmpty
                  ? const Center(child: Text('해당하는 청구서가 없습니다.'))
                  : ListView.builder(
                      itemCount: filteredBillings.length,
                      itemBuilder: (_, i) {
                        final billing = filteredBillings[i];
                        final status = _getBillingStatus(billing);
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: _getStatusColor(status),
                              child: Icon(
                                _getStatusIcon(status),
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            title: Row(
                              children: [
                                Text(
                                  '${billing.yearMonth} 청구',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 8),
                                _buildStatusBadge(status),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('계약 ID: ${billing.leaseId}'),
                                Text('납기: ${billing.dueDate.toString().substring(0, 10)}'),
                              ],
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${billing.totalAmount}원',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  '발행: ${billing.issueDate.toString().substring(0, 10)}',
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                            onTap: () {
                              context.go('/billing/edit/${billing.id}');
                            },
                          ),
                        );
                      },
                    );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String? value, String? currentFilter) {
    final isSelected = currentFilter == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        ref.read(_statusFilterProvider.notifier).state = selected ? value : null;
      },
      selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
      checkmarkColor: Theme.of(context).primaryColor,
    );
  }

  Widget _buildStatusBadge(String status) {
    final color = _getStatusColor(status);
    final text = _getStatusText(status);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'DRAFT':
        return Colors.grey;
      case 'ISSUED':
        return Colors.blue;
      case 'PARTIALLY_PAID':
        return Colors.orange;
      case 'PAID':
        return Colors.green;
      case 'OVERDUE':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'DRAFT':
        return Icons.edit_outlined;
      case 'ISSUED':
        return Icons.send_outlined;
      case 'PARTIALLY_PAID':
        return Icons.pie_chart_outline;
      case 'PAID':
        return Icons.check_circle_outline;
      case 'OVERDUE':
        return Icons.warning_outlined;
      default:
        return Icons.help_outline;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'DRAFT':
        return '미발행';
      case 'ISSUED':
        return '발행됨';
      case 'PARTIALLY_PAID':
        return '부분납부';
      case 'PAID':
        return '완납';
      case 'OVERDUE':
        return '연체';
      default:
        return '알 수 없음';
    }
  }

  void _showBulkGenerationDialog(BuildContext context) {
    final now = DateTime.now();
    String selectedYearMonth = '${now.year}-${now.month.toString().padLeft(2, '0')}';
    DateTime issueDate = now;
    DateTime dueDate = DateTime(now.year, now.month + 1, 5); // 다음 달 5일이 기본 납기일

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('청구서 일괄 생성'),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '모든 활성 계약에 대해 선택한 월의 청구서를 생성합니다.\n이미 생성된 청구서가 있는 계약은 제외됩니다.',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                
                // 연월 선택
                TextFormField(
                  initialValue: selectedYearMonth,
                  decoration: const InputDecoration(
                    labelText: '청구 월 (YYYY-MM)',
                    border: OutlineInputBorder(),
                    helperText: '예: 2024-03',
                  ),
                  onChanged: (value) {
                    selectedYearMonth = value;
                  },
                ),
                const SizedBox(height: 16),
                
                // 발행일 선택
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('발행일'),
                  subtitle: Text('${issueDate.year}-${issueDate.month.toString().padLeft(2, '0')}-${issueDate.day.toString().padLeft(2, '0')}'),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: issueDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) {
                      setState(() {
                        issueDate = picked;
                      });
                    }
                  },
                ),
                
                // 납기일 선택
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('납기일'),
                  subtitle: Text('${dueDate.year}-${dueDate.month.toString().padLeft(2, '0')}-${dueDate.day.toString().padLeft(2, '0')}'),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: dueDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) {
                      setState(() {
                        dueDate = picked;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('취소'),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _performBulkGeneration(selectedYearMonth, issueDate, dueDate);
              },
              child: const Text('생성'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _performBulkGeneration(String yearMonth, DateTime issueDate, DateTime dueDate) async {
    try {
      // 로딩 다이얼로그 표시
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text('청구서를 생성하는 중...'),
            ],
          ),
        ),
      );

      // 일괄 생성 실행
      final createdIds = await ref.read(billingControllerProvider(searchQuery: '').notifier)
          .createBulkBillings(yearMonth, issueDate, dueDate);

      if (mounted) {
        Navigator.of(context).pop(); // 로딩 다이얼로그 닫기
        
        // 결과 표시
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${createdIds.length}개의 청구서가 생성되었습니다.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // 로딩 다이얼로그 닫기
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('청구서 생성 실패: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
