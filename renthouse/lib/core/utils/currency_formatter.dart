import 'package:intl/intl.dart';
import 'package:renthouse/features/settings/domain/currency.dart';

class CurrencyFormatter {
  static String format(int amount, Currency currency) {
    final formatter = NumberFormat('#,###');
    return '${currency.symbol}${formatter.format(amount)}';
  }

  static String formatDouble(double amount, Currency currency) {
    final formatter = NumberFormat('#,###.##');
    return '${currency.symbol}${formatter.format(amount)}';
  }

  // 기본 원화 포맷 (기존 호환성을 위해)
  static String formatKRW(int amount) {
    return format(amount, Currency.krw);
  }

  static String formatDoubleKRW(double amount) {
    return formatDouble(amount, Currency.krw);
  }
}