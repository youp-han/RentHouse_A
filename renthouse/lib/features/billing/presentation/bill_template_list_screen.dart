import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:renthouse/features/billing/application/bill_template_controller.dart';

class BillTemplateListScreen extends ConsumerWidget {
  const BillTemplateListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final templatesAsync = ref.watch(billTemplateControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('청구 항목 템플릿')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Spacer(),
                FilledButton(
                  onPressed: () {
                    context.go('/billing/templates/new');
                  },
                  child: const Text('+ 신규 템플릿'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: templatesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('오류: $err')),
              data: (templates) => templates.isEmpty
                  ? const Center(child: Text('등록된 템플릿이 없습니다.'))
                  : ListView.builder(
                      itemCount: templates.length,
                      itemBuilder: (_, i) {
                        final template = templates[i];
                        return ListTile(
                          title: Text(template.name),
                          subtitle: Text('${template.amount}원 / ${template.category}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  context.go('/billing/templates/edit/${template.id}');
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  ref.read(billTemplateControllerProvider.notifier).deleteBillTemplate(template.id);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          )
        ],
      ),
    );
  }
}
