import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_log.freezed.dart';
part 'activity_log.g.dart';

/// 사용자 활동 로그를 나타내는 도메인 모델
@freezed
class ActivityLog with _$ActivityLog {
  const factory ActivityLog({
    required String id,
    required String userId,
    required ActivityType activityType,
    required String description,
    required String entityType,
    required String entityId,
    String? entityName,
    Map<String, dynamic>? metadata,
    required DateTime timestamp,
  }) = _ActivityLog;

  factory ActivityLog.fromJson(Map<String, dynamic> json) => 
      _$ActivityLogFromJson(json);
}

/// 활동 유형 열거형
enum ActivityType {
  create('CREATE', '생성'),
  update('UPDATE', '수정'),
  delete('DELETE', '삭제'),
  login('LOGIN', '로그인'),
  logout('LOGOUT', '로그아웃'),
  payment('PAYMENT', '수납'),
  billing('BILLING', '청구'),
  other('OTHER', '기타');

  const ActivityType(this.value, this.displayName);
  
  final String value;
  final String displayName;
}

/// 엔티티 유형 열거형
enum EntityType {
  property('PROPERTY', '자산'),
  unit('UNIT', '유닛'),
  tenant('TENANT', '임차인'),
  lease('LEASE', '임대계약'),
  billing('BILLING', '청구서'),
  payment('PAYMENT', '수납'),
  user('USER', '사용자'),
  billTemplate('BILL_TEMPLATE', '청구 템플릿'),
  other('OTHER', '기타');

  const EntityType(this.value, this.displayName);
  
  final String value;
  final String displayName;
}

/// 활동 로그 생성을 위한 헬퍼 클래스
class ActivityLogBuilder {
  static ActivityLog createProperty(String userId, String propertyId, String propertyName) {
    return ActivityLog(
      id: '', // Repository에서 UUID 생성
      userId: userId,
      activityType: ActivityType.create,
      description: '자산 "$propertyName"이(가) 등록되었습니다',
      entityType: EntityType.property.value,
      entityId: propertyId,
      entityName: propertyName,
      timestamp: DateTime.now(),
    );
  }

  static ActivityLog updateProperty(String userId, String propertyId, String propertyName) {
    return ActivityLog(
      id: '',
      userId: userId,
      activityType: ActivityType.update,
      description: '자산 "$propertyName"이(가) 수정되었습니다',
      entityType: EntityType.property.value,
      entityId: propertyId,
      entityName: propertyName,
      timestamp: DateTime.now(),
    );
  }

  static ActivityLog deleteProperty(String userId, String propertyId, String propertyName) {
    return ActivityLog(
      id: '',
      userId: userId,
      activityType: ActivityType.delete,
      description: '자산 "$propertyName"이(가) 삭제되었습니다',
      entityType: EntityType.property.value,
      entityId: propertyId,
      entityName: propertyName,
      timestamp: DateTime.now(),
    );
  }

  static ActivityLog createTenant(String userId, String tenantId, String tenantName) {
    return ActivityLog(
      id: '',
      userId: userId,
      activityType: ActivityType.create,
      description: '임차인 "$tenantName"이(가) 등록되었습니다',
      entityType: EntityType.tenant.value,
      entityId: tenantId,
      entityName: tenantName,
      timestamp: DateTime.now(),
    );
  }

  static ActivityLog updateTenant(String userId, String tenantId, String tenantName) {
    return ActivityLog(
      id: '',
      userId: userId,
      activityType: ActivityType.update,
      description: '임차인 "$tenantName"이(가) 수정되었습니다',
      entityType: EntityType.tenant.value,
      entityId: tenantId,
      entityName: tenantName,
      timestamp: DateTime.now(),
    );
  }

  static ActivityLog deleteTenant(String userId, String tenantId, String tenantName) {
    return ActivityLog(
      id: '',
      userId: userId,
      activityType: ActivityType.delete,
      description: '임차인 "$tenantName"이(가) 삭제되었습니다',
      entityType: EntityType.tenant.value,
      entityId: tenantId,
      entityName: tenantName,
      timestamp: DateTime.now(),
    );
  }

  static ActivityLog createLease(String userId, String leaseId, String unitName) {
    return ActivityLog(
      id: '',
      userId: userId,
      activityType: ActivityType.create,
      description: '임대계약 "$unitName"이(가) 체결되었습니다',
      entityType: EntityType.lease.value,
      entityId: leaseId,
      entityName: unitName,
      timestamp: DateTime.now(),
    );
  }

  static ActivityLog updateLease(String userId, String leaseId, String unitName) {
    return ActivityLog(
      id: '',
      userId: userId,
      activityType: ActivityType.update,
      description: '임대계약 "$unitName"이(가) 수정되었습니다',
      entityType: EntityType.lease.value,
      entityId: leaseId,
      entityName: unitName,
      timestamp: DateTime.now(),
    );
  }

  static ActivityLog createBilling(String userId, String billingId, String yearMonth) {
    return ActivityLog(
      id: '',
      userId: userId,
      activityType: ActivityType.billing,
      description: '$yearMonth 청구서가 발행되었습니다',
      entityType: EntityType.billing.value,
      entityId: billingId,
      entityName: yearMonth,
      timestamp: DateTime.now(),
    );
  }

  static ActivityLog createPayment(String userId, String paymentId, int amount, String tenantName) {
    return ActivityLog(
      id: '',
      userId: userId,
      activityType: ActivityType.payment,
      description: '$tenantName님으로부터 ${amount.toString()}원이 수납되었습니다',
      entityType: EntityType.payment.value,
      entityId: paymentId,
      entityName: tenantName,
      metadata: {'amount': amount},
      timestamp: DateTime.now(),
    );
  }

  static ActivityLog userLogin(String userId, String userName) {
    return ActivityLog(
      id: '',
      userId: userId,
      activityType: ActivityType.login,
      description: '$userName님이 로그인했습니다',
      entityType: EntityType.user.value,
      entityId: userId,
      entityName: userName,
      timestamp: DateTime.now(),
    );
  }

  static ActivityLog userLogout(String userId, String userName) {
    return ActivityLog(
      id: '',
      userId: userId,
      activityType: ActivityType.logout,
      description: '$userName님이 로그아웃했습니다',
      entityType: EntityType.user.value,
      entityId: userId,
      entityName: userName,
      timestamp: DateTime.now(),
    );
  }

  static ActivityLog bulkBillingCreate(String userId, int count, String yearMonth) {
    return ActivityLog(
      id: '',
      userId: userId,
      activityType: ActivityType.billing,
      description: '$yearMonth $count건의 청구서가 일괄 생성되었습니다',
      entityType: EntityType.billing.value,
      entityId: 'bulk_$yearMonth',
      entityName: '일괄 청구',
      metadata: {'count': count, 'yearMonth': yearMonth},
      timestamp: DateTime.now(),
    );
  }
}