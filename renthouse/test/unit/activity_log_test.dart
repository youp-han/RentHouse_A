import 'package:flutter_test/flutter_test.dart';
import 'package:renthouse/features/activity/domain/activity_log.dart';

void main() {
  group('ActivityLog Domain Model Tests', () {
    test('ActivityLog model should create with valid data', () {
      // Arrange
      final timestamp = DateTime.now();
      final activityLog = ActivityLog(
        id: 'log_001',
        userId: 'user_001',
        activityType: ActivityType.create,
        description: '새로운 자산이 등록되었습니다',
        entityType: 'PROPERTY',
        entityId: 'prop_001',
        entityName: '테스트 빌딩',
        metadata: {'location': 'Seoul'},
        timestamp: timestamp,
      );

      // Assert
      expect(activityLog.id, 'log_001');
      expect(activityLog.userId, 'user_001');
      expect(activityLog.activityType, ActivityType.create);
      expect(activityLog.description, '새로운 자산이 등록되었습니다');
      expect(activityLog.entityType, 'PROPERTY');
      expect(activityLog.entityId, 'prop_001');
      expect(activityLog.entityName, '테스트 빌딩');
      expect(activityLog.metadata, {'location': 'Seoul'});
      expect(activityLog.timestamp, timestamp);
    });

    test('ActivityType enum should have correct values and display names', () {
      expect(ActivityType.create.value, 'CREATE');
      expect(ActivityType.create.displayName, '생성');
      
      expect(ActivityType.update.value, 'UPDATE');
      expect(ActivityType.update.displayName, '수정');
      
      expect(ActivityType.delete.value, 'DELETE');
      expect(ActivityType.delete.displayName, '삭제');
      
      expect(ActivityType.login.value, 'LOGIN');
      expect(ActivityType.login.displayName, '로그인');
      
      expect(ActivityType.logout.value, 'LOGOUT');
      expect(ActivityType.logout.displayName, '로그아웃');
      
      expect(ActivityType.payment.value, 'PAYMENT');
      expect(ActivityType.payment.displayName, '수납');
      
      expect(ActivityType.billing.value, 'BILLING');
      expect(ActivityType.billing.displayName, '청구');
      
      expect(ActivityType.other.value, 'OTHER');
      expect(ActivityType.other.displayName, '기타');
    });

    test('EntityType enum should have correct values and display names', () {
      expect(EntityType.property.value, 'PROPERTY');
      expect(EntityType.property.displayName, '자산');
      
      expect(EntityType.unit.value, 'UNIT');
      expect(EntityType.unit.displayName, '유닛');
      
      expect(EntityType.tenant.value, 'TENANT');
      expect(EntityType.tenant.displayName, '임차인');
      
      expect(EntityType.lease.value, 'LEASE');
      expect(EntityType.lease.displayName, '임대계약');
      
      expect(EntityType.billing.value, 'BILLING');
      expect(EntityType.billing.displayName, '청구서');
      
      expect(EntityType.payment.value, 'PAYMENT');
      expect(EntityType.payment.displayName, '수납');
      
      expect(EntityType.user.value, 'USER');
      expect(EntityType.user.displayName, '사용자');
      
      expect(EntityType.billTemplate.value, 'BILL_TEMPLATE');
      expect(EntityType.billTemplate.displayName, '청구 템플릿');
      
      expect(EntityType.other.value, 'OTHER');
      expect(EntityType.other.displayName, '기타');
    });

    test('ActivityLogBuilder should create correct logs for different activities', () {
      // Test property creation
      final propertyLog = ActivityLogBuilder.createProperty('user_001', 'prop_001', '테스트 빌딩');
      expect(propertyLog.activityType, ActivityType.create);
      expect(propertyLog.entityType, EntityType.property.value);
      expect(propertyLog.description, '자산 "테스트 빌딩"이(가) 등록되었습니다');

      // Test tenant update
      final tenantLog = ActivityLogBuilder.updateTenant('user_001', 'tenant_001', '김테스트');
      expect(tenantLog.activityType, ActivityType.update);
      expect(tenantLog.entityType, EntityType.tenant.value);
      expect(tenantLog.description, '임차인 "김테스트"이(가) 수정되었습니다');

      // Test payment creation
      final paymentLog = ActivityLogBuilder.createPayment('user_001', 'payment_001', 500000, '김테스트');
      expect(paymentLog.activityType, ActivityType.payment);
      expect(paymentLog.entityType, EntityType.payment.value);
      expect(paymentLog.description, '김테스트님으로부터 500000원이 수납되었습니다');

      // Test user login
      final loginLog = ActivityLogBuilder.userLogin('user_001', '김사용자');
      expect(loginLog.activityType, ActivityType.login);
      expect(loginLog.entityType, EntityType.user.value);
      expect(loginLog.description, '김사용자님이 로그인했습니다');

      // Test bulk billing
      final bulkBillingLog = ActivityLogBuilder.bulkBillingCreate('user_001', 15, '2024-03');
      expect(bulkBillingLog.activityType, ActivityType.billing);
      expect(bulkBillingLog.entityType, EntityType.billing.value);
      expect(bulkBillingLog.description, '2024-03 15건의 청구서가 일괄 생성되었습니다');
    });

    test('ActivityLog copyWith should update specified fields', () {
      // Arrange
      final timestamp = DateTime.now();
      final originalLog = ActivityLog(
        id: 'log_001',
        userId: 'user_001',
        activityType: ActivityType.create,
        description: '원본 설명',
        entityType: 'PROPERTY',
        entityId: 'prop_001',
        entityName: '원본 빌딩',
        metadata: {'location': 'Seoul'},
        timestamp: timestamp,
      );

      // Act
      final updatedLog = originalLog.copyWith(
        description: '수정된 설명',
        entityName: '수정된 빌딩',
      );

      // Assert
      expect(updatedLog.description, '수정된 설명');
      expect(updatedLog.entityName, '수정된 빌딩');
      expect(updatedLog.id, originalLog.id); // 변경되지 않은 필드는 유지
      expect(updatedLog.activityType, originalLog.activityType);
    });

    test('ActivityLog should handle null metadata and entityName', () {
      // Arrange
      final timestamp = DateTime.now();
      final activityLog = ActivityLog(
        id: 'log_001',
        userId: 'user_001',
        activityType: ActivityType.create,
        description: '새로운 자산이 등록되었습니다',
        entityType: 'PROPERTY',
        entityId: 'prop_001',
        entityName: null,
        metadata: null,
        timestamp: timestamp,
      );

      // Assert
      expect(activityLog.entityName, null);
      expect(activityLog.metadata, null);
    });
  });
}