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
  late final TextEditingController _addressController;

  bool get _isEditing => widget.tenant != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.tenant?.name);
    _phoneController = TextEditingController(text: widget.tenant?.phone);
    _emailController = TextEditingController(text: widget.tenant?.email);
    _socialNoController = TextEditingController(text: widget.tenant?.socialNo);
    _addressController = TextEditingController(text: widget.tenant?.currentAddress);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _socialNoController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final tenant = Tenant(
        id: widget.tenant?.id ?? const Uuid().v4(),
        name: _nameController.text,
        phone: _phoneController.text,
        email: _emailController.text,
        socialNo: _socialNoController.text,
        currentAddress: _addressController.text,
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
                  final hasLeases = await ref.read(leaseRepositoryProvider).hasLeasesForTenant(widget.tenant!.id);
                  if (hasLeases) {
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
                      ref.invalidate(tenantControllerProvider); // Invalidate the provider to refresh the list
                      messenger.showSnackBar( // Use the captured messenger
                        const SnackBar(content: Text('임차인이 삭제되었습니다.')),
                      );
                      context.pop(); // Go back to the previous screen after deletion
                    } catch (e) {
                      print('Tenant deletion error: ${e.toString()}'); // Debug print
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
            TextFormField(
              controller: _socialNoController,
              decoration: const InputDecoration(labelText: '주민등록번호'),
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
