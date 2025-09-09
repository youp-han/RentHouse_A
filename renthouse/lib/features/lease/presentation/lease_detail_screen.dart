import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:renthouse/features/lease/application/lease_controller.dart';
import 'package:renthouse/features/lease/domain/lease.dart';

class LeaseDetailScreen extends ConsumerWidget {
  final String leaseId;

  const LeaseDetailScreen({super.key, required this.leaseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leasesAsync = ref.watch(leaseControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lease Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              context.push('/leases/edit/$leaseId');
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              // Store the context dependent objects before the async gap.
              final router = GoRouter.of(context);
              final messenger = ScaffoldMessenger.of(context);

              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('계약 삭제'),
                  content: const Text('정말로 이 계약을 삭제하시겠습니까?'),
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
                  await ref.read(leaseControllerProvider.notifier).deleteLease(leaseId);
                  ref.invalidate(leaseControllerProvider); // Invalidate the provider to refresh the list
                  messenger.showSnackBar(
                    const SnackBar(content: Text('계약이 삭제되었습니다.')),
                  );
                  router.go('/leases'); // Go back to the list screen
                } catch (e) {
                  messenger.showSnackBar(
                    SnackBar(content: Text('계약 삭제 실패: ${e.toString()}')),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: leasesAsync.when(
        data: (leases) {
          final Lease? lease = leases.firstWhereOrNull((l) => l.id == leaseId);
          if (lease == null) {
            return const Center(child: Text('Lease not found'));
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
                    _buildDetailRow(context, 'Lease Type', lease.leaseType.name),
                    _buildDetailRow(context, 'Status', lease.leaseStatus.name),
                    _buildDetailRow(context, 'Start Date', DateFormat.yMMMd().format(lease.startDate)),
                    _buildDetailRow(context, 'End Date', DateFormat.yMMMd().format(lease.endDate)),
                    _buildDetailRow(context, 'Deposit', NumberFormat.currency(locale: 'ko_KR', symbol: '₩').format(lease.deposit)),
                    _buildDetailRow(context, 'Monthly Rent', NumberFormat.currency(locale: 'ko_KR', symbol: '₩').format(lease.monthlyRent)),
                    _buildDetailRow(context, 'Notes', lease.contractNotes ?? 'N/A'),
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
