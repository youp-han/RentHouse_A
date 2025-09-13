import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:renthouse/features/billing/application/billing_controller.dart';

final _searchQueryProvider = StateProvider<String>((ref) => '');

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
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(hintText: '검색'),
                    onSubmitted: (value) {
                      // Optional: Trigger search on submit if not using onChanged
                      // ref.read(_searchQueryProvider.notifier).state = value;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    // Trigger search explicitly if needed, otherwise onChanged handles it
                    ref.read(_searchQueryProvider.notifier).state = _searchController.text;
                  },
                  child: const Text('필터적용'),
                ),
                const Spacer(),
                FilledButton(
                  onPressed: () {
                    context.go('/billing/new');
                  },
                  child: const Text('+ 신규 청구'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: billingsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('오류: $err')),
              data: (billings) => billings.isEmpty
                  ? const Center(child: Text('생성된 청구서가 없습니다.'))
                  : ListView.builder(
                      itemCount: billings.length,
                      itemBuilder: (_, i) {
                        final billing = billings[i];
                        return ListTile(
                          title: Text('${billing.yearMonth} 청구'),
                          subtitle: Text('계약 ID: ${billing.leaseId}'),
                          trailing: Text('${billing.totalAmount}원 (${billing.paid ? '완납' : '미납'})'),
                          onTap: () {
                            context.go('/billing/edit/${billing.id}');
                          },
                        );
                      },
                    ),
            ),
          )
        ],
      ),
    );
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
