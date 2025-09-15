import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:go_router/go_router.dart';
import 'package:renthouse/features/payment/application/payment_controller.dart';
import 'package:renthouse/features/payment/domain/payment.dart';
import 'package:renthouse/features/billing/application/billing_controller.dart';
import 'package:renthouse/features/billing/domain/billing.dart';
import 'package:renthouse/core/utils/currency_formatter.dart';
import 'package:renthouse/features/lease/data/lease_repository.dart';
import 'package:renthouse/features/tenant/data/tenant_repository.dart';
import 'package:renthouse/features/property/data/property_repository.dart';
import 'package:intl/intl.dart';

part 'payment_form_screen.g.dart';

class PaymentFormScreen extends ConsumerStatefulWidget {
  const PaymentFormScreen({super.key});

  @override
  ConsumerState<PaymentFormScreen> createState() => _PaymentFormScreenState();
}

class _PaymentFormScreenState extends ConsumerState<PaymentFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // 선택된 청구서 정보
  Billing? _selectedBilling;

  // 수납 정보
  PaymentMethod _selectedMethod = PaymentMethod.transfer;
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  final _memoController = TextEditingController();

  // 부분 수납 지원
  bool _isPartialPayment = false;

  final _dateFormat = DateFormat('yyyy-MM-dd');
  final _currencyFormat = NumberFormat('#,###');

  @override
  void dispose() {
    _amountController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  void _onBillingSelected(Billing billing) {
    setState(() {
      _selectedBilling = billing;
      // 미수금 금액으로 자동 설정
      final remainingAmount = billing.totalAmount - _getPaidAmount(billing);
      _amountController.text = remainingAmount.toString();
      _isPartialPayment = false;
    });
  }

  // 이미 수납된 금액 계산 (실제 구현 시 PaymentAllocation을 통해 계산)
  int _getPaidAmount(Billing billing) {
    // TODO: 실제 수납 내역을 조회해서 계산해야 함
    return billing.paid ? billing.totalAmount : 0;
  }

  String _getBillingDisplayText(Billing billing) {
    // "임차인명 - 자산명:유닛번호 (2024.01) - 미수금: 500,000원"
    return ref.watch(billingDisplayProvider(billing)).when(
      loading: () => '로딩 중...',
      error: (_, __) => '오류',
      data: (displayText) => displayText,
    );
  }

  Future<void> _submitPayment() async {
    if (!_formKey.currentState!.validate() || _selectedBilling == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('필수 입력 사항을 확인해주세요.')),
      );
      return;
    }

    final amount = int.tryParse(_amountController.text.replaceAll(',', ''));
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('올바른 금액을 입력해주세요.')),
      );
      return;
    }

    final remainingAmount = _selectedBilling!.totalAmount - _getPaidAmount(_selectedBilling!);
    if (amount > remainingAmount) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('수납 가능 금액을 초과했습니다. (최대: ${_currencyFormat.format(remainingAmount)}원)')),
      );
      return;
    }

    try {
      // 수납 등록 - 청구서 기준으로 자동 배분
      final request = CreatePaymentRequest(
        tenantId: _selectedBilling!.leaseId, // 임시로 leaseId 사용 (실제로는 tenantId 필요)
        method: _selectedMethod,
        amount: amount,
        paidDate: _selectedDate,
        memo: _memoController.text.isEmpty ? null : _memoController.text,
        manualAllocations: [
          PaymentAllocationRequest(
            billingId: _selectedBilling!.id,
            amount: amount,
          ),
        ],
      );

      await ref.read(paymentControllerProvider.notifier).createPayment(request);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('수납이 등록되었습니다.')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('수납 등록 실패: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final billingsAsync = ref.watch(billingControllerProvider());

    return Scaffold(
      appBar: AppBar(
        title: const Text('수납 등록'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 청구서 선택 섹션
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.receipt_long, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            '청구서 선택',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      billingsAsync.when(
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (err, stack) => Text('오류: $err'),
                        data: (billings) {
                          // 미수금이 있는 청구서만 표시
                          final unpaidBillings = billings.where((billing) {
                            final paidAmount = _getPaidAmount(billing);
                            return billing.totalAmount > paidAmount;
                          }).toList();

                          if (unpaidBillings.isEmpty) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Text(
                                  '미수금이 있는 청구서가 없습니다.',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            );
                          }

                          return DropdownButtonFormField<Billing>(
                            value: _selectedBilling,
                            decoration: const InputDecoration(
                              labelText: '청구서를 선택하세요',
                              border: OutlineInputBorder(),
                            ),
                            items: unpaidBillings.map((billing) {
                              final remainingAmount = billing.totalAmount - _getPaidAmount(billing);
                              return DropdownMenuItem(
                                value: billing,
                                child: Text(
                                  '${_getBillingDisplayText(billing)} - 미수금: ${_currencyFormat.format(remainingAmount)}원',
                                  style: const TextStyle(fontSize: 14),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              );
                            }).toList(),
                            onChanged: (billing) {
                              if (billing != null) {
                                _onBillingSelected(billing);
                              }
                            },
                            validator: (value) {
                              if (value == null) {
                                return '청구서를 선택해주세요.';
                              }
                              return null;
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 수납 정보 섹션
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.payment, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            '수납 정보',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // 수납 금액
                      TextFormField(
                        controller: _amountController,
                        decoration: const InputDecoration(
                          labelText: '수납 금액',
                          suffixText: '원',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '수납 금액을 입력해주세요.';
                          }
                          final amount = int.tryParse(value.replaceAll(',', ''));
                          if (amount == null || amount <= 0) {
                            return '올바른 금액을 입력해주세요.';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // 수납 방법
                      DropdownButtonFormField<PaymentMethod>(
                        value: _selectedMethod,
                        decoration: const InputDecoration(
                          labelText: '수납 방법',
                          border: OutlineInputBorder(),
                        ),
                        items: PaymentMethod.values.map((method) {
                          return DropdownMenuItem(
                            value: method,
                            child: Text(_getPaymentMethodName(method)),
                          );
                        }).toList(),
                        onChanged: (method) {
                          if (method != null) {
                            setState(() {
                              _selectedMethod = method;
                            });
                          }
                        },
                      ),

                      const SizedBox(height: 16),

                      // 수납 일자
                      InkWell(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                          );
                          if (date != null) {
                            setState(() {
                              _selectedDate = date;
                            });
                          }
                        },
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: '수납 일자',
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          child: Text(_dateFormat.format(_selectedDate)),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // 메모
                      TextFormField(
                        controller: _memoController,
                        decoration: const InputDecoration(
                          labelText: '메모 (선택사항)',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // 등록 버튼
              ElevatedButton(
                onPressed: _submitPayment,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  '수납 등록',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getPaymentMethodName(PaymentMethod method) {
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
}

// 청구서 표시용 Provider
@riverpod
Future<String> billingDisplay(BillingDisplayRef ref, Billing billing) async {
  try {
    // 계약 정보 조회
    final leaseRepository = ref.watch(leaseRepositoryProvider);
    final lease = await leaseRepository.getLeaseById(billing.leaseId);
    if (lease == null) return '계약 정보 없음 (${billing.yearMonth})';

    // 임차인 정보 조회
    final tenantRepository = ref.watch(tenantRepositoryProvider);
    final tenant = await tenantRepository.getTenantById(lease.tenantId);
    final tenantName = tenant?.name ?? '알 수 없는 임차인';

    // 자산 및 유닛 정보 조회
    final propertyRepository = ref.watch(propertyRepositoryProvider);
    final unit = await propertyRepository.getUnitById(lease.unitId);
    if (unit == null) return '$tenantName - 유닛 정보 없음 (${billing.yearMonth})';

    final property = await propertyRepository.getPropertyById(unit.propertyId);
    final propertyName = property?.name ?? '알 수 없는 자산';

    // 날짜 포맷
    final yearMonth = billing.yearMonth.length >= 7
        ? billing.yearMonth.substring(0, 7)
        : billing.yearMonth;

    return '$propertyName/${unit.unitNumber}/$tenantName/$yearMonth';
  } catch (e) {
    return '정보 조회 오류 (${billing.yearMonth})';
  }
}