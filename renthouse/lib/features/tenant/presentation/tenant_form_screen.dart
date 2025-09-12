import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:renthouse/features/tenant/application/tenant_controller.dart';
import 'package:renthouse/features/tenant/domain/tenant.dart';
import 'package:uuid/uuid.dart';
import 'package:go_router/go_router.dart';
import 'package:renthouse/features/lease/data/lease_repository.dart';

class TenantFormScreen extends ConsumerStatefulWidget {
  final Tenant? tenant;

  const TenantFormScreen({super.key, this.tenant});

  @override
  ConsumerState<TenantFormScreen> createState() => _TenantFormScreenState();
}

class _TenantFormScreenState extends ConsumerState<TenantFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _socialNoController;
  late final TextEditingController _bdayController;
  late final TextEditingController _personalNoController;
  late final TextEditingController _addressController;

  bool get _isEditing => widget.tenant != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.tenant?.name);
    _phoneController = TextEditingController(text: widget.tenant?.phone);
    _emailController = TextEditingController(text: widget.tenant?.email);
    _socialNoController = TextEditingController(text: widget.tenant?.socialNo);
    _bdayController = TextEditingController(text: widget.tenant?.bday);
    _personalNoController = TextEditingController(text: widget.tenant?.personalNo?.toString());
    _addressController = TextEditingController(text: widget.tenant?.currentAddress);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _socialNoController.dispose();
    _bdayController.dispose();
    _personalNoController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      String? bday = _bdayController.text.isNotEmpty ? _bdayController.text : null;
      int? personalNo;
      String? socialNo;
      
      // 개인번호가 입력되었으면 정수로 변환
      if (_personalNoController.text.isNotEmpty) {
        try {
          personalNo = int.parse(_personalNoController.text);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('개인번호는 숫자만 입력해주세요.')),
          );
          return;
        }
      }
      
      // 생년월일과 개인번호가 모두 있으면 원본 주민번호 재구성 (선택적)
      if (bday != null && personalNo != null) {
        socialNo = '$bday-$personalNo******'; // 표시용
      }

      final tenant = Tenant(
        id: widget.tenant?.id ?? const Uuid().v4(),
        name: _nameController.text,
        phone: _phoneController.text,
        email: _emailController.text,
        socialNo: socialNo,
        bday: bday,
        personalNo: personalNo,
        currentAddress: _addressController.text.isNotEmpty ? _addressController.text : null,
        createdAt: widget.tenant?.createdAt ?? DateTime.now(),
      );

      if (_isEditing) {
        ref.read(tenantControllerProvider.notifier).updateTenant(tenant);
      } else {
        ref.read(tenantControllerProvider.notifier).addTenant(tenant);
      }

      ref.invalidate(tenantControllerProvider); // Invalidate the provider to refresh the list
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? '임차인 수정' : '임차인 등록'),
        actions: [
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                final messenger = ScaffoldMessenger.of(context); // Get messenger before async operations
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('임차인 삭제'),
                    content: const Text('정말로 이 임차인을 삭제하시겠습니까?'),
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
                  if (!mounted) return;
                  final hasLeases = await ref.read(leaseRepositoryProvider).hasLeasesForTenant(widget.tenant!.id);
                  if (!mounted) return;

                  if (hasLeases) {
                    // Use the captured context to be safe across async gaps.
                    await showDialog<void>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('삭제 불가'),
                        content: const Text('임차인에게 연결된 계약이 있어 삭제할 수 없습니다.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('확인'),
                          ),
                        ],
                      ),
                    );
                    // Do not proceed with deletion or navigation. User remains on the form screen.
                  } else {
                    try {
                      await ref.read(tenantControllerProvider.notifier).deleteTenant(widget.tenant!.id);
                      if (!mounted) return;
                      ref.invalidate(tenantControllerProvider); // Invalidate the provider to refresh the list
                      messenger.showSnackBar( // Use the captured messenger
                        const SnackBar(content: Text('임차인이 삭제되었습니다.')),
                      );
                      context.pop(); // Go back to the previous screen after deletion
                    } catch (e) {
                      if (!mounted) return;
                      // For other errors, show a SnackBar
                      messenger.showSnackBar(
                        SnackBar(content: Text('임차인 삭제 실패: ${e.toString()}')),
                      );
                      // For other errors, still pop back to the list
                      Navigator.of(context).pop();
                    }
                  }
                }
              },
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: '이름'),
              validator: (value) => (value == null || value.isEmpty) ? '이름을 입력하세요' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: '연락처'),
              validator: (value) => (value == null || value.isEmpty) ? '연락처를 입력하세요' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: '이메일'),
              validator: (value) => (value == null || value.isEmpty) ? '이메일을 입력하세요' : null,
            ),
            const SizedBox(height: 16),
            // 주민등록번호 분리 입력
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '주민등록번호',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    // 생년월일 입력 (6자리)
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: _bdayController,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        decoration: const InputDecoration(
                          labelText: '생년월일',
                          hintText: '750331',
                          helperText: 'YYMMDD 형태',
                          counterText: '', // 글자수 카운터 숨김
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return null; // 선택적 필드
                          if (value.length != 6) {
                            return '6자리를 입력하세요';
                          }
                          if (!RegExp(r'^\d{6}$').hasMatch(value)) {
                            return '숫자만 입력하세요';
                          }
                          return null;
                        },
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                      child: Text('-', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    // 개인번호 첫자리 입력 (1자리)
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        controller: _personalNoController,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          labelText: '성별',
                          hintText: '1',
                          helperText: '1~4',
                          counterText: '', // 글자수 카운터 숨김
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return null; // 선택적 필드
                          final num = int.tryParse(value);
                          if (num == null || num < 1 || num > 4) {
                            return '1~4 입력';
                          }
                          return null;
                        },
                      ),
                    ),
                    // 마스킹된 나머지 6자리 표시
                    const Expanded(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.only(left: 4.0, top: 8.0),
                        child: Text(
                          '******',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
                if (_isEditing && widget.tenant != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      '현재: ${widget.tenant!.maskedSocialNo}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: '현재 주소'),
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
      ),
    );
  }
}
