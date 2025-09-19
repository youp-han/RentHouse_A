import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:renthouse/features/activity/data/activity_log_repository.dart';
import 'package:renthouse/features/activity/domain/activity_log.dart';
import 'package:renthouse/features/auth/application/auth_controller.dart';

part 'activity_log_service.g.dart';

@riverpod
ActivityLogService activityLogService(Ref ref) {
  final repository = ref.watch(activityLogRepositoryProvider);
  return ActivityLogService(repository, ref);
}

class ActivityLogService {
  final ActivityLogRepository _repository;
  final Ref _ref;

  ActivityLogService(this._repository, this._ref);

  /// 현재 로그인한 사용자 ID 가져오기
  String? get _currentUserId {
    final authState = _ref.read(authControllerProvider);
    print('[ActivityLogService] AuthState: ${authState.runtimeType}');

    // AsyncValue에서 데이터를 가져오되, loading 상태에서도 임시로 하드코딩된 사용자 ID 사용
    final userId = authState.when(
      data: (user) {
        print('[ActivityLogService] User data: ${user?.id}');
        return user?.id;
      },
      loading: () {
        print('[ActivityLogService] Auth loading - using fallback user ID');
        final fallbackId = 'e663dd45-d8b4-429d-893d-201fa9df3467';
        print('[ActivityLogService] Fallback user ID: $fallbackId');
        return fallbackId;
      },
      error: (error, stackTrace) {
        print('[ActivityLogService] Auth error: $error');
        return null;
      },
    );

    print('[ActivityLogService] Final user ID: $userId');
    return userId;
  }

  /// 활동 로그 기록 (헬퍼 메서드)
  Future<void> _logActivity(ActivityLog activityLog) async {
    try {
      print('[ActivityLogService] 활동 로그 기록 시작: ${activityLog.description}');
      print('[ActivityLogService] 사용자 ID: ${activityLog.userId}');
      await _repository.addActivityLog(activityLog);
      print('[ActivityLogService] 활동 로그 기록 완료');
    } catch (e) {
      // 로깅 실패는 사용자 경험에 영향을 주지 않도록 조용히 처리
      print('[ActivityLogService] Activity logging failed: $e');
    }
  }

  /// 자산 관련 활동 로그
  Future<void> logPropertyCreated(String propertyId, String propertyName) async {
    if (_currentUserId == null) return;
    
    final log = ActivityLogBuilder.createProperty(_currentUserId!, propertyId, propertyName);
    await _logActivity(log);
  }

  Future<void> logPropertyUpdated(String propertyId, String propertyName) async {
    if (_currentUserId == null) return;
    
    final log = ActivityLogBuilder.updateProperty(_currentUserId!, propertyId, propertyName);
    await _logActivity(log);
  }

  Future<void> logPropertyDeleted(String propertyId, String propertyName) async {
    if (_currentUserId == null) return;
    
    final log = ActivityLogBuilder.deleteProperty(_currentUserId!, propertyId, propertyName);
    await _logActivity(log);
  }

  /// 임차인 관련 활동 로그
  Future<void> logTenantCreated(String tenantId, String tenantName) async {
    if (_currentUserId == null) return;
    
    final log = ActivityLogBuilder.createTenant(_currentUserId!, tenantId, tenantName);
    await _logActivity(log);
  }

  Future<void> logTenantUpdated(String tenantId, String tenantName) async {
    if (_currentUserId == null) return;
    
    final log = ActivityLogBuilder.updateTenant(_currentUserId!, tenantId, tenantName);
    await _logActivity(log);
  }

  Future<void> logTenantDeleted(String tenantId, String tenantName) async {
    if (_currentUserId == null) return;
    
    final log = ActivityLogBuilder.deleteTenant(_currentUserId!, tenantId, tenantName);
    await _logActivity(log);
  }

  /// 임대계약 관련 활동 로그
  Future<void> logLeaseCreated(String leaseId, String unitName) async {
    if (_currentUserId == null) return;
    
    final log = ActivityLogBuilder.createLease(_currentUserId!, leaseId, unitName);
    await _logActivity(log);
  }

  Future<void> logLeaseUpdated(String leaseId, String unitName) async {
    if (_currentUserId == null) return;
    
    final log = ActivityLogBuilder.updateLease(_currentUserId!, leaseId, unitName);
    await _logActivity(log);
  }

  /// 청구서 관련 활동 로그
  Future<void> logBillingCreated(String billingId, String yearMonth) async {
    if (_currentUserId == null) return;
    
    final log = ActivityLogBuilder.createBilling(_currentUserId!, billingId, yearMonth);
    await _logActivity(log);
  }

  Future<void> logBulkBillingCreated(int count, String yearMonth) async {
    print('[ActivityLogService] logBulkBillingCreated 호출됨');
    final userId = _currentUserId;
    print('[ActivityLogService] 현재 사용자 ID: $userId');

    if (userId == null) {
      print('[ActivityLogService] 사용자 ID가 null이므로 로그 기록 건너뜀');
      return;
    }

    print('[ActivityLogService] ActivityLogBuilder.bulkBillingCreate 호출');
    final log = ActivityLogBuilder.bulkBillingCreate(userId, count, yearMonth);
    print('[ActivityLogService] 생성된 로그: ${log.description}');
    await _logActivity(log);
    print('[ActivityLogService] logBulkBillingCreated 완료');
  }

  /// 수납 관련 활동 로그
  Future<void> logPaymentCreated(String paymentId, int amount, String tenantName) async {
    if (_currentUserId == null) return;
    
    final log = ActivityLogBuilder.createPayment(_currentUserId!, paymentId, amount, tenantName);
    await _logActivity(log);
  }

  /// 인증 관련 활동 로그
  Future<void> logUserLogin(String userName) async {
    if (_currentUserId == null) return;
    
    final log = ActivityLogBuilder.userLogin(_currentUserId!, userName);
    await _logActivity(log);
  }

  Future<void> logUserLogout(String userName) async {
    if (_currentUserId == null) return;
    
    final log = ActivityLogBuilder.userLogout(_currentUserId!, userName);
    await _logActivity(log);
  }

  /// 사용자 정의 활동 로그
  Future<void> logCustomActivity({
    required ActivityType activityType,
    required String description,
    required String entityType,
    required String entityId,
    String? entityName,
    Map<String, dynamic>? metadata,
  }) async {
    if (_currentUserId == null) return;

    final log = ActivityLog(
      id: '', // Repository에서 UUID 생성
      userId: _currentUserId!,
      activityType: activityType,
      description: description,
      entityType: entityType,
      entityId: entityId,
      entityName: entityName,
      metadata: metadata,
      timestamp: DateTime.now(),
    );

    await _logActivity(log);
  }

  /// 최근 활동 로그 조회
  Future<List<ActivityLog>> getRecentActivityLogs({int limit = 50}) async {
    return await _repository.getRecentActivityLogs(limit: limit);
  }

  /// 현재 사용자의 활동 로그 조회
  Future<List<ActivityLog>> getCurrentUserActivityLogs() async {
    if (_currentUserId == null) return [];
    return await _repository.getActivityLogsByUser(_currentUserId!);
  }

  /// 특정 엔티티의 활동 로그 조회
  Future<List<ActivityLog>> getEntityActivityLogs(String entityType, String entityId) async {
    return await _repository.getActivityLogsByEntity(entityType, entityId);
  }

  /// 활동 통계 조회
  Future<Map<String, int>> getActivityStats() async {
    return await _repository.getActivityTypeStats();
  }

  /// 오래된 로그 정리 (30일 이전)
  Future<void> cleanupOldLogs() async {
    await _repository.cleanupOldLogs();
  }

  /// 활동 로그 기반 대시보드 데이터 생성
  Future<Map<String, dynamic>> getDashboardActivityData() async {
    final recentLogs = await getRecentActivityLogs(limit: 20);
    final stats = await getActivityStats();
    
    return {
      'recentActivities': recentLogs.map((log) => {
        'id': log.id,
        'type': log.activityType.displayName,
        'description': log.description,
        'entityName': log.entityName,
        'timestamp': log.timestamp.toIso8601String(),
        'timeAgo': _getTimeAgo(log.timestamp),
      }).toList(),
      'activityStats': stats,
      'totalActivities': recentLogs.length,
    };
  }

  /// 시간 경과 표시 헬퍼
  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return '방금 전';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}분 전';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}시간 전';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}일 전';
    } else {
      return '${timestamp.month}/${timestamp.day}';
    }
  }
}