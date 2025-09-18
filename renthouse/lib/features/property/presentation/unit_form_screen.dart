import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:renthouse/features/property/data/property_repository.dart';
import 'package:renthouse/features/property/domain/unit.dart';
import 'package:uuid/uuid.dart';

class UnitFormScreen extends ConsumerStatefulWidget {
  final String propertyId;
  final String? unitId;

  const UnitFormScreen({super.key, required this.propertyId, this.unitId});

  @override
  ConsumerState<UnitFormScreen> createState() => _UnitFormScreenState();
}

class _UnitFormScreenState extends ConsumerState<UnitFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _unitNumberController = TextEditingController();
  final _useTypeController = TextEditingController();
  final _sizeMeterController = TextEditingController();
  final _sizeKoreaController = TextEditingController();
  final _descriptionController = TextEditingController();

  final Uuid _uuid = const Uuid();
  Unit? _existingUnit;
  RentStatus _selectedRentStatus = RentStatus.vacant;

  bool get _isEditMode => widget.unitId != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      // Fetch the existing unit data
      ref.read(propertyDetailProvider(widget.propertyId).future).then((property) {
        if (property != null) {
          final unit = property.units.firstWhereOrNull((u) => u.id == widget.unitId);
          if (unit != null) {
            setState(() {
              _existingUnit = unit;
              _unitNumberController.text = unit.unitNumber;
              _selectedRentStatus = unit.rentStatus;
              _useTypeController.text = unit.useType;
              _sizeMeterController.text = unit.sizeMeter.toString();
              _sizeKoreaController.text = unit.sizeKorea.toString();
              _descriptionController.text = unit.description ?? '';
            });
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _unitNumberController.dispose();
    _useTypeController.dispose();
    _sizeMeterController.dispose();
    _sizeKoreaController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.read(propertyRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? '유닛 수정' : '유닛 추가'),
        actions: [
          if (_isEditMode)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('유닛 삭제'),
                    content: const Text('정말로 이 유닛을 삭제하시겠습니까?'),
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
                  try {
                    await repo.deleteUnit(widget.unitId!);
                    ref.invalidate(propertyDetailProvider(widget.propertyId));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('유닛이 삭제되었습니다.')),
                    );
                    context.pop();
                  } catch (e) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('유닛 삭제 실패: ${e.toString()}')),
                    );
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
              controller: _unitNumberController,
              decoration: const InputDecoration(labelText: '호수'),
              validator: (v) => (v == null || v.isEmpty) ? '호수는 필수입니다.' : null,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<RentStatus>(
              initialValue: _selectedRentStatus,
              decoration: const InputDecoration(
                labelText: '임대 상태',
                border: OutlineInputBorder(),
              ),
              items: RentStatus.values.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(status.displayName),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedRentStatus = value;
                  });
                }
              },
              validator: (value) {
                if (value == null) {
                  return '임대 상태를 선택해주세요';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _useTypeController,
              decoration: const InputDecoration(labelText: '용도'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _sizeMeterController,
                    decoration: const InputDecoration(labelText: '면적(m²)'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: _sizeKoreaController,
                    decoration: const InputDecoration(labelText: '면적(평)'),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: '설명'),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                FilledButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        final unit = Unit(
                          id: _isEditMode ? _existingUnit!.id : _uuid.v4(),
                          propertyId: widget.propertyId,
                          unitNumber: _unitNumberController.text,
                          rentStatus: _selectedRentStatus,
                          useType: _useTypeController.text,
                          sizeMeter: double.tryParse(_sizeMeterController.text) ?? 0.0,
                          sizeKorea: double.tryParse(_sizeKoreaController.text) ?? 0.0,
                          description: _descriptionController.text,
                        );

                        if (_isEditMode) {
                          await repo.updateUnit(unit);
                        } else {
                          await repo.addUnit(unit);
                        }

                        if (!mounted) return;
                        // Invalidate provider to refetch
                        ref.invalidate(propertyDetailProvider(widget.propertyId));

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('유닛이 저장되었습니다.')),
                        );
                        context.pop(); // Go back to the management screen
                      } catch (e) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('저장 실패: ${e.toString()}')),
                        );
                      }
                    }
                  },
                  child: const Text('저장'),
                ),
                const SizedBox(width: 12),
                TextButton(
                  onPressed: () => context.pop(),
                  child: const Text('취소'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}