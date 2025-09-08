import 'package:freezed_annotation/freezed_annotation.dart';

part 'bill_template.freezed.dart';
part 'bill_template.g.dart';

@freezed
class BillTemplate with _$BillTemplate {
  const factory BillTemplate({
    required String id,
    required String name,
    required String category,
    required int amount,
    String? description,
  }) = _BillTemplate;

  factory BillTemplate.fromJson(Map<String, dynamic> json) => _$BillTemplateFromJson(json);
}
