import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:renthouse/features/property/application/property_controller.dart';
import 'package:renthouse/features/property/domain/property.dart';
import 'package:renthouse/features/property/data/property_repository.dart';
import 'package:renthouse/core/auth/auth_repository.dart';
import 'package:renthouse/core/services/postcode_service.dart';
import 'package:uuid/uuid.dart';

class PropertyFormScreen extends ConsumerStatefulWidget {
  final Property? property;
  const PropertyFormScreen({super.key, this.property});
  @override
  ConsumerState<PropertyFormScreen> createState() => _PropertyFormScreenState();
}

class _PropertyFormScreenState extends ConsumerState<PropertyFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  // 주소 필드들 (task136)
  final _zipCodeController = TextEditingController();
  final _address1Controller = TextEditingController();
  final _address2Controller = TextEditingController();
  final _totalUnitsController = TextEditingController();
  // 소유자 정보 (task134)
  final _ownerNameController = TextEditingController();
  final _ownerPhoneController = TextEditingController();
  final _ownerEmailController = TextEditingController();

  final Uuid _uuid = const Uuid();

  // 자산 유형 (task132)
  PropertyType _selectedPropertyType = PropertyType.villa;
  // 계약 종류 (task135)
  ContractType _selectedContractType = ContractType.wolse;
  // 소유자 정보 자동 입력 여부
  bool _useCurrentUserAsOwner = false;
  // 청구 항목들
  final List<Map<String, dynamic>> _billingItems = [
    {'name': '관리비', 'amount': 50000, 'enabled': false, 'controller': TextEditingController(text: '50000')},
    {'name': '수도비', 'amount': 30000, 'enabled': false, 'controller': TextEditingController(text: '30000')},
    {'name': '전기비', 'amount': 40000, 'enabled': false, 'controller': TextEditingController(text: '40000')},
    {'name': '청소비', 'amount': 20000, 'enabled': false, 'controller': TextEditingController(text: '20000')},
    {'name': '주차비', 'amount': 50000, 'enabled': false, 'controller': TextEditingController(text: '50000')},
    {'name': '수리비 (임차인과실)', 'amount': 0, 'enabled': false, 'controller': TextEditingController(text: '0')},
  ];

  bool get _isEditMode => widget.property != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      final p = widget.property!;
      _nameController.text = p.name;
      // 주소 필드들
      _zipCodeController.text = p.zipCode ?? '';
      _address1Controller.text = p.address1 ?? '';
      _address2Controller.text = p.address2 ?? '';
      _totalUnitsController.text = p.totalUnits.toString();
      // 소유자 정보
      _ownerNameController.text = p.ownerName ?? '';
      _ownerPhoneController.text = p.ownerPhone ?? '';
      _ownerEmailController.text = p.ownerEmail ?? '';
      // 자산 유형과 계약 종류
      _selectedPropertyType = p.propertyType;
      _selectedContractType = p.contractType;
      // 청구 항목들 로드
      _loadExistingBillingItems(p.defaultBillingItems);
    }
  }

  void _loadExistingBillingItems(List<BillingItem> existingItems) {
    for (final existing in existingItems) {
      for (final item in _billingItems) {
        if (item['name'] == existing.name) {
          item['enabled'] = existing.isEnabled;
          item['amount'] = existing.amount;
          (item['controller'] as TextEditingController).text = existing.amount.toString();
          break;
        }
      }
    }
  }

  Future<void> _loadCurrentUserInfo() async {
    try {
      final authRepository = ref.read(authRepositoryProvider);
      final currentUser = await authRepository.getCurrentUser();
      if (currentUser != null) {
        setState(() {
          _ownerNameController.text = currentUser.name;
          _ownerEmailController.text = currentUser.email;
          // 연락처는 사용자가 직접 입력하도록 포커스 이동
          FocusScope.of(context).requestFocus(FocusNode());
        });
        // 연락처 필드에 포커스
        Future.delayed(const Duration(milliseconds: 100), () {
          FocusScope.of(context).nextFocus();
          FocusScope.of(context).nextFocus();
        });
      }
    } catch (e) {
      // 오류가 있어도 계속 진행
      print('사용자 정보 로딩 실패: $e');
    }
  }

  // 우편번호 검색 기능 (Task137, Task138)
  Future<void> _searchAddress() async {
    try {
      final result = await PostcodeService.searchAddress(context);
      if (result != null) {
        setState(() {
          _zipCodeController.text = result.zipCode;
          _address1Controller.text = result.address1;
          // 상세주소 필드에 포커스 이동
          FocusScope.of(context).nextFocus();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('주소가 자동으로 입력되었습니다.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('주소 검색 중 오류가 발생했습니다: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _zipCodeController.dispose();
    _address1Controller.dispose();
    _address2Controller.dispose();
    _totalUnitsController.dispose();
    _ownerNameController.dispose();
    _ownerPhoneController.dispose();
    _ownerEmailController.dispose();
    for (final item in _billingItems) {
      (item['controller'] as TextEditingController).dispose();
    }
    super.dispose();
  }

  Future<void> _showAddUnitsDialog(String propertyId) async {
    if (_isEditMode) {
      // 수정 모드에서는 단순 완료 메시지만 표시하고 detail 화면으로 이동
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('자산 수정 완료'),
          content: const Text('자산 정보가 성공적으로 수정되었습니다.'),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('확인'),
            ),
          ],
        ),
      );

      if (mounted) {
        context.go('/property/$propertyId');
      }
    } else {
      // 신규 등록 모드에서는 유닛 등록 여부를 물어봄
      final wantsToAddUnits = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('자산 저장 완료'),
          content: const Text('자산 정보가 저장되었습니다. 이어서 유닛을 등록하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('나중에'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('지금 등록'),
            ),
          ],
        ),
      );

      if (mounted) { // Check if the widget is still in the tree
        if (wantsToAddUnits == true) {
          context.go('/property/$propertyId/units/add');
        } else {
          context.go('/property');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final propertyRepository = ref.read(propertyRepositoryProvider);
    final propertyListController = ref.read(propertyListControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(_isEditMode ? '자산 수정' : '자산 등록')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 32,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: '이름'),
                        validator: (v) => (v == null || v.isEmpty) ? '이름은 필수입니다.' : null,
                      ),
                      const SizedBox(height: 12),
                      // 주소 필드들 (task136) + 우편번호 검색 기능 (task137, task138)
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: _zipCodeController,
                              decoration: const InputDecoration(labelText: '우편번호'),
                              readOnly: true,
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: _searchAddress,
                            icon: const Icon(Icons.search),
                            label: const Text('주소 검색'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _address1Controller,
                        decoration: const InputDecoration(
                          labelText: '주소',
                          helperText: '위의 "주소 검색" 버튼을 클릭하여 자동 입력하세요',
                        ),
                        validator: (v) => (v == null || v.isEmpty) ? '주소는 필수입니다.' : null,
                        readOnly: true,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _address2Controller,
                        decoration: const InputDecoration(labelText: '상세주소'),
                      ),
                      const SizedBox(height: 12),
                      // 자산 유형 드롭다운 (task132)
                      DropdownButtonFormField<PropertyType>(
                        value: _selectedPropertyType,
                        decoration: const InputDecoration(labelText: '자산 유형'),
                        items: PropertyType.values.map((type) =>
                          DropdownMenuItem(value: type, child: Text(type.displayName))
                        ).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedPropertyType = value!;
                            // 토지/주택 외 자산의 경우 기본 unit 수를 1로 설정
                            if (value != PropertyType.land && value != PropertyType.house) {
                              if (_totalUnitsController.text.isEmpty || _totalUnitsController.text == '0') {
                                _totalUnitsController.text = '1';
                              }
                            }
                          });
                        },
                        validator: (v) => v == null ? '자산 유형을 선택해주세요.' : null,
                      ),
                      const SizedBox(height: 12),
                      // 계약 종류 드롭다운 (task135)
                      DropdownButtonFormField<ContractType>(
                        value: _selectedContractType,
                        decoration: const InputDecoration(labelText: '계약 종류'),
                        items: ContractType.values.map((type) =>
                          DropdownMenuItem(value: type, child: Text(type.displayName))
                        ).toList(),
                        onChanged: (value) => setState(() => _selectedContractType = value!),
                        validator: (v) => v == null ? '계약 종류를 선택해주세요.' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _totalUnitsController,
                        decoration: InputDecoration(
                          labelText: '총 유닛 수',
                          helperText: _selectedPropertyType == PropertyType.land || _selectedPropertyType == PropertyType.house
                              ? '토지/주택은 0으로 설정 가능합니다'
                              : '일반 자산은 1 이상이어야 합니다',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          if (v == null || v.isEmpty) return '총 유닛 수를 입력해주세요.';
                          final units = int.tryParse(v);
                          if (units == null) return '유효한 총 유닛 수를 입력해주세요.';

                          // 토지/주택은 0 허용, 다른 자산은 1 이상 필요
                          if (_selectedPropertyType == PropertyType.land || _selectedPropertyType == PropertyType.house) {
                            return units < 0 ? '0 이상의 값을 입력해주세요.' : null;
                          } else {
                            return units < 1 ? '1 이상의 값을 입력해주세요.' : null;
                          }
                        },
                      ),
                      const SizedBox(height: 24),
                      // 소유자 정보 섹션 (task134)
                      const Text('소유자 정보', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),

                      // 현재 사용자와 동일 체크박스
                      CheckboxListTile(
                        title: const Text('소유자 정보가 로그인 회원과 동일'),
                        subtitle: const Text('성명과 이메일이 자동으로 입력됩니다'),
                        value: _useCurrentUserAsOwner,
                        onChanged: (bool? value) {
                          setState(() {
                            _useCurrentUserAsOwner = value ?? false;
                          });

                          if (_useCurrentUserAsOwner) {
                            _loadCurrentUserInfo();
                          } else {
                            // 체크 해제 시 필드 초기화
                            setState(() {
                              _ownerNameController.clear();
                              _ownerEmailController.clear();
                            });
                          }
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: _ownerNameController,
                        decoration: const InputDecoration(labelText: '소유자 성명'),
                        readOnly: _useCurrentUserAsOwner,
                        style: TextStyle(
                          color: _useCurrentUserAsOwner ? Colors.grey[600] : null,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _ownerPhoneController,
                        decoration: const InputDecoration(
                          labelText: '소유자 연락처 *',
                          helperText: '필수 입력 항목입니다',
                        ),
                        keyboardType: TextInputType.phone,
                        validator: _useCurrentUserAsOwner
                          ? (v) => (v == null || v.isEmpty) ? '연락처는 필수입니다.' : null
                          : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _ownerEmailController,
                        decoration: const InputDecoration(labelText: '소유자 이메일'),
                        keyboardType: TextInputType.emailAddress,
                        readOnly: _useCurrentUserAsOwner,
                        style: TextStyle(
                          color: _useCurrentUserAsOwner ? Colors.grey[600] : null,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // 청구 항목 선택 섹션 (추가 요구사항)
                      const Text('기본 청구 항목', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      Column(
                        children: _billingItems.map((item) => Card(
                          child: CheckboxListTile(
                            title: Text(item['name'] as String),
                            subtitle: Row(
                              children: [
                                const Text('금액: '),
                                SizedBox(
                                  width: 120,
                                  child: TextFormField(
                                    controller: item['controller'] as TextEditingController,
                                    decoration: const InputDecoration(
                                      suffixText: '원',
                                      isDense: true,
                                    ),
                                    keyboardType: TextInputType.number,
                                    enabled: item['enabled'] as bool,
                                    onChanged: (value) {
                                      final amount = int.tryParse(value) ?? 0;
                                      item['amount'] = amount;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            value: item['enabled'] as bool,
                            onChanged: (bool? value) {
                              setState(() {
                                item['enabled'] = value ?? false;
                              });
                            },
                          ),
                        )).toList(),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          FilledButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                try {
                                  // 청구 항목 준비
                                  final billingItems = _billingItems
                                    .where((item) => item['enabled'] as bool)
                                    .map((item) => BillingItem(
                                      name: item['name'] as String,
                                      amount: item['amount'] as int,
                                      isEnabled: true,
                                    ))
                                    .toList();

                                  String propertyId;
                                  if (_isEditMode) {
                                    propertyId = widget.property!.id;
                                    final updatedProperty = widget.property!.copyWith(
                                      name: _nameController.text,
                                      zipCode: _zipCodeController.text.isEmpty ? null : _zipCodeController.text,
                                      address1: _address1Controller.text.isEmpty ? null : _address1Controller.text,
                                      address2: _address2Controller.text.isEmpty ? null : _address2Controller.text,
                                      propertyType: _selectedPropertyType,
                                      contractType: _selectedContractType,
                                      totalUnits: int.parse(_totalUnitsController.text),
                                      ownerName: _ownerNameController.text.isEmpty ? null : _ownerNameController.text,
                                      ownerPhone: _ownerPhoneController.text.isEmpty ? null : _ownerPhoneController.text,
                                      ownerEmail: _ownerEmailController.text.isEmpty ? null : _ownerEmailController.text,
                                      defaultBillingItems: billingItems,
                                    );
                                    await propertyRepository.updateProperty(updatedProperty);
                                  } else {
                                    propertyId = _uuid.v4();
                                    final newProperty = Property(
                                      id: propertyId,
                                      name: _nameController.text,
                                      zipCode: _zipCodeController.text.isEmpty ? null : _zipCodeController.text,
                                      address1: _address1Controller.text.isEmpty ? null : _address1Controller.text,
                                      address2: _address2Controller.text.isEmpty ? null : _address2Controller.text,
                                      propertyType: _selectedPropertyType,
                                      contractType: _selectedContractType,
                                      totalUnits: int.parse(_totalUnitsController.text),
                                      ownerName: _ownerNameController.text.isEmpty ? null : _ownerNameController.text,
                                      ownerPhone: _ownerPhoneController.text.isEmpty ? null : _ownerPhoneController.text,
                                      ownerEmail: _ownerEmailController.text.isEmpty ? null : _ownerEmailController.text,
                                      defaultBillingItems: billingItems,
                                      units: [], // Always create with empty units
                                    );
                                    await propertyRepository.createProperty(newProperty);
                                  }

                                  await propertyListController.refreshProperties();

                                  // 자산 상세 정보 캐시 무효화 - 편집 후 상세화면에서 최신 데이터 표시
                                  if (_isEditMode) {
                                    ref.invalidate(propertyDetailProvider(propertyId));
                                  }

                                  if (!mounted) return;
                                  final totalUnits = int.tryParse(_totalUnitsController.text) ?? 0;
                                  if (totalUnits > 0) {
                                    await _showAddUnitsDialog(propertyId);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('자산이 성공적으로 저장되었습니다.')),
                                    );
                                    context.go('/property');
                                  }
                                } catch (e) {
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('자산 저장 실패: ${e.toString()}')),
                                  );
                                }
                              }
                            },
                            child: const Text('저장'),
                          ),
                          const SizedBox(width: 12),
                          TextButton(
                            onPressed: () => context.go('/property'),
                            child: const Text('취소'),
                          ),
                        ],
                      ),
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