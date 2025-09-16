import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:renthouse/features/billing/application/billing_controller.dart';
import 'package:renthouse/features/billing/application/bill_template_controller.dart';
import 'package:renthouse/features/billing/domain/bill_template.dart';
import 'package:renthouse/features/billing/domain/billing.dart';
import 'package:renthouse/features/billing/domain/billing_item.dart';
import 'package:renthouse/features/lease/application/lease_controller.dart';
import 'package:renthouse/features/lease/domain/lease.dart';
import 'package:renthouse/features/property/data/property_repository.dart';
import 'package:renthouse/features/tenant/application/tenant_controller.dart';
import 'package:collection/collection.dart';
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
  final List<TextEditingController> _amountControllers = [];
  final List<bool> _itemsChecked = [];
  int _totalAmount = 0;

  // Cache for custom templates created during this session
  final Map<String, BillTemplate> _customTemplates = {};

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
      // Initialize controllers for existing items
      for (final item in _items) {
        _amountControllers.add(TextEditingController(text: item.amount.toString()));
        _itemsChecked.add(true); // Existing items are checked by default
      }
      _calculateTotal();
    } else {
      // Set default dates for new billing
      _setDefaultDates();
    }
  }
  
  void _setDefaultDates() {
    final now = DateTime.now();
    // Issue date: last day of current month
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    _issueDate = lastDayOfMonth;
    // Due date: issue date + 5 days
    _dueDate = lastDayOfMonth.add(const Duration(days: 5));
  }

  @override
  void dispose() {
    // Dispose all controllers to prevent memory leaks
    for (final controller in _amountControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _calculateTotal() {
    int total = 0;
    for (int i = 0; i < _items.length; i++) {
      if (i < _amountControllers.length && i < _itemsChecked.length) {
        final amount = int.tryParse(_amountControllers[i].text) ?? 0;
        // Only include checked items in total
        if (_itemsChecked[i]) {
          total += amount;
        }
        // Update the item's amount
        _items[i] = _items[i].copyWith(amount: amount);
      }
    }
    setState(() {
      _totalAmount = total;
    });
  }

  void _addItem(BillTemplate template) {
    setState(() {
      _items.add(BillingItem(
        id: const Uuid().v4(),
        billingId: widget.billing?.id ?? 'temp', // Will be replaced on save
        billTemplateId: template.id,
        amount: template.amount,
        itemName: template.name, // 템플릿 이름을 직접 저장
      ));
      // Add controller for the new item
      _amountControllers.add(TextEditingController(text: template.amount.toString()));
      _itemsChecked.add(true); // New items are checked by default
    });
    _calculateTotal();
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
      _amountControllers[index].dispose();
      _amountControllers.removeAt(index);
      _itemsChecked.removeAt(index);
    });
    _calculateTotal();
  }

  void _showCustomItemDialog() {
    final nameController = TextEditingController();
    final amountController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('사용자 정의 청구 항목'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: '항목명',
                hintText: '예: 인터넷비, 가스비 등',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(
                labelText: '금액',
                suffixText: '원',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () {
              final name = nameController.text.trim();
              final amountText = amountController.text.trim();
              
              if (name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('항목명을 입력하세요.')),
                );
                return;
              }
              
              final amount = int.tryParse(amountText) ?? 0;
              
              // Create a temporary template for custom item
              final customTemplate = BillTemplate(
                id: const Uuid().v4(),
                name: name,
                category: '사용자정의',
                amount: amount,
                description: '사용자 정의 항목',
              );

              // Cache the custom template for later retrieval
              _customTemplates[customTemplate.id] = customTemplate;

              _addItem(customTemplate);
              Navigator.of(context).pop();
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$name 항목이 추가되었습니다.')),
              );
            },
            child: const Text('추가'),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddDefaultItemsDialog(String leaseId, List<Lease> availableLeases) async {
    final lease = availableLeases.firstWhere((l) => l.id == leaseId);
    
    // Get unit and property information for preview
    final unitDetail = await ref.read(unitDetailProvider(lease.unitId).future);
    final property = unitDetail != null 
        ? await ref.read(propertyDetailProvider(unitDetail.propertyId).future)
        : null;
    
    // Calculate preview items
    final previewItems = <Map<String, dynamic>>[];
    
    // 1. Monthly rent - always include
    previewItems.add({
      'name': '월세',
      'amount': lease.monthlyRent,
    });
    
    // 2. Property billing items or fallback
    if (property != null && property.defaultBillingItems.isNotEmpty) {
      for (final billingItem in property.defaultBillingItems) {
        if (billingItem.isEnabled) {
          previewItems.add({
            'name': billingItem.name,
            'amount': billingItem.amount,
          });
        }
      }
    } else {
      // Fallback to management fee - only for villa, house, commercial properties
      if (property != null &&
          (property.propertyType.name == 'villa' ||
           property.propertyType.name == 'house' ||
           property.propertyType.name == 'commercial')) {
        previewItems.add({
          'name': '관리비',
          'amount': 50000,
        });
      }
    }
    
    // 3. Parking fee from contract notes if not in property items
    final hasParking = lease.contractNotes?.contains('주차') == true;
    final hasParkingInProperty = property?.defaultBillingItems.any((item) => 
      item.name.contains('주차') && item.isEnabled) ?? false;
    
    if (hasParking && !hasParkingInProperty) {
      previewItems.add({
        'name': '주차비',
        'amount': 50000,
      });
    }
    
    if (!mounted) return;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('기본 청구 항목 추가'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('이 계약에 대한 기본 청구 항목을 자동으로 추가하시겠습니까?'),
            if (property != null && property.defaultBillingItems.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                '※ ${property.name} 자산에 설정된 기본 청구 항목이 포함됩니다.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: previewItems.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, size: 16, color: Colors.green),
                      const SizedBox(width: 8),
                      Expanded(child: Text('${item['name']}: ${NumberFormat('#,###').format(item['amount'])}원')),
                    ],
                  ),
                )).toList(),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '※ 추가 후 금액 수정이나 항목 해제가 가능합니다.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              _addDefaultBillingItems(leaseId, availableLeases);
            },
            child: Text('${previewItems.length}개 항목 추가'),
          ),
        ],
      ),
    );
  }

  Future<void> _addDefaultBillingItems(String leaseId, List<Lease> availableLeases) async {
    final lease = availableLeases.firstWhere((l) => l.id == leaseId);
    final templates = ref.read(billTemplateControllerProvider).value ?? [];

    // Don't clear existing items, just add new ones

    // Get unit and property information
    final unitDetail = await ref.read(unitDetailProvider(lease.unitId).future);
    final property = unitDetail != null
        ? await ref.read(propertyDetailProvider(unitDetail.propertyId).future)
        : null;

    // Add default items with smart amounts
    final defaultItems = <Map<String, dynamic>>[];

    // 1. Monthly rent - always add with lease amount
    defaultItems.add({
      'name': '월세',
      'amount': lease.monthlyRent,
      'checked': true,
    });

    // 2. Add property's default billing items (자산에서 설정한 기본 청구 항목)
    if (property != null && property.defaultBillingItems.isNotEmpty) {
      for (final billingItem in property.defaultBillingItems) {
        if (billingItem.isEnabled) {
          defaultItems.add({
            'name': billingItem.name,
            'amount': billingItem.amount,
            'checked': true,
          });
        }
      }
    } else {
      // Fallback to hardcoded items if no property billing items
      // 2. Management fee - only for villa, house, commercial properties
      if (property != null &&
          (property.propertyType.name == 'villa' ||
           property.propertyType.name == 'house' ||
           property.propertyType.name == 'commercial')) {
        defaultItems.add({
          'name': '관리비',
          'amount': 50000,
          'checked': true,
        });
      }
    }

    // 3. Parking fee - add if "주차" is in contract notes
    if (lease.contractNotes?.contains('주차') == true) {
      // Check if parking fee is not already in property billing items
      final hasParking = property?.defaultBillingItems.any((item) =>
        item.name.contains('주차') && item.isEnabled) ?? false;

      if (!hasParking) {
        defaultItems.add({
          'name': '주차비',
          'amount': 50000,
          'checked': true,
        });
      }
    }

    // Create custom templates for default items and add them
    for (final itemData in defaultItems) {
      final itemName = itemData['name'] as String;
      final amount = itemData['amount'] as int;
      final checked = itemData['checked'] as bool;

      // Try to find matching existing template
      var template = templates.where((t) => t.name.contains(itemName)).firstOrNull;

      // If no match found, create a custom template for this item
      if (template == null) {
        template = BillTemplate(
          id: const Uuid().v4(),
          name: itemName,
          category: '기본',
          amount: amount,
          description: '기본 청구 항목',
        );
        // Cache the custom template for later retrieval
        _customTemplates[template.id] = template;
      }

      setState(() {
        _items.add(BillingItem(
          id: const Uuid().v4(),
          billingId: widget.billing?.id ?? 'temp',
          billTemplateId: template!.id,
          amount: amount,
          itemName: template.name, // 템플릿 이름을 직접 저장
        ));
        _amountControllers.add(TextEditingController(text: amount.toString()));
        _itemsChecked.add(checked);
      });
    }
    
    _calculateTotal();
    
    // Show notification to user
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${defaultItems.length}개의 기본 청구 항목이 추가되었습니다.'),
        duration: const Duration(seconds: 2),
      ),
    );
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
      // Only include checked items in final billing
      final finalItems = <BillingItem>[];
      for (int i = 0; i < _items.length; i++) {
        if (i < _itemsChecked.length && _itemsChecked[i]) {
          finalItems.add(_items[i].copyWith(billingId: billingId));
        }
      }

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
        ref.read(billingControllerProvider().notifier).updateBilling(billing);
      } else {
        ref.read(billingControllerProvider().notifier).addBilling(billing);
      }

      ref.invalidate(billingControllerProvider); // Invalidate the provider to refresh the list
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final leasesAsync = ref.watch(leaseControllerProvider);
    final templatesAsync = ref.watch(billTemplateControllerProvider);
    final tenantsAsync = ref.watch(tenantControllerProvider);
    final unitsAsync = ref.watch(allUnitsProvider);
    final propertiesAsync = ref.watch(propertyRepositoryProvider).getProperties();

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? '청구서 수정' : '청구서 생성'),
        actions: [
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('청구서 삭제'),
                    content: const Text('정말로 이 청구서를 삭제하시겠습니까?'),
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
                  if (!context.mounted) return;
                  try {
                    await ref.read(billingControllerProvider().notifier).deleteBilling(widget.billing!.id);
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('청구서가 삭제되었습니다.')),
                    );
                    ref.invalidate(billingControllerProvider); // Invalidate the provider to refresh the list
                    Navigator.of(context).pop(); // Go back after deletion
                  } catch (e) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('청구서 삭제 실패: ${e.toString()}')),
                    );
                  }
                }
              },
            ),
        ],
      ),
      body: tenantsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('임차인 목록 로딩 오류: $err')),
        data: (tenants) => unitsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('유닛 목록 로딩 오류: $err')),
          data: (units) => FutureBuilder(
            future: propertiesAsync,
            builder: (context, propertiesSnapshot) {
              if (propertiesSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final properties = propertiesSnapshot.data ?? [];

              return leasesAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('계약 목록 로딩 오류: $err')),
                data: (availableLeases) => Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      DropdownButtonFormField<String>(
                        initialValue: _selectedLeaseId,
                        decoration: const InputDecoration(labelText: '계약 선택'),
                        items: availableLeases.map((Lease lease) {
                          final tenant = tenants.firstWhereOrNull((t) => t.id == lease.tenantId);

                          // 가상 유닛 ID 처리
                          String? propertyId;
                          String unitNumber;

                          if (lease.unitId.startsWith('virtual-unit-')) {
                            // 가상 유닛 ID에서 propertyId 추출
                            propertyId = lease.unitId.replaceFirst('virtual-unit-', '');
                            unitNumber = '전체'; // 토지/주택의 경우 전체로 표시
                          } else {
                            // 실제 유닛 ID인 경우
                            final unit = units.firstWhereOrNull((u) => u.id == lease.unitId);
                            propertyId = unit?.propertyId;
                            unitNumber = unit?.unitNumber ?? '알 수 없는 유닛';
                          }

                          final property = propertyId != null
                              ? properties.firstWhereOrNull((p) => p.id == propertyId)
                              : null;

                          final propertyName = property?.name ?? '알 수 없는 자산';
                          final tenantName = tenant?.name ?? '알 수 없는 임차인';
                          final displayText = '$propertyName:$unitNumber - $tenantName';

                          return DropdownMenuItem<String>(
                            value: lease.id,
                            child: Text(displayText),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() => _selectedLeaseId = value);
                          if (value != null && !_isEditing) {
                            // Show confirmation dialog for adding default items
                            _showAddDefaultItemsDialog(value, availableLeases);
                          }
                        },
                        validator: (value) => value == null ? '계약을 선택하세요' : null,
                      ),
              const SizedBox(height: 16),
              TextFormField(
                controller: TextEditingController(
                  text: _issueDate == null ? '' : DateFormat('yyyy-MM-dd').format(_issueDate!),
                ),
                decoration: InputDecoration(
                  labelText: '발행일',
                  suffixIcon: const Icon(Icons.calendar_today),
                  helperText: _isEditing ? null : '기본값: 매월 마지막 날',
                ),
                readOnly: true,
                onTap: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: _issueDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      _issueDate = selectedDate;
                      // Auto-update due date when issue date changes
                      _dueDate = selectedDate.add(const Duration(days: 5));
                    });
                  }
                },
                validator: (value) => value == null || value.isEmpty ? '발행일을 선택하세요' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: TextEditingController(
                  text: _dueDate == null ? '' : DateFormat('yyyy-MM-dd').format(_dueDate!),
                ),
                decoration: InputDecoration(
                  labelText: '납부 기한',
                  suffixIcon: const Icon(Icons.calendar_today),
                  helperText: _isEditing ? null : '기본값: 발행일 + 5일',
                ),
                readOnly: true,
                onTap: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: _dueDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      _dueDate = selectedDate;
                    });
                  }
                },
                validator: (value) => value == null || value.isEmpty ? '납부 기한을 선택하세요' : null,
              ),
              const SizedBox(height: 16),

              const Divider(height: 32),
              
              // 청구 항목 추가 섹션
              Row(
                children: [
                  Text('청구 항목', style: Theme.of(context).textTheme.titleLarge),
                  const Spacer(),
                  templatesAsync.when(
                    loading: () => const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    error: (err, stack) => IconButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('템플릿 로딩 오류: $err')),
                        );
                      },
                      icon: const Icon(Icons.error, color: Colors.red),
                      tooltip: '템플릿 로딩 오류',
                    ),
                    data: (templates) {
                      if (templates.isEmpty) {
                        return IconButton(
                          onPressed: () {
                            _showCustomItemDialog();
                          },
                          icon: const Icon(Icons.add_circle),
                          tooltip: '사용자 정의 항목 추가 (템플릿 없음)',
                        );
                      }
                      return PopupMenuButton<BillTemplate?>(
                        icon: const Icon(Icons.add_circle),
                        tooltip: '청구 항목 추가',
                        onSelected: (template) {
                          if (template != null) {
                            _addItem(template);
                          } else {
                            _showCustomItemDialog();
                          }
                        },
                        itemBuilder: (context) => [
                          ...templates.map((template) {
                            return PopupMenuItem<BillTemplate>(
                              value: template,
                              child: Row(
                                children: [
                                  Icon(Icons.receipt_outlined, size: 16),
                                  const SizedBox(width: 8),
                                  Text(template.name),
                                ],
                              ),
                            );
                          }),
                          const PopupMenuDivider(),
                          const PopupMenuItem<BillTemplate?>(
                            value: null,
                            child: Row(
                              children: [
                                Icon(Icons.edit, size: 16),
                                SizedBox(width: 8),
                                Text('사용자 정의 항목'),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // 청구 항목 목록
              if (_items.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Icon(Icons.receipt_long_outlined, 
                          size: 48, 
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '청구 항목이 없습니다',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '위의 + 버튼을 눌러 항목을 추가하세요',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ..._items.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  
                  BillTemplate? template;

                  // First check cached custom templates
                  template = _customTemplates[item.billTemplateId];

                  // If not found in cache, check official templates
                  if (template == null && templatesAsync.value != null) {
                    for (var t in templatesAsync.value!) {
                      if (t.id == item.billTemplateId) {
                        template = t;
                        break;
                      }
                    }
                  }

                  // If template not found, create a default one for display
                  template ??= BillTemplate(
                    id: item.billTemplateId,
                    name: '기본 항목',
                    category: '기타',
                    description: '청구 항목',
                    amount: item.amount,
                  );

                  // Use stored itemName if available, otherwise use template name
                  final displayName = item.itemName ?? template.name;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          // Checkbox
                          Checkbox(
                            value: _itemsChecked[index],
                            onChanged: (value) {
                              setState(() {
                                _itemsChecked[index] = value ?? false;
                              });
                              _calculateTotal();
                            },
                          ),
                          const SizedBox(width: 8),
                          // Item name
                          Expanded(
                            flex: 2,
                            child: Text(
                              displayName,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: _itemsChecked[index] 
                                  ? null 
                                  : Theme.of(context).colorScheme.outline,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Amount input
                          Expanded(
                            child: TextFormField(
                              controller: _amountControllers[index],
                              enabled: _itemsChecked[index],
                              decoration: InputDecoration(
                                labelText: '금액',
                                suffixText: '원',
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, 
                                  vertical: 8,
                                ),
                                fillColor: _itemsChecked[index] 
                                  ? null 
                                  : Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                                filled: !_itemsChecked[index],
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (_) => _calculateTotal(),
                              validator: (value) {
                                if (_itemsChecked[index]) {
                                  if (value == null || value.isEmpty) {
                                    return '금액을 입력하세요';
                                  }
                                  if (int.tryParse(value) == null) {
                                    return '유효한 숫자를 입력하세요';
                                  }
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Delete button
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            onPressed: () => _removeItem(index),
                            tooltip: '항목 삭제',
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              const Divider(height: 32),
              
              // 총액 표시
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calculate,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '총액',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${NumberFormat('#,###').format(_totalAmount)}원',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              FilledButton(onPressed: _submit, child: const Text('저장')),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}