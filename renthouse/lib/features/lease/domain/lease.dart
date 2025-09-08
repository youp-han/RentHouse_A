import 'package:freezed_annotation/freezed_annotation.dart';

part 'lease.freezed.dart';
part 'lease.g.dart';

enum LeaseType { residential, commercial }

enum LeaseStatus { active, terminated, expired, pending }

@freezed
class Lease with _$Lease {
  const factory Lease({
    required String id,
    required String tenantId,
    required String unitId,
    required DateTime startDate,
    required DateTime endDate,
    required int deposit,
    required int monthlyRent,
    required LeaseType leaseType,
    required LeaseStatus leaseStatus,
    String? contractNotes,
  }) = _Lease;

  factory Lease.fromJson(Map<String, dynamic> json) => _$LeaseFromJson(json);
}
