import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:renthouse/core/services/background_initialization_service.dart';
import 'package:renthouse/core/auth/auth_state.dart';

/// 앱 시작 시 보여지는 스플래시 화면
/// 백그라운드 초기화가 완료되거나 최소 시간이 지나면 자동으로 다음 화면으로 이동
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _progressController;
  late Animation<double> _logoFadeIn;
  late Animation<double> _logoScale;
  late Animation<double> _progressValue;

  static const Duration _minimumSplashDuration = Duration(seconds: 2);
  static const Duration _maximumSplashDuration = Duration(seconds: 8);

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startSplashSequence();
  }

  void _initializeAnimations() {
    // 로고 애니메이션
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _logoFadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _logoScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    // 프로그레스 애니메이션
    _progressController = AnimationController(
      duration: _maximumSplashDuration,
      vsync: this,
    );

    _progressValue = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _progressController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _startSplashSequence() async {
    // 로고 애니메이션 시작
    _logoController.forward();

    // 프로그레스 애니메이션 시작
    _progressController.forward();

    // 최소 스플래시 시간 보장
    final minimumWaitCompleter = Future.delayed(_minimumSplashDuration);

    // 백그라운드 초기화 완료 대기 (최대 시간 제한)
    final initializationCompleter = _waitForInitialization();

    // 둘 중 늦게 완료되는 것을 기다림
    await Future.wait([minimumWaitCompleter, initializationCompleter]);

    // 다음 화면으로 이동
    if (mounted) {
      _navigateToNextScreen();
    }
  }

  Future<void> _waitForInitialization() async {
    final startTime = DateTime.now();

    while (!BackgroundInitializationService.isInitialized) {
      // 최대 시간 초과 체크
      if (DateTime.now().difference(startTime) > _maximumSplashDuration) {
        print('⚠️ 백그라운드 초기화 시간 초과, 앱 계속 진행');
        break;
      }

      // 100ms마다 상태 체크
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  void _navigateToNextScreen() {
    final authState = AuthState.instance;

    if (authState.isLoggedIn) {
      context.go('/admin/dashboard');
    } else {
      context.go('/login');
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 로고 영역
            AnimatedBuilder(
              animation: _logoController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _logoScale.value,
                  child: Opacity(
                    opacity: _logoFadeIn.value,
                    child: _buildLogo(theme),
                  ),
                );
              },
            ),

            const SizedBox(height: 60),

            // 프로그레스 바
            AnimatedBuilder(
              animation: _progressController,
              builder: (context, child) {
                return _buildProgressIndicator(theme);
              },
            ),

            const SizedBox(height: 24),

            // 로딩 텍스트
            AnimatedBuilder(
              animation: _logoController,
              builder: (context, child) {
                return Opacity(
                  opacity: _logoFadeIn.value,
                  child: Text(
                    _getLoadingText(),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onPrimary.withOpacity(0.8),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo(ThemeData theme) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Icon(
        Icons.home_work,
        size: 60,
        color: theme.colorScheme.primary,
      ),
    );
  }

  Widget _buildProgressIndicator(ThemeData theme) {
    return SizedBox(
      width: 60,
      height: 60,
      child: CircularProgressIndicator(
        value: _progressValue.value,
        strokeWidth: 3,
        backgroundColor: theme.colorScheme.onPrimary.withOpacity(0.2),
        valueColor: AlwaysStoppedAnimation<Color>(
          theme.colorScheme.onPrimary.withOpacity(0.8),
        ),
      ),
    );
  }

  String _getLoadingText() {
    if (BackgroundInitializationService.isInitialized) {
      return '준비 완료';
    } else if (BackgroundInitializationService.isInitializing) {
      return '초기화 중...';
    } else {
      return '시작 중...';
    }
  }
}