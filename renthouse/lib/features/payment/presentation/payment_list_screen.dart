import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:renthouse/features/payment/application/payment_controller.dart';
import 'package:renthouse/features/payment/domain/payment.dart';
import 'package:renthouse/features/payment/data/payment_repository.dart';
import 'package:renthouse/features/payment/domain/receipt.dart';
import 'package:renthouse/features/payment/services/receipt_service.dart';
import 'package:renthouse/features/payment/services/receipt_pdf_service.dart';
import 'package:renthouse/core/utils/currency_formatter.dart';
import 'package:renthouse/features/settings/application/currency_controller.dart';
import 'package:intl/intl.dart';

class PaymentListScreen extends ConsumerStatefulWidget {
  const PaymentListScreen({super.key});

  @override
  ConsumerState<PaymentListScreen> createState() => _PaymentListScreenState();
}

class _PaymentListScreenState extends ConsumerState<PaymentListScreen> {
  final _dateFormat = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    final paymentsAsync = ref.watch(paymentControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('수납 내역'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: () => context.go('/payment/new'),
            icon: const Icon(Icons.add),
            tooltip: '새 수납 등록',
          ),
        ],
      ),
      body: paymentsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('오류가 발생했습니다: $err'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(paymentControllerProvider),
                child: const Text('새로고침'),
              ),
            ],
          ),
        ),
        data: (payments) => payments.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.payment_outlined, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      '수납 내역이 없습니다',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '첫 번째 수납을 등록해보세요',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              )
            : RefreshIndicator(
                onRefresh: () async {
                  ref.refresh(paymentControllerProvider);
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: payments.length,
                  itemBuilder: (context, index) {
                    final payment = payments[index];
                    return _buildPaymentCard(payment);
                  },
                ),
              ),
      ),
    );
  }

  Widget _buildPaymentCard(Payment payment) {
    final currencySetting = ref.watch(currencyControllerProvider);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: _getMethodColor(payment.method),
              child: Icon(
                _getMethodIcon(payment.method),
                color: Colors.white,
                size: 20,
              ),
            ),
            title: Text(
              CurrencyFormatter.format(payment.amount, currencySetting),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('결제방법: ${_getMethodDisplayName(payment.method)}'),
                Text('수납일: ${_dateFormat.format(payment.paidDate)}'),
                if (payment.memo != null && payment.memo!.isNotEmpty)
                  Text(
                    '메모: ${payment.memo}',
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
              ],
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (value) => _handleMenuAction(value, payment),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'receipt',
                  child: ListTile(
                    leading: Icon(Icons.receipt_long),
                    title: Text('영수증 발행'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuItem(
                  value: 'details',
                  child: ListTile(
                    leading: Icon(Icons.info_outline),
                    title: Text('상세 보기'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: ListTile(
                    leading: Icon(Icons.delete_outline, color: Colors.red),
                    title: Text('삭제', style: TextStyle(color: Colors.red)),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
          // 배분 정보 미리보기
          FutureBuilder(
            future: ref.read(paymentRepositoryProvider).getPaymentAllocations(payment.id),
            builder: (context, snapshot) {
              if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
                return const SizedBox.shrink();
              }
              
              final allocations = snapshot.data as List;
              return Container(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(),
                    const Text(
                      '배분 내역:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    ...allocations.take(3).map((allocation) => Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '청구서: ${allocation.billingId.substring(0, 8)}...',
                              style: const TextStyle(fontSize: 11, color: Colors.grey),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            CurrencyFormatter.format(allocation.amount, currencySetting),
                            style: const TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                        ],
                      ),
                    )),
                    if (allocations.length > 3)
                      Text(
                        '... 외 ${allocations.length - 3}건',
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Color _getMethodColor(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cash:
        return Colors.green;
      case PaymentMethod.transfer:
        return Colors.blue;
      case PaymentMethod.card:
        return Colors.purple;
      case PaymentMethod.check:
        return Colors.orange;
      case PaymentMethod.other:
        return Colors.grey;
    }
  }

  IconData _getMethodIcon(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cash:
        return Icons.money;
      case PaymentMethod.transfer:
        return Icons.account_balance;
      case PaymentMethod.card:
        return Icons.credit_card;
      case PaymentMethod.check:
        return Icons.receipt;
      case PaymentMethod.other:
        return Icons.payment;
    }
  }

  String _getMethodDisplayName(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cash:
        return '현금';
      case PaymentMethod.transfer:
        return '계좌이체';
      case PaymentMethod.card:
        return '카드';
      case PaymentMethod.check:
        return '수표';
      case PaymentMethod.other:
        return '기타';
    }
  }

  Future<void> _handleMenuAction(String action, Payment payment) async {
    switch (action) {
      case 'receipt':
        await _generateReceipt(payment);
        break;
      case 'details':
        _showPaymentDetails(payment);
        break;
      case 'delete':
        await _deletePayment(payment);
        break;
    }
  }

  Future<void> _generateReceipt(Payment payment) async {
    try {
      // 로딩 다이얼로그 표시
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text('영수증을 생성하는 중...'),
            ],
          ),
        ),
      );

      // 영수증 데이터 생성
      final receiptService = ref.read(receiptServiceProvider);
      final receipt = await receiptService.createReceiptFromPayment(payment.id);

      // PDF 생성
      final pdfBytes = await ReceiptPdfService.generateReceiptPdf(receipt);

      if (mounted) {
        Navigator.of(context).pop(); // 로딩 다이얼로그 닫기

        // 미리보기/인쇄 다이얼로그 표시
        await ReceiptPdfService.showPrintPreview(pdfBytes);
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // 로딩 다이얼로그 닫기

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('영수증 생성 실패: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showPaymentDetails(Payment payment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('수납 상세 정보'),
        content: SizedBox(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('결제 ID', payment.id.substring(0, 8).toUpperCase()),
              _buildDetailRow('금액', CurrencyFormatter.format(payment.amount, ref.watch(currencyControllerProvider))),
              _buildDetailRow('결제방법', _getMethodDisplayName(payment.method)),
              _buildDetailRow('수납일', _dateFormat.format(payment.paidDate)),
              _buildDetailRow('등록일', _dateFormat.format(payment.createdAt)),
              if (payment.memo != null && payment.memo!.isNotEmpty)
                _buildDetailRow('메모', payment.memo!),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('닫기'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              _generateReceipt(payment);
            },
            icon: const Icon(Icons.receipt_long),
            label: const Text('영수증 발행'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Future<void> _deletePayment(Payment payment) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('수납 삭제'),
        content: const Text(
          '이 수납 내역을 삭제하시겠습니까?\n\n'
          '삭제하면 관련된 청구서 배분 정보도 함께 삭제되며, '
          '청구서의 납부 상태가 다시 계산됩니다.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('삭제'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ref.read(paymentControllerProvider.notifier).deletePayment(payment.id);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('수납 내역이 삭제되었습니다.'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('삭제 실패: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}