import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:renthouse/features/tenant/application/tenant_controller.dart';

class TenantListScreen extends ConsumerWidget {
  const TenantListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tenantsAsync = ref.watch(tenantControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('임차인 목록')),
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
                    context.push('/tenants/new');
                  },
                  child: const Text('+ 신규 등록'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: tenantsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('오류: $err')),
              data: (tenants) => tenants.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.people_outline, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            '아직 등록된 임차인이 없습니다.',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '새로운 임차인을 등록하여 시작해보세요!',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: tenants.length,
                      itemBuilder: (_, i) {
                        final tenant = tenants[i];
                        return ListTile(
                          title: Text(tenant.name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(tenant.phone),
                              if (tenant.bday != null || tenant.socialNo != null)
                                Text(
                                  '주민번호: ${tenant.maskedSocialNo}',
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                            ],
                          ),
                          onTap: () {
                            context.go('/tenants/edit/${tenant.id}');
                          },
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // The edit button is now redundant if onTap handles navigation
                              // IconButton(
                              //   icon: const Icon(Icons.edit, color: Colors.blue),
                              //   onPressed: () {
                              //     context.go('/tenants/edit/${tenant.id}');
                              //   },
                              // ),
                              
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
