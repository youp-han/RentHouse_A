import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:renthouse/features/property/application/property_controller.dart';
import 'package:renthouse/features/property/data/property_repository.dart';

class PropertyDetailScreen extends ConsumerWidget {
  final String propertyId;

  const PropertyDetailScreen({Key? key, required this.propertyId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final propertyAsync = ref.watch(propertyDetailProvider(propertyId));

    return propertyAsync.when(
      data: (property) {
        if (property == null) {
          return const Scaffold(body: Center(child: Text('Property not found')));
        }

        final canAddMoreUnits = property.units.length < property.totalUnits;

        return Scaffold(
          appBar: AppBar(
            title: Text(property.name),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // Navigate to edit screen, ensuring it can handle the async property
                  context.go('/property/edit/${property.id}');
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('자산 삭제'),
                      content: const Text('정말로 이 자산을 삭제하시겠습니까?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('취소'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('삭제'),
                        ),
                      ],
                    ),
                  );

                  if (confirmed == true) {
                    try {
                      await ref.read(propertyRepositoryProvider).deleteProperty(property.id);
                      await ref.read(propertyListControllerProvider.notifier).refreshProperties();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('자산이 삭제되었습니다.')),
                      );
                      context.go('/property');
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('자산 삭제 실패: ${e.toString()}')),
                      );
                    }
                  }
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('주소: ${property.address}', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text('유형: ${property.type}', style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 8),
                Text('총 유닛: ${property.totalUnits}개', style: Theme.of(context).textTheme.bodyLarge),
                const Divider(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('유닛 목록 (${property.units.length}개 등록됨)', style: Theme.of(context).textTheme.titleLarge),
                    if (canAddMoreUnits)
                      FilledButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text('유닛 관리'),
                        onPressed: () => context.go('/property/${property.id}/units'),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: property.units.length,
                    itemBuilder: (context, index) {
                      final unit = property.units[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4.0),
                        child: ListTile(
                          title: Text(unit.unitNumber),
                          subtitle: Text('${unit.useType} / ${unit.rentStatus}'),
                          trailing: Text('${unit.sizeKorea}평'),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => Scaffold(body: const Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(body: Center(child: Text('Error: $err'))),
    );
  }
}