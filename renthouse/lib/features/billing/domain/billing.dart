import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:renthouse/features/billing/domain/billing_item.dart';

part 'billing.freezed.dart';
part 'billing.g.dart';

@freezed
class Billing with _$Billing {
  const factory Billing({
    required String id,
    required String leaseId,
    required String yearMonth,
    required DateTime issueDate,
    required DateTime dueDate,
    @Default(false) bool paid,
    DateTime? paidDate,
    required int totalAmount,
    @Default([]) List<BillingItem> items,
  }) = _Billing;

  factory Billing.fromJson(Map<String, dynamic> json) => _$BillingFromJson(json);
}
