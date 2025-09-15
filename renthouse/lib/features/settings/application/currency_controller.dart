import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:renthouse/features/settings/domain/currency.dart';

part 'currency_controller.g.dart';

@riverpod
class CurrencyController extends _$CurrencyController {
  @override
  Currency build() {
    return Currency.krw; // 기본값은 한국 원화
  }

  void setCurrency(Currency currency) {
    state = currency;
    // TODO: SharedPreferences나 데이터베이스에 저장
  }
}