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
    String? itemName, // 템플릿 이름을 직접 저장 (템플릿을 찾을 수 없을 때 사용)
  }) = _BillingItem;

  factory BillingItem.fromJson(Map<String, dynamic> json) => _$BillingItemFromJson(json);
}
