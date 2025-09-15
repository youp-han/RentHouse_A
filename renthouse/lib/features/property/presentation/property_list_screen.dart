import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:renthouse/features/property/application/property_controller.dart';
import 'package:renthouse/core/performance/memory_manager.dart';

class PropertyListScreen extends ConsumerWidget with ListPerformanceMixin {
  const PropertyListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final propertyListAsync = ref.watch(propertyListControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('자산 목록')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(child: TextField(decoration: const InputDecoration(hintText: '검색'))),
                const SizedBox(width: 12),
                ElevatedButton(onPressed: null, child: const Text('필터적용')),
                const Spacer(),
                FilledButton(
                  onPressed: () {
                    context.go('/property/new');
                  },
                  child: const Text('+ 신규 등록'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: propertyListAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('오류: $error')),
              data: (properties) => properties.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.business_outlined, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            '아직 등록된 자산이 없습니다.',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '새로운 자산을 등록하여 시작해보세요!',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : buildOptimizedListView(
                      itemCount: properties.length,
                      itemBuilder: (_, i) {
                        final property = properties[i];
                        return RepaintBoundary(
                          child: InkWell(
                            onTap: () {
                              context.go('/property/${property.id}');
                            },
                            child: ListTile(
                              title: Text(property.name),
                              subtitle: Text(property.fullAddress),
                            ),
                          ),
                        );
                      },
                      physics: ScrollOptimizer.optimizedPhysics,
                    ),
            ),
          )
        ],
      ),
    );
  }
}
