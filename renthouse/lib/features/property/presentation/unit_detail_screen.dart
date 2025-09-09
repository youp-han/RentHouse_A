import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:renthouse/features/property/data/property_repository.dart';

class UnitDetailScreen extends ConsumerWidget {
  final String propertyId;
  final String unitId;

  const UnitDetailScreen(
      {super.key, required this.propertyId, required this.unitId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unitAsync = ref.watch(unitDetailProvider(unitId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Unit Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              context.push('/property/$propertyId/units/edit/$unitId');
            },
          ),
        ],
      ),
      body: unitAsync.when(
        data: (unit) {
          if (unit == null) {
            return const Center(child: Text('Unit not found'));
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Unit ${unit.unitNumber}',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 16),
                        _buildDetailRow(context, 'Status', unit.rentStatus),
                        _buildDetailRow(context, 'Use Type', unit.useType),
                        _buildDetailRow(
                            context, 'Size (m²)', unit.sizeMeter.toString()),
                        _buildDetailRow(context, 'Size (Pyeong)',
                            unit.sizeKorea.toString()),
                        _buildDetailRow(
                            context, 'Description', unit.description ?? 'N/A'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}
