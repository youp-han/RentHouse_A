import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:renthouse/features/settings/domain/currency.dart';
import 'package:renthouse/features/settings/application/currency_controller.dart';

class CurrencyScreen extends ConsumerWidget {
  const CurrencyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCurrency = ref.watch(currencyControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('통화 설정'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '기본 통화 선택',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '임대료, 보증금 등의 금액 표시에 사용될 기본 통화를 선택해주세요.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // 통화 선택 리스트
                  ...Currency.values.map((currency) {
                    final isSelected = selectedCurrency == currency;
                    
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4.0),
                      color: isSelected ? Theme.of(context).colorScheme.primaryContainer : null,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isSelected 
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey[400],
                          child: Text(
                            currency.symbol,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.grey[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          currency.displayName,
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        subtitle: Text('예시: ${currency.symbol}100,000'),
                        trailing: isSelected 
                          ? Icon(
                              Icons.check_circle,
                              color: Theme.of(context).colorScheme.primary,
                            )
                          : const Icon(Icons.radio_button_unchecked),
                        onTap: () {
                          ref.read(currencyControllerProvider.notifier).setCurrency(currency);
                          
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('기본 통화가 ${currency.displayName}(으)로 변경되었습니다'),
                              backgroundColor: Colors.green,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // 미리보기 카드
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '미리보기',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  
                  _buildPreviewItem('월세', selectedCurrency.symbol, '500,000'),
                  const SizedBox(height: 8),
                  _buildPreviewItem('보증금', selectedCurrency.symbol, '10,000,000'),
                  const SizedBox(height: 8),
                  _buildPreviewItem('관리비', selectedCurrency.symbol, '50,000'),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // 안내 사항
          Card(
            color: Colors.blue[50],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info, color: Colors.blue[700]),
                      const SizedBox(width: 8),
                      Text(
                        '안내사항',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '• 통화 변경은 새로 입력하는 데이터부터 적용됩니다\n'
                    '• 기존 데이터는 변경되지 않습니다\n'
                    '• 환율 계산 기능은 향후 업데이트 예정입니다',
                    style: TextStyle(color: Colors.blue[700]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewItem(String label, String symbol, String amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16),
        ),
        Text(
          '$symbol$amount',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}