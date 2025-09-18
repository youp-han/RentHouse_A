import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:renthouse/core/logging/app_logger.dart';

/// 메모리 관리 유틸리티 클래스
class MemoryManager {
  static Timer? _memoryCheckTimer;
  static const Duration _checkInterval = Duration(minutes: 5);
  
  /// 메모리 모니터링 시작
  static void startMemoryMonitoring() {
    if (kDebugMode) {
      _memoryCheckTimer?.cancel();
      _memoryCheckTimer = Timer.periodic(_checkInterval, (_) {
        _checkMemoryUsage();
      });
      AppLogger.info('메모리 모니터링 시작', tag: 'Performance');
    }
  }

  /// 메모리 모니터링 중지
  static void stopMemoryMonitoring() {
    _memoryCheckTimer?.cancel();
    _memoryCheckTimer = null;
    AppLogger.info('메모리 모니터링 중지', tag: 'Performance');
  }

  /// 수동 가비지 컬렉션 실행
  static void forceGarbageCollection() {
    if (kDebugMode) {
      // Flutter의 가비지 컬렉션은 VM에서 자동으로 처리되므로
      // 개발 모드에서만 명시적으로 요청
      AppLogger.info('가비지 컬렉션 요청', tag: 'Performance');
    }
  }

  /// 메모리 정리 (큰 데이터 구조 해제)
  static void clearCaches() {
    // 이미지 캐시 정리
    PaintingBinding.instance.imageCache.clear();
    
    // 시스템 메모리 압박 시 가비지 컬렉션 요청
    // (실제 시스템 호출은 플랫폼별로 구현 필요)
    
    AppLogger.info('캐시 정리 완료', tag: 'Performance');
  }

  /// 메모리 사용량 체크 (개발 모드에서만)
  static void _checkMemoryUsage() {
    if (kDebugMode) {
      final imageCache = PaintingBinding.instance.imageCache;
      final imageCacheSize = imageCache.currentSizeBytes;
      final imageCacheCount = imageCache.currentSize;
      
      AppLogger.info(
        '메모리 상태 점검',
        tag: 'Performance',
        details: {
          'imageCacheSize': '${(imageCacheSize / 1024 / 1024).toStringAsFixed(2)} MB',
          'imageCacheCount': imageCacheCount,
        },
      );

      // 이미지 캐시가 너무 클 경우 정리
      if (imageCacheSize > 100 * 1024 * 1024) { // 100MB 초과시
        AppLogger.warning('이미지 캐시 크기 초과, 정리 실행', tag: 'Performance');
        imageCache.clear();
      }
    }
  }
}

/// 리스트 성능 최적화 믹스인
mixin ListPerformanceMixin {
  /// ListView.builder 최적화 설정
  static const int defaultCacheExtent = 250;
  static const bool defaultAddAutomaticKeepAlives = false;
  static const bool defaultAddRepaintBoundaries = true;
  static const bool defaultAddSemanticIndexes = true;

  /// 큰 리스트를 위한 최적화된 ListView.builder 생성
  Widget buildOptimizedListView({
    required int itemCount,
    required Widget Function(BuildContext, int) itemBuilder,
    ScrollController? controller,
    bool shrinkWrap = false,
    ScrollPhysics? physics,
    double? cacheExtent = 250.0,
    bool addAutomaticKeepAlives = defaultAddAutomaticKeepAlives,
    bool addRepaintBoundaries = defaultAddRepaintBoundaries,
    bool addSemanticIndexes = defaultAddSemanticIndexes,
  }) {
    return ListView.builder(
      controller: controller,
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      shrinkWrap: shrinkWrap,
      physics: physics,
      cacheExtent: cacheExtent,
      addAutomaticKeepAlives: addAutomaticKeepAlives,
      addRepaintBoundaries: addRepaintBoundaries,
      addSemanticIndexes: addSemanticIndexes,
    );
  }
}

/// 이미지 최적화 유틸리티
class ImageOptimizer {
  /// 이미지 캐시 설정 최적화
  static void optimizeImageCache() {
    final imageCache = PaintingBinding.instance.imageCache;
    
    // 캐시 크기 제한 설정 (기본값보다 작게)
    imageCache.maximumSize = 100; // 이미지 개수 제한
    imageCache.maximumSizeBytes = 50 * 1024 * 1024; // 50MB 제한
    
    AppLogger.info('이미지 캐시 최적화 완료', tag: 'Performance');
  }

  /// 이미지 프리로딩 (필요한 경우에만)
  static void preloadImage(ImageProvider imageProvider, BuildContext context) {
    precacheImage(imageProvider, context).then((_) {
      AppLogger.debug('이미지 프리로딩 완료', tag: 'Performance');
    }).catchError((error) {
      AppLogger.warning('이미지 프리로딩 실패', tag: 'Performance', details: error);
    });
  }
}

/// 스크롤 성능 최적화 유틸리티
class ScrollOptimizer {
  /// 최적화된 스크롤 물리학 설정
  static const ScrollPhysics optimizedPhysics = BouncingScrollPhysics(
    parent: AlwaysScrollableScrollPhysics(),
  );

  /// 스크롤 컨트롤러 생성 (메모리 리크 방지)
  static ScrollController createOptimizedScrollController() {
    return ScrollController(
      debugLabel: 'OptimizedScrollController',
    );
  }

  /// 스크롤 성능 모니터링
  static void monitorScrollPerformance(ScrollController controller, String listName) {
    if (kDebugMode) {
      controller.addListener(() {
        if (controller.hasClients) {
          final position = controller.position;
          if (position.activity?.isScrolling == true) {
            AppLogger.debug(
              '스크롤 성능 모니터링: $listName',
              tag: 'Performance',
              details: {
                'position': position.pixels.toStringAsFixed(2),
                'maxScrollExtent': position.maxScrollExtent.toStringAsFixed(2),
              },
            );
          }
        }
      });
    }
  }
}