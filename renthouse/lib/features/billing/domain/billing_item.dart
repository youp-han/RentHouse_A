import 'package:freezed_annotation/freezed_annotation.dart';

part 'billing_item.freezed.dart';
part 'billing_item.g.dart';

@freezed
class BillingItem with _$BillingItem {
  const factory BillingItem({
    required String id,
    required String billingId,
    required String billTemplateId,
    required int amount,
  }) = _BillingItem;

  factory BillingItem.fromJson(Map<String, dynamic> json) => _$BillingItemFromJson(json);
}
