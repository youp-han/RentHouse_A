import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:renthouse/features/lease/application/lease_controller.dart';
import 'package:renthouse/features/tenant/application/tenant_controller.dart';
import 'package:renthouse/features/property/data/property_repository.dart';
import 'package:collection/collection.dart'; // For firstWhereOrNull

class LeaseListScreen extends ConsumerWidget {
  const LeaseListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leasesAsync = ref.watch(leaseControllerProvider);
    final tenantsAsync = ref.watch(tenantControllerProvider);
    final unitsAsync = ref.watch(allUnitsProvider);
    final propertiesAsync = ref.watch(propertyRepositoryProvider).getProperties();

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
                  : FutureBuilder(
                      future: propertiesAsync,
                      builder: (context, propertiesSnapshot) {
                        if (propertiesSnapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        final properties = propertiesSnapshot.data ?? [];

                        return ListView.builder(
                          itemCount: leases.length,
                          itemBuilder: (_, i) {
                            final lease = leases[i];
                            final tenant = tenantsAsync.value?.firstWhereOrNull((t) => t.id == lease.tenantId);

                            // 가상 유닛 ID 처리
                            String? propertyId;
                            String unitNumber;

                            if (lease.unitId.startsWith('virtual-unit-')) {
                              // 가상 유닛 ID에서 propertyId 추출
                              propertyId = lease.unitId.replaceFirst('virtual-unit-', '');
                              unitNumber = '전체'; // 토지/주택의 경우 전체로 표시
                            } else {
                              // 실제 유닛 ID인 경우
                              final unit = unitsAsync.value?.firstWhereOrNull((u) => u.id == lease.unitId);
                              propertyId = unit?.propertyId;
                              unitNumber = unit?.unitNumber ?? '알 수 없는 유닛';
                            }

                            final property = propertyId != null
                                ? properties.firstWhereOrNull((p) => p.id == propertyId)
                                : null;

                            final tenantName = tenant?.name ?? '알 수 없는 임차인';
                            final propertyName = property?.name ?? '알 수 없는 자산';
                            final displayText = '$tenantName: $propertyName - $unitNumber';

                            return ListTile(
                              title: Text(displayText),
                              subtitle: Text('계약 ID: ${lease.id.substring(0, 8)}...'),
                              onTap: () {
                                context.go('/leases/edit/${lease.id}');
                              },
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // The edit button is now redundant if onTap handles navigation
                                  // IconButton(
                                  //   icon: const Icon(Icons.edit, color: Colors.blue),
                                  //   onPressed: () {
                                  //     context.go('/leases/edit/${lease.id}');
                                  //   },
                                  // ),
                                  // The delete button will be moved to the form screen
                                  // IconButton(
                                  //   icon: const Icon(Icons.delete, color: Colors.red),
                                  //   onPressed: () {
                                  //     ref.read(leaseControllerProvider.notifier).deleteLease(lease.id);
                                  //   },
                                  // ),
                                ],
                              ),
                            );
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
