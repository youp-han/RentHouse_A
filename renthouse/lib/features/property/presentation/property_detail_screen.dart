import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:renthouse/features/property/application/property_controller.dart';
import 'package:renthouse/features/property/domain/property.dart';

class PropertyDetailScreen extends ConsumerWidget {
  final Property property;

  const PropertyDetailScreen({Key? key, required this.property}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(property.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              context.go('/property/edit/\${property.id}');
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
            Text('Address: \${property.address}', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Type: \${property.type}', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('Rent: \${property.rent}', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            Text('Units:', style: Theme.of(context).textTheme.titleLarge),
            Expanded(
              child: ListView.builder(
                itemCount: property.units.length,
                itemBuilder: (context, index) {
                  final unit = property.units[index];
                  return ListTile(
                    title: Text(unit.unitNumber),
                    subtitle: Text('Status: \${unit.rentStatus}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}