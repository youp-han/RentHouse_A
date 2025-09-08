import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:renthouse/features/billing/application/billing_controller.dart';
import 'package:renthouse/features/billing/application/bill_template_controller.dart';
import 'package:renthouse/features/billing/domain/bill_template.dart';
import 'package:renthouse/features/billing/domain/billing.dart';
import 'package:renthouse/features/billing/domain/billing_item.dart';
import 'package:renthouse/features/lease/application/lease_controller.dart';
import 'package:renthouse/features/lease/domain/lease.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class BillingFormScreen extends ConsumerStatefulWidget {
  final Billing? billing;

  const BillingFormScreen({super.key, this.billing});

  @override
  ConsumerState<BillingFormScreen> createState() => _BillingFormScreenState();
}

class _BillingFormScreenState extends ConsumerState<BillingFormScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedLeaseId;
  DateTime? _issueDate;
  DateTime? _dueDate;
  final List<BillingItem> _items = [];
  int _totalAmount = 0;

  bool get _isEditing => widget.billing != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final billing = widget.billing!;
      _selectedLeaseId = billing.leaseId;
      _issueDate = billing.issueDate;
      _dueDate = billing.dueDate;
      _items.addAll(billing.items);
      _calculateTotal();
    }
  }

  void _calculateTotal() {
    setState(() {
      _totalAmount = _items.fold(0, (sum, item) => sum + item.amount);
    });
  }

  void _addItem(BillTemplate template) {
    setState(() {
      _items.add(BillingItem(
        id: const Uuid().v4(),
        billingId: widget.billing?.id ?? 'temp', // Will be replaced on save
        billTemplateId: template.id,
        amount: template.amount,
      ));
    });
    _calculateTotal();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_selectedLeaseId == null || _issueDate == null || _dueDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('필수 필드를 모두 채워주세요.')),
        );
        return;
      }

      final billingId = widget.billing?.id ?? const Uuid().v4();
      final finalItems = _items.map((item) => item.copyWith(billingId: billingId)).toList();

      final billing = Billing(
        id: billingId,
        leaseId: _selectedLeaseId!,
        yearMonth: DateFormat('yyyy-MM').format(_issueDate!),
        issueDate: _issueDate!,
        dueDate: _dueDate!,
        totalAmount: _totalAmount,
        items: finalItems,
      );

      if (_isEditing) {
        ref.read(billingControllerProvider.notifier).updateBilling(billing);
      } else {
        ref.read(billingControllerProvider.notifier).addBilling(billing);
      }

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final leasesAsync = ref.watch(leaseControllerProvider);
    final templatesAsync = ref.watch(billTemplateControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? '청구서 수정' : '청구서 생성'),
      ),
      body: leasesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('계약 목록 로딩 오류: $err')),
        data: (availableLeases) => Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              DropdownButtonFormField<String>(
                value: _selectedLeaseId,
                decoration: const InputDecoration(labelText: '계약 선택'),
                items: availableLeases.map((Lease lease) {
                  return DropdownMenuItem<String>(
                    value: lease.id,
                    child: Text("계약: \n${lease.id.substring(0, 8)}..."),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedLeaseId = value),
                validator: (value) => value == null ? '계약을 선택하세요' : null,
              ),
              const SizedBox(height: 16),
              // Date selectors, etc.
              // ... (Simplified for brevity)

              const Divider(height: 32),
              Text('청구 항목', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              ..._items.map((item) {
                return ListTile(
                  title: Text("항목 ID: \n${item.billTemplateId.substring(0,8)}..."),
                  trailing: Text('${item.amount}'),
                );
              }),
              const SizedBox(height: 8),
              templatesAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (err, stack) => const Text('템플릿 로딩 오류'),
                data: (templates) => Wrap(
                  spacing: 8,
                  children: templates.map((template) {
                    return ElevatedButton(onPressed: () => _addItem(template), child: Text("+ ${template.name}"));
                  }).toList(),
                ),
              ),
              const Divider(height: 32),
              Text('총액: ${_totalAmount}원', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 32),
              FilledButton(onPressed: _submit, child: const Text('저장')),
            ],
          ),
        ),
      ),
    );
  }
}
