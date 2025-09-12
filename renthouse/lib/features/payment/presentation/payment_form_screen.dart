import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:renthouse/features/payment/application/payment_controller.dart';
import 'package:renthouse/features/payment/domain/payment.dart';
import 'package:renthouse/features/payment/domain/payment_allocation.dart';
import 'package:renthouse/features/tenant/application/tenant_controller.dart';
import 'package:renthouse/features/tenant/domain/tenant.dart';
import 'package:renthouse/core/utils/currency_formatter.dart';
import 'package:renthouse/features/settings/application/currency_controller.dart';
import 'package:intl/intl.dart';

class PaymentFormScreen extends ConsumerStatefulWidget {
  const PaymentFormScreen({super.key});

  @override
  ConsumerState<PaymentFormScreen> createState() => _PaymentFormScreenState();
}

class _PaymentFormScreenState extends ConsumerState<PaymentFormScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TabController _tabController;
  
  // 기본 정보
  String? _selectedTenantId;
  PaymentMethod _selectedMethod = PaymentMethod.transfer;
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  final _memoController = TextEditingController();

  // 자동 배분
  bool _useAutoAllocation = true;
  AutoAllocationResult? _allocationPreview;

  // 수동 배분
  final List<PaymentAllocationRequest> _manualAllocations = [];

  final _dateFormat = DateFormat('yyyy-MM-dd');
  final _currencyFormat = NumberFormat('#,###');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _amountController.addListener(_onAmountChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _amountController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  void _onAmountChanged() {
    if (_selectedTenantId != null && 
        _amountController.text.isNotEmpty && 
        _useAutoAllocation) {
      _updateAllocationPreview();
    }
  }

  Future<void> _updateAllocationPreview() async {
    final amount = int.tryParse(_amountController.text.replaceAll(',', ''));
    if (amount != null && amount > 0 && _selectedTenantId != null) {
      try {
        final preview = await ref.read(
          autoAllocationPreviewProvider(_selectedTenantId!, amount).future
        );
        setState(() {
          _allocationPreview = preview;
        });
      } catch (e) {
        // 에러 처리
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tenantsAsync = ref.watch(tenantControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('수납 등록'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '기본 정보', icon: Icon(Icons.info)),
            Tab(text: '배분 설정', icon: Icon(Icons.account_tree)),
          ],
        ),
      ),
      body: Form(
        key: _formKey,
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildBasicInfoTab(tenantsAsync),
            _buildAllocationTab(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => context.pop(),
                child: const Text('취소'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _handleSubmit,
                child: const Text('수납 등록'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoTab(AsyncValue<List<Tenant>> tenantsAsync) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 임차인 선택
          Text(
            '임차인 선택 *',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          tenantsAsync.when(
            data: (tenants) => DropdownButtonFormField<String>(
              initialValue: _selectedTenantId,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '임차인을 선택해주세요',
              ),
              validator: (value) => value == null ? '임차인을 선택해주세요' : null,
              items: tenants.map((tenant) {
                return DropdownMenuItem<String>(
                  value: tenant.id,
                  child: Text(tenant.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedTenantId = value;
                  _allocationPreview = null;
                });
                if (value != null) {
                  _updateAllocationPreview();
                }
              },
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Text('오류: $err'),
          ),

          const SizedBox(height: 24),

          // 수납 금액
          Text(
            '수납 금액 *',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _amountController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: '수납할 금액을 입력해주세요',
              prefixText: '${ref.watch(currencySettingProvider).symbol} ',
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '수납 금액을 입력해주세요';
              }
              final amount = int.tryParse(value.replaceAll(',', ''));
              if (amount == null || amount <= 0) {
                return '올바른 금액을 입력해주세요';
              }
              return null;
            },
            onChanged: (value) {
              // 천 단위 구분자 추가
              final formatted = _formatCurrency(value);
              if (formatted != value) {
                _amountController.value = TextEditingValue(
                  text: formatted,
                  selection: TextSelection.collapsed(offset: formatted.length),
                );
              }
            },
          ),

          const SizedBox(height: 24),

          // 결제 수단
          Text(
            '결제 수단 *',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<PaymentMethod>(
            initialValue: _selectedMethod,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            items: PaymentMethod.values.map((method) {
              return DropdownMenuItem<PaymentMethod>(
                value: method,
                child: Text(_getMethodDisplayName(method)),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedMethod = value;
                });
              }
            },
          ),

          const SizedBox(height: 24),

          // 수납 일자
          Text(
            '수납 일자 *',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () => _selectDate(context),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_dateFormat.format(_selectedDate)),
                  const Icon(Icons.calendar_today),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // 메모
          Text(
            '메모',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _memoController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: '필요시 메모를 입력해주세요',
            ),
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildAllocationTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 배분 방식 선택
          Card(
            child: Column(
              children: [
                RadioListTile<bool>(
                  title: const Text('자동 배분'),
                  subtitle: const Text('오래된 미납 청구서부터 자동으로 배분'),
                  value: true,
                  groupValue: _useAutoAllocation,
                  onChanged: (value) {
                    setState(() {
                      _useAutoAllocation = value!;
                      if (_useAutoAllocation) {
                        _manualAllocations.clear();
                        _updateAllocationPreview();
                      }
                    });
                  },
                ),
                RadioListTile<bool>(
                  title: const Text('수동 배분'),
                  subtitle: const Text('직접 청구서를 선택하여 배분'),
                  value: false,
                  groupValue: _useAutoAllocation,
                  onChanged: (value) {
                    setState(() {
                      _useAutoAllocation = value!;
                      if (!_useAutoAllocation) {
                        _allocationPreview = null;
                      }
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 자동 배분 미리보기
          if (_useAutoAllocation && _allocationPreview != null)
            _buildAutoAllocationPreview(_allocationPreview!),

          // 수동 배분 설정
          if (!_useAutoAllocation)
            _buildManualAllocationSettings(),
        ],
      ),
    );
  }

  Widget _buildAutoAllocationPreview(AutoAllocationResult preview) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '자동 배분 미리보기',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            
            // 요약
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('총 수납액:'),
                      Text(CurrencyFormatter.format(preview.totalAmount, ref.watch(currencySettingProvider))),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('배분 금액:'),
                      Text(CurrencyFormatter.format(preview.allocatedAmount, ref.watch(currencySettingProvider))),
                    ],
                  ),
                  if (preview.remainingAmount > 0)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('잔여 금액:'),
                        Text(
                          CurrencyFormatter.format(preview.remainingAmount, ref.watch(currencySettingProvider)),
                          style: const TextStyle(color: Colors.orange),
                        ),
                      ],
                    ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 배분 상세
            if (preview.allocations.isNotEmpty) ...[
              const Text('배분 상세:'),
              const SizedBox(height: 8),
              ...preview.allocations.map((allocation) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  child: ListTile(
                    title: Text('${allocation.yearMonth} 청구서'),
                    subtitle: Text(
                      '청구액: ${CurrencyFormatter.format(allocation.billingAmount, ref.watch(currencySettingProvider))} | '
                      '기납부: ${CurrencyFormatter.format(allocation.paidAmount, ref.watch(currencySettingProvider))}'
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          CurrencyFormatter.format(allocation.allocationAmount, ref.watch(currencySettingProvider)),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        if (allocation.remainingAmount > 0)
                          Text(
                            '잔액: ${CurrencyFormatter.format(allocation.remainingAmount, ref.watch(currencySettingProvider))}',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildManualAllocationSettings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '수동 배분 설정',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: 청구서 선택 다이얼로그
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('청구서 추가'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            if (_manualAllocations.isEmpty)
              const Center(
                child: Text(
                  '수동 배분할 청구서를 추가해주세요',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            else
              ..._manualAllocations.asMap().entries.map((entry) {
                final index = entry.key;
                final allocation = entry.value;
                
                return Card(
                  child: ListTile(
                    title: Text('청구서 ${allocation.billingId}'),
                    subtitle: Text(CurrencyFormatter.format(allocation.amount, ref.watch(currencySettingProvider))),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          _manualAllocations.removeAt(index);
                        });
                      },
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  String _formatCurrency(String value) {
    final numericValue = value.replaceAll(',', '');
    if (numericValue.isEmpty) return '';
    
    final number = int.tryParse(numericValue);
    if (number == null) return value;
    
    return _currencyFormat.format(number);
  }

  String _getMethodDisplayName(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cash: return '현금';
      case PaymentMethod.transfer: return '계좌이체';
      case PaymentMethod.card: return '카드';
      case PaymentMethod.check: return '수표';
      case PaymentMethod.other: return '기타';
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedTenantId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('임차인을 선택해주세요')),
      );
      return;
    }

    try {
      final amount = int.parse(_amountController.text.replaceAll(',', ''));
      
      final request = CreatePaymentRequest(
        tenantId: _selectedTenantId!,
        method: _selectedMethod,
        amount: amount,
        paidDate: _selectedDate,
        memo: _memoController.text.isNotEmpty ? _memoController.text : null,
        manualAllocations: _useAutoAllocation ? null : _manualAllocations,
      );

      await ref.read(paymentControllerProvider.notifier).createPayment(request);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('수납이 성공적으로 등록되었습니다!'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('수납 등록 실패: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}