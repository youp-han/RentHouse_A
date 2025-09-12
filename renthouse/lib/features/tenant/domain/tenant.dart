import 'package:freezed_annotation/freezed_annotation.dart';

part 'tenant.freezed.dart';
part 'tenant.g.dart';

@freezed
class Tenant with _$Tenant {
  const factory Tenant({
    required String id,
    required String name,
    required String phone,
    required String email,
    String? socialNo,
    String? bday, // 생년월일 (YYMMDD 형태)
    int? personalNo, // 주민등록번호 뒷자리 첫번째 숫자
    String? currentAddress,
    required DateTime createdAt,
  }) = _Tenant;

  const Tenant._();

  factory Tenant.fromJson(Map<String, dynamic> json) => _$TenantFromJson(json);

  /// 주민등록번호 마스킹 처리 (예: 750331-1******)
  String get maskedSocialNo {
    if (bday == null || personalNo == null) {
      return socialNo != null ? '${socialNo!.substring(0, 8)}******' : '정보 없음';
    }
    return '$bday-$personalNo******';
  }

  /// 주민등록번호 분리 저장을 위한 파싱 유틸리티
  static Map<String, dynamic> parseSocialNo(String socialNo) {
    if (socialNo.length != 13 && socialNo.length != 14) {
      throw FormatException('주민등록번호 형식이 올바르지 않습니다.');
    }
    
    // 하이픈 제거
    final cleanedSocialNo = socialNo.replaceAll('-', '');
    if (cleanedSocialNo.length != 13) {
      throw FormatException('주민등록번호는 13자리여야 합니다.');
    }
    
    final bday = cleanedSocialNo.substring(0, 6); // 앞 6자리 (YYMMDD)
    final personalNo = int.parse(cleanedSocialNo.substring(6, 7)); // 뒷자리 첫번째 숫자
    
    return {
      'bday': bday,
      'personalNo': personalNo,
      'socialNo': socialNo, // 원본도 보존
    };
  }
}
