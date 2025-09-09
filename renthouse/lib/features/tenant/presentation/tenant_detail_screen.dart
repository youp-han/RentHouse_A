import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:renthouse/features/tenant/application/tenant_controller.dart';
import 'package:renthouse/features/tenant/domain/tenant.dart';
import 'package:collection/collection.dart';

class TenantDetailScreen extends ConsumerWidget {
  final String tenantId;

  const TenantDetailScreen({super.key, required this.tenantId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tenantsAsync = ref.watch(tenantControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tenant Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              context.push('/tenants/edit/$tenantId');
            },
          ),
        ],
      ),
      body: tenantsAsync.when(
        data: (tenants) {
          final Tenant? tenant = tenants.firstWhereOrNull((t) => t.id == tenantId);
          if (tenant == null) {
            return const Center(child: Text('Tenant not found'));
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    _buildDetailRow(context, 'Name', tenant.name),
                    _buildDetailRow(context, 'Phone', tenant.phone),
                    _buildDetailRow(context, 'Email', tenant.email),
                    _buildDetailRow(context, 'Social No.', tenant.socialNo ?? 'N/A'),
                    _buildDetailRow(context, 'Address', tenant.currentAddress ?? 'N/A'),
                  ],
                ),
              ),
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
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
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
