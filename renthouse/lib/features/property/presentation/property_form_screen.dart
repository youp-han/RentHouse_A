import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:renthouse/features/property/application/property_controller.dart';
import 'package:renthouse/features/property/data/property_repository.dart'; // Import PropertyRepository
import 'package:renthouse/features/property/domain/property.dart';

class PropertyFormScreen extends ConsumerStatefulWidget {
  const PropertyFormScreen({super.key});
  @override
  ConsumerState<PropertyFormScreen> createState() => _PropertyFormScreenState();
}

class _PropertyFormScreenState extends ConsumerState<PropertyFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _typeController = TextEditingController();
  final _totalFloorsController = TextEditingController();
  final _totalUnitsController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _typeController.dispose();
    _totalFloorsController.dispose();
    _totalUnitsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final propertyRepository = ref.read(propertyRepositoryProvider); // Get PropertyRepository
    final propertyListController = ref.read(propertyListControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('자산 등록')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: '이름'),
              validator: (v) => (v == null || v.isEmpty) ? '이름은 필수입니다' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: '주소'),
              validator: (v) => (v == null || v.isEmpty) ? '주소는 필수입니다' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _typeController,
              decoration: const InputDecoration(labelText: '유형'),
              validator: (v) => (v == null || v.isEmpty) ? '유형은 필수입니다' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _totalFloorsController,
              decoration: const InputDecoration(labelText: '총 층수'),
              keyboardType: TextInputType.number,
              validator: (v) => (v == null || int.tryParse(v) == null) ? '유효한 숫자를 입력해주세요' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _totalUnitsController,
              decoration: const InputDecoration(labelText: '총 유닛 수'),
              keyboardType: TextInputType.number,
              validator: (v) => (v == null || int.tryParse(v) == null) ? '유효한 숫자를 입력해주세요' : null,
            ),
            const SizedBox(height: 24),
            Row(children: [
              FilledButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final newProperty = Property(
                      id: DateTime.now().millisecondsSinceEpoch.toString(), // 임시 ID
                      name: _nameController.text,
                      address: _addressController.text,
                      type: _typeController.text,
                      totalFloors: int.parse(_totalFloorsController.text),
                      totalUnits: int.parse(_totalUnitsController.text),
                      units: [],
                    );
                    try {
                      // Call createProperty from repository
                      await propertyRepository.createProperty(newProperty);
                      // Refresh the list after creation
                      await propertyListController.refreshProperties();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('자산이 성공적으로 저장되었습니다.')),
                      );
                      context.go('/property'); // 저장 후 목록으로 이동
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('자산 저장 실패: ${e.toString()}')),
                      );
                    }
                  }
                },
                child: const Text('저장'),
              ),
              const SizedBox(width: 12),
              TextButton(onPressed: () => context.go('/property'), child: const Text('취소')),
            ])
          ],
        ),
      ),
    );
  }
}
