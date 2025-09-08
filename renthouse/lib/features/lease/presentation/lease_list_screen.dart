import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:renthouse/features/lease/application/lease_controller.dart';

class LeaseListScreen extends ConsumerWidget {
  const LeaseListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leasesAsync = ref.watch(leaseControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('임대 계약 목록')),
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
                    context.go('/leases/new');
                  },
                  child: const Text('+ 신규 계약'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: leasesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('오류: $err')),
              data: (leases) => leases.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.article_outlined, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            '아직 등록된 계약이 없습니다.',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: leases.length,
                      itemBuilder: (_, i) {
                        final lease = leases[i];
                        return ListTile(
                          title: Text('계약 ID: \${lease.id}'),
                          subtitle: Text('임차인 ID: \${lease.tenantId} / 유닛 ID: \${lease.unitId}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  context.go('/leases/edit/\${lease.id}');
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  ref.read(leaseControllerProvider.notifier).deleteLease(lease.id);
                                },
                              ),
                            ],
                          ),
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
