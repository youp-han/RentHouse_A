import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:renthouse/features/tenant/application/tenant_controller.dart';
import 'package:renthouse/features/tenant/domain/tenant.dart';
import 'package:uuid/uuid.dart';

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

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? '임차인 수정' : '임차인 등록'),
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
