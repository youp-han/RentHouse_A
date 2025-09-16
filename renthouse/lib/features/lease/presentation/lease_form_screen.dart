import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:renthouse/features/lease/application/lease_controller.dart';
import 'package:renthouse/features/lease/domain/lease.dart';
import 'package:renthouse/features/property/data/property_repository.dart';
import 'package:renthouse/features/tenant/application/tenant_controller.dart';
import 'package:renthouse/features/tenant/domain/tenant.dart';
import 'package:renthouse/features/property/domain/unit.dart';
import 'package:renthouse/features/property/domain/property.dart';
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
  String? _selectedPropertyId;
  String? _selectedUnitId;
  DateTime? _startDate;
  DateTime? _endDate;
  LeaseType _leaseType = LeaseType.monthly;
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
      
      // 유닛 ID로부터 자산 ID 찾기
      _findPropertyIdFromUnit();
    }
  }

  void _findPropertyIdFromUnit() async {
    if (_selectedUnitId != null) {
      // 가상 유닛 ID인 경우 propertyId 추출
      if (_selectedUnitId!.startsWith('virtual-unit-')) {
        final propertyId = _selectedUnitId!.replaceFirst('virtual-unit-', '');
        setState(() {
          _selectedPropertyId = propertyId;
        });
        return;
      }

      // 실제 유닛 ID인 경우 기존 로직 수행
      final allUnits = await ref.read(allUnitsProvider.future);
      final selectedUnit = allUnits.firstWhere((unit) => unit.id == _selectedUnitId, orElse: () => allUnits.first);
      setState(() {
        _selectedPropertyId = selectedUnit.propertyId;
      });
    }
  }

  // 현재 활성 계약이 없는 임차인들만 필터링
  List<Tenant> _getAvailableTenants(List<Tenant> allTenants, List<Lease> allLeases) {
    if (_isEditing && _selectedTenantId != null) {
      // 수정 모드인 경우 현재 선택된 임차인도 포함
      return allTenants;
    }
    
    // 새로운 계약 등록 시에는 활성 계약이 없는 임차인만 표시
    final tenantsWithActiveLeases = allLeases
        .where((lease) => lease.leaseStatus == LeaseStatus.active)
        .map((lease) => lease.tenantId)
        .toSet();
    
    return allTenants
        .where((tenant) => !tenantsWithActiveLeases.contains(tenant.id))
        .toList();
  }

  void _onPropertyChanged(String? propertyId) {
    setState(() {
      _selectedPropertyId = propertyId;
      _selectedUnitId = null; // 자산이 바뀌면 유닛 선택 초기화
    });
  }

  void _goToTenantForm() {
    context.push('/tenant/add').then((_) {
      // 임차인 등록 후 돌아왔을 때 임차인 목록 새로고침
      ref.invalidate(tenantControllerProvider);
    });
  }

  @override
  void dispose() {
    _depositController.dispose();
    _monthlyRentController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      // 토지/주택인지 확인
      Property? selectedProperty;
      if (_selectedPropertyId != null) {
        final properties = await ref.read(propertyRepositoryProvider).getProperties();
        selectedProperty = properties.firstWhere((p) => p.id == _selectedPropertyId, orElse: () => properties.first);
      }

      final isLandOrHouse = selectedProperty?.propertyType == PropertyType.land ||
                           selectedProperty?.propertyType == PropertyType.house;

      // 토지/주택이 아닌 경우 유닛 선택 필수
      if (_selectedTenantId == null || _startDate == null || _endDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('모든 필드를 채워주세요.')),
        );
        return;
      }

      if (!isLandOrHouse && _selectedUnitId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('유닛을 선택해주세요.')),
        );
        return;
      }

      // 토지/주택의 경우 가상의 유닛 ID 생성
      String unitId;
      if (isLandOrHouse) {
        unitId = _selectedUnitId ?? 'virtual-unit-${_selectedPropertyId}';
      } else {
        unitId = _selectedUnitId!;
      }

      final lease = Lease(
        id: widget.lease?.id ?? const Uuid().v4(),
        tenantId: _selectedTenantId!,
        unitId: unitId,
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
    final propertiesAsync = ref.watch(propertyRepositoryProvider).getProperties();
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
                  if (!context.mounted) return;
                  try {
                    await ref.read(leaseControllerProvider.notifier).deleteLease(widget.lease!.id);
                    if (!context.mounted) return;
                    ref.invalidate(leaseControllerProvider); // Invalidate the provider to refresh the list
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('계약이 삭제되었습니다.')),
                    );
                    Navigator.of(context).pop(); // Go back after deletion
                  } catch (e) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('계약 삭제 실패: ${e.toString()}')),
                    );
                  }
                }
              },
            ),
        ],
      ),
      body: FutureBuilder<List<Property>>(
        future: propertiesAsync,
        builder: (context, propertiesSnapshot) {
          if (propertiesSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (propertiesSnapshot.hasError) {
            return Center(child: Text('자산 목록 로딩 오류: ${propertiesSnapshot.error}'));
          }
          
          final properties = propertiesSnapshot.data ?? [];
          
          return tenantsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('임차인 목록 로딩 오류: $err')),
            data: (tenants) {
              return ref.watch(leaseControllerProvider).when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('계약 목록 로딩 오류: $err')),
                data: (leases) {
                  final availableTenants = _getAvailableTenants(tenants, leases);
              
              // Ensure _selectedTenantId is valid
              if (_isEditing && _selectedTenantId != null && !availableTenants.any((t) => t.id == _selectedTenantId)) {
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
                  // 선택된 자산의 유닛들만 필터링
                  final filteredUnits = _selectedPropertyId != null
                    ? units.where((unit) => unit.propertyId == _selectedPropertyId).toList()
                    : <Unit>[];
                  
                  // Ensure _selectedUnitId is valid (토지/주택의 가상 유닛 ID는 제외)
                  if (_selectedUnitId != null &&
                      !filteredUnits.any((u) => u.id == _selectedUnitId) &&
                      !_selectedUnitId!.startsWith('virtual-unit-')) {
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
                    // 임차인 선택 (활성 계약이 없는 임차인만)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownButtonFormField<String>(
                          initialValue: _selectedTenantId,
                          decoration: const InputDecoration(labelText: '임차인'),
                          items: availableTenants.map((Tenant tenant) {
                            return DropdownMenuItem<String>(
                              value: tenant.id,
                              child: Text(tenant.name),
                            );
                          }).toList(),
                          onChanged: (value) => setState(() => _selectedTenantId = value),
                          validator: (value) => value == null ? '임차인을 선택하세요' : null,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.info, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            const Expanded(
                              child: Text(
                                '현재 활성 계약이 없는 임차인만 표시됩니다',
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ),
                            TextButton.icon(
                              onPressed: _goToTenantForm,
                              icon: const Icon(Icons.add, size: 16),
                              label: const Text('임차인 등록'),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // 자산 선택
                    DropdownButtonFormField<String>(
                      initialValue: _selectedPropertyId,
                      decoration: const InputDecoration(labelText: '자산'),
                      items: properties.map((Property property) {
                        return DropdownMenuItem<String>(
                          value: property.id,
                          child: Text(property.name),
                        );
                      }).toList(),
                      onChanged: _onPropertyChanged,
                      validator: (value) => value == null ? '자산을 선택하세요' : null,
                    ),
                    const SizedBox(height: 16),
                    
                    // 유닛 선택 (선택된 자산의 유닛만)
                    Builder(
                      builder: (context) {
                        // 선택된 자산이 토지/주택인지 확인
                        final selectedProperty = properties.where((p) => p.id == _selectedPropertyId).firstOrNull;
                        final isLandOrHouse = selectedProperty?.propertyType == PropertyType.land ||
                                             selectedProperty?.propertyType == PropertyType.house;

                        // 토지/주택인 경우 가상 유닛 ID 처리
                        String? dropdownValue = _selectedUnitId;
                        if (isLandOrHouse && _selectedUnitId != null && _selectedUnitId!.startsWith('virtual-unit-')) {
                          dropdownValue = null; // 가상 유닛 ID는 드롭다운에서 null로 처리
                        } else if (_selectedUnitId != null && !filteredUnits.any((u) => u.id == _selectedUnitId)) {
                          dropdownValue = null; // 존재하지 않는 유닛 ID도 null로 처리
                        }

                        return DropdownButtonFormField<String>(
                          value: dropdownValue,
                          decoration: InputDecoration(
                            labelText: isLandOrHouse ? '유닛 (호실) - 선택사항' : '유닛 (호실)',
                            enabled: _selectedPropertyId != null && (filteredUnits.isNotEmpty || isLandOrHouse),
                            helperText: _selectedPropertyId == null
                              ? '먼저 자산을 선택하세요'
                              : isLandOrHouse
                                ? '토지/주택은 유닛 선택이 선택사항입니다'
                                : filteredUnits.isEmpty
                                  ? '선택된 자산에 등록된 유닛이 없습니다'
                                  : null,
                          ),
                          items: filteredUnits.map((Unit unit) {
                            return DropdownMenuItem<String>(
                              value: unit.id,
                              child: Text('${unit.unitNumber} (${unit.rentStatus.displayName})'),
                            );
                          }).toList(),
                          onChanged: _selectedPropertyId != null && (filteredUnits.isNotEmpty || isLandOrHouse)
                            ? (value) => setState(() {
                                _selectedUnitId = value;
                              })
                            : null,
                          validator: (value) {
                            // 토지/주택이 아닌 경우에만 유닛 선택 필수
                            if (!isLandOrHouse && value == null) {
                              return '유닛을 선택하세요';
                            }
                            return null;
                          },
                        );
                      }
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
                    TextFormField(
                      controller: TextEditingController(
                        text: _startDate == null ? '' : DateFormat('yyyy-MM-dd').format(_startDate!),
                      ),
                      decoration: const InputDecoration(
                        labelText: '시작일',
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      readOnly: true,
                      onTap: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: _startDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (selectedDate != null) {
                          setState(() {
                            _startDate = selectedDate;
                            // 시작일 선택 시 자동으로 1년 후로 종료일 설정
                            _endDate = DateTime(selectedDate.year + 1, selectedDate.month, selectedDate.day);
                          });
                        }
                      },
                      validator: (value) => value == null || value.isEmpty ? '시작일을 선택하세요' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: TextEditingController(
                        text: _endDate == null ? '' : DateFormat('yyyy-MM-dd').format(_endDate!),
                      ),
                      decoration: InputDecoration(
                        labelText: '종료일',
                        suffixIcon: const Icon(Icons.calendar_today),
                        helperText: _isEditing ? null : '시작일 선택 시 자동으로 1년 후로 설정됩니다',
                      ),
                      readOnly: true,
                      onTap: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: _endDate ?? (_startDate?.add(const Duration(days: 365)) ?? DateTime.now().add(const Duration(days: 365))),
                          firstDate: _startDate ?? DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (selectedDate != null) {
                          setState(() {
                            _endDate = selectedDate;
                          });
                        }
                      },
                      validator: (value) => value == null || value.isEmpty ? '종료일을 선택하세요' : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<LeaseType>(
                      initialValue: _leaseType,
                      decoration: const InputDecoration(labelText: '계약 종류'),
                      items: LeaseType.values.map((type) => DropdownMenuItem(value: type, child: Text(type.displayName))).toList(),
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
              );
            },
          );
        }),
    );
  }
}