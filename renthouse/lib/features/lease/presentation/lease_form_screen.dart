import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:renthouse/features/lease/application/lease_controller.dart';
import 'package:renthouse/features/lease/domain/lease.dart';
import 'package:renthouse/features/property/data/property_repository.dart';
import 'package:renthouse/features/tenant/application/tenant_controller.dart';
import 'package:renthouse/features/tenant/domain/tenant.dart';
import 'package:renthouse/features/property/domain/unit.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class LeaseFormScreen extends ConsumerStatefulWidget {
  final Lease? lease;

  const LeaseFormScreen({super.key, this.lease});

  @override
  ConsumerState<LeaseFormScreen> createState() => _LeaseFormScreenState();
}

class _LeaseFormScreenState extends ConsumerState<LeaseFormScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedTenantId;
  String? _selectedUnitId;
  DateTime? _startDate;
  DateTime? _endDate;
  LeaseType _leaseType = LeaseType.residential;
  LeaseStatus _leaseStatus = LeaseStatus.pending;

  late final TextEditingController _depositController;
  late final TextEditingController _monthlyRentController;
  late final TextEditingController _notesController;

  bool get _isEditing => widget.lease != null;

  @override
  void initState() {
    super.initState();
    _depositController = TextEditingController(text: widget.lease?.deposit.toString());
    _monthlyRentController = TextEditingController(text: widget.lease?.monthlyRent.toString());
    _notesController = TextEditingController(text: widget.lease?.contractNotes);

    if (_isEditing) {
      _selectedTenantId = widget.lease!.tenantId;
      _selectedUnitId = widget.lease!.unitId;
      _startDate = widget.lease!.startDate;
      _endDate = widget.lease!.endDate;
      _leaseType = widget.lease!.leaseType;
      _leaseStatus = widget.lease!.leaseStatus;
    }
  }

  @override
  void dispose() {
    _depositController.dispose();
    _monthlyRentController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_selectedTenantId == null || _selectedUnitId == null || _startDate == null || _endDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('모든 필드를 채워주세요.')),
        );
        return;
      }

      final lease = Lease(
        id: widget.lease?.id ?? const Uuid().v4(),
        tenantId: _selectedTenantId!,
        unitId: _selectedUnitId!,
        startDate: _startDate!,
        endDate: _endDate!,
        deposit: int.parse(_depositController.text),
        monthlyRent: int.parse(_monthlyRentController.text),
        leaseType: _leaseType,
        leaseStatus: _leaseStatus,
        contractNotes: _notesController.text,
      );

      if (_isEditing) {
        ref.read(leaseControllerProvider.notifier).updateLease(lease);
      } else {
        ref.read(leaseControllerProvider.notifier).addLease(lease);
      }

      ref.invalidate(leaseControllerProvider); // Invalidate the provider to refresh the list
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final tenantsAsync = ref.watch(tenantControllerProvider);
    final unitsAsync = ref.watch(allUnitsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? '계약 수정' : '계약 등록'),
        actions: [
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
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
                    await ref.read(leaseControllerProvider.notifier).deleteLease(widget.lease!.id);
                    if (!mounted) return;
                    ref.invalidate(leaseControllerProvider); // Invalidate the provider to refresh the list
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('계약이 삭제되었습니다.')),
                    );
                    Navigator.of(context).pop(); // Go back after deletion
                  } catch (e) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('계약 삭제 실패: ${e.toString()}')),
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
        data: (tenants) {
          // Ensure _selectedTenantId is valid
          if (_isEditing && _selectedTenantId != null && !tenants.any((t) => t.id == _selectedTenantId)) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                _selectedTenantId = null;
              });
            });
          }

          return unitsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('유닛 목록 로딩 오류: $err')),
            data: (units) {
              // Ensure _selectedUnitId is valid
              if (_isEditing && _selectedUnitId != null && !units.any((u) => u.id == _selectedUnitId)) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    _selectedUnitId = null;
                  });
                });
              }

              return Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    DropdownButtonFormField<String>(
                      value: _selectedTenantId,
                      decoration: const InputDecoration(labelText: '임차인'),
                      items: tenants.map((Tenant tenant) {
                        return DropdownMenuItem<String>(
                          value: tenant.id,
                          child: Text(tenant.name),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => _selectedTenantId = value),
                      validator: (value) => value == null ? '임차인을 선택하세요' : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedUnitId,
                      decoration: const InputDecoration(labelText: '유닛 (호실)'),
                      items: units.map((Unit unit) {
                        return DropdownMenuItem<String>(
                          value: unit.id,
                          child: Text(unit.unitNumber),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => _selectedUnitId = value),
                      validator: (value) => value == null ? '유닛을 선택하세요' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _depositController,
                      decoration: const InputDecoration(labelText: '보증금'),
                      keyboardType: TextInputType.number,
                      validator: (value) => (value == null || value.isEmpty) ? '보증금을 입력하세요' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _monthlyRentController,
                      decoration: const InputDecoration(labelText: '월세'),
                      keyboardType: TextInputType.number,
                      validator: (value) => (value == null || value.isEmpty) ? '월세를 입력하세요' : null,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Text('시작일: ${_startDate == null ? '선택 안함' : DateFormat.yMd().format(_startDate!)}'),
                        ),
                        TextButton(onPressed: () async {
                          final date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100));
                          if(date != null) setState(() => _startDate = date);
                        }, child: const Text('선택')),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Text('종료일: ${_endDate == null ? '선택 안함' : DateFormat.yMd().format(_endDate!)}'),
                        ),
                        TextButton(onPressed: () async {
                          final date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100));
                          if(date != null) setState(() => _endDate = date);
                        }, child: const Text('선택')),
                      ],
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<LeaseType>(
                      value: _leaseType,
                      decoration: const InputDecoration(labelText: '계약 종류'),
                      items: LeaseType.values.map((type) => DropdownMenuItem(value: type, child: Text(type.name))).toList(),
                      onChanged: (value) => setState(() => _leaseType = value!),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<LeaseStatus>(
                      initialValue: _leaseStatus,
                      decoration: const InputDecoration(labelText: '계약 상태'),
                      items: LeaseStatus.values.map((status) => DropdownMenuItem(value: status, child: Text(status.name))).toList(),
                      onChanged: (value) => setState(() => _leaseStatus = value!),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _notesController,
                      decoration: const InputDecoration(labelText: '계약 메모'),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        FilledButton(onPressed: _submit, child: const Text('저장')),
                        const SizedBox(width: 12),
                        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('취소')),
                      ],
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}