import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:renthouse/features/billing/application/billing_controller.dart';

class BillingListScreen extends ConsumerWidget {
  const BillingListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final billingsAsync = ref.watch(billingControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('청구서 목록'),
        actions: [
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
                const Expanded(child: TextField(decoration: InputDecoration(hintText: '검색'))),
                const SizedBox(width: 12),
                ElevatedButton(onPressed: null, child: const Text('필터적용')),
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
}
