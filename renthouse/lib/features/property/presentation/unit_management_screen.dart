import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:renthouse/features/property/data/property_repository.dart';

class UnitManagementScreen extends ConsumerWidget {
  final String propertyId;
  const UnitManagementScreen({super.key, required this.propertyId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final propertyAsync = ref.watch(propertyDetailProvider(propertyId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('유닛 관리'),
      ),
      body: propertyAsync.when(
        data: (property) {
          if (property == null) {
            return const Center(child: Text('자산을 찾을 수 없습니다.'));
          }

          final registeredCount = property.units.length;
          final totalCount = property.totalUnits;
          final canAddMore = registeredCount < totalCount;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text('${property.name}', style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: totalCount > 0 ? registeredCount / totalCount : 0,
                      minHeight: 10,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    const SizedBox(height: 8),
                    Text('$registeredCount / $totalCount 유닛 등록됨', style: Theme.of(context).textTheme.titleMedium),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: property.units.length,
                  itemBuilder: (context, index) {
                    final unit = property.units[index];
                    return ListTile(
                      title: Text(unit.unitNumber),
                      subtitle: Text('${unit.useType} / ${unit.rentStatus}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          context.push('/property/$propertyId/units/edit/${unit.id}');
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('오류: $err')),
      ),
      floatingActionButton: propertyAsync.when(
        data: (property) {
          if (property == null || property.units.length >= property.totalUnits) {
            return null; // Don't show button if all units are added
          }
          return FloatingActionButton.extended(
            onPressed: () {
              context.push('/property/$propertyId/units/add');
            },
            label: Text('유닛 ${property.units.length + 1} 등록'),
            icon: const Icon(Icons.add),
          );
        },
        loading: () => null,
        error: (err, stack) => null,
      ),
    );
  }
}
