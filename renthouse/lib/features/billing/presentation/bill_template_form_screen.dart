import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:renthouse/features/billing/application/bill_template_controller.dart';
import 'package:renthouse/features/billing/domain/bill_template.dart';
import 'package:uuid/uuid.dart';

class BillTemplateFormScreen extends ConsumerStatefulWidget {
  final BillTemplate? template;

  const BillTemplateFormScreen({super.key, this.template});

  @override
  ConsumerState<BillTemplateFormScreen> createState() => _BillTemplateFormScreenState();
}

class _BillTemplateFormScreenState extends ConsumerState<BillTemplateFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _categoryController;
  late final TextEditingController _amountController;
  late final TextEditingController _descriptionController;

  bool get _isEditing => widget.template != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.template?.name);
    _categoryController = TextEditingController(text: widget.template?.category);
    _amountController = TextEditingController(text: widget.template?.amount.toString());
    _descriptionController = TextEditingController(text: widget.template?.description);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final template = BillTemplate(
        id: widget.template?.id ?? const Uuid().v4(),
        name: _nameController.text,
        category: _categoryController.text,
        amount: int.parse(_amountController.text),
        description: _descriptionController.text,
      );

      if (_isEditing) {
        ref.read(billTemplateControllerProvider.notifier).updateBillTemplate(template);
      } else {
        ref.read(billTemplateControllerProvider.notifier).addBillTemplate(template);
      }

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? '템플릿 수정' : '템플릿 등록'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: '항목명'),
              validator: (value) => (value == null || value.isEmpty) ? '항목명을 입력하세요' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _categoryController,
              decoration: const InputDecoration(labelText: '카테고리'),
              validator: (value) => (value == null || value.isEmpty) ? '카테고리를 입력하세요' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: '금액'),
              keyboardType: TextInputType.number,
              validator: (value) => (value == null || value.isEmpty) ? '금액을 입력하세요' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: '설명'),
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
      ),
    );
  }
}
