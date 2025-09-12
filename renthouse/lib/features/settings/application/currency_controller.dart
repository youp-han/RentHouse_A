import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:renthouse/features/settings/domain/currency.dart';

// 통화 설정 상태 관리
final currencySettingProvider = StateNotifierProvider<CurrencyNotifier, Currency>((ref) {
  return CurrencyNotifier();
});

class CurrencyNotifier extends StateNotifier<Currency> {
  CurrencyNotifier() : super(Currency.krw); // 기본값은 한국 원화

  void setCurrency(Currency currency) {
    state = currency;
    // TODO: SharedPreferences나 데이터베이스에 저장
  }
}