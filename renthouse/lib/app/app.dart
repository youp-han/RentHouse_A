import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:renthouse/core/logging/crash_consent_wrapper.dart';
import 'package:renthouse/core/performance/memory_manager.dart';
import 'package:renthouse/core/utils/platform_utils.dart';
import 'package:renthouse/features/lease/services/lease_status_service.dart';
import 'theme.dart';
import 'router.dart';

class RentHouseApp extends ConsumerStatefulWidget {
  const RentHouseApp({super.key});

  @override
  ConsumerState<RentHouseApp> createState() => _RentHouseAppState();
}

class _RentHouseAppState extends ConsumerState<RentHouseApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    // 성능 최적화 초기화
    _initializePerformanceOptimizations();

    // 서비스 초기화
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeServices();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    MemoryManager.stopMemoryMonitoring();

    // 계약 상태 서비스 중지
    ref.read(leaseStatusServiceProvider).stop();

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        // 앱이 백그라운드로 갈 때 메모리 정리
        MemoryManager.clearCaches();
        break;
      case AppLifecycleState.resumed:
        // 앱이 포그라운드로 돌아올 때 모니터링 재시작
        MemoryManager.startMemoryMonitoring();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
        break;
    }
  }

  void _initializePerformanceOptimizations() {
    // 이미지 캐시 최적화
    ImageOptimizer.optimizeImageCache();

    // 메모리 모니터링 시작
    MemoryManager.startMemoryMonitoring();
  }

  void _initializeServices() {
    // 계약 상태 자동 관리 서비스 시작
    final leaseStatusService = ref.read(leaseStatusServiceProvider);
    leaseStatusService.start();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'RentHouse',
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      // 플랫폼별 스크롤 동작 설정
      scrollBehavior: PlatformUtils.getScrollBehavior(),
      builder: (context, child) {
        return CrashConsentWrapper(child: child ?? const SizedBox.shrink());
      },
    );
  }
}
