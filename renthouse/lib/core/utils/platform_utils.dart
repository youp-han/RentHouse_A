import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// 플랫폼별 유틸리티 클래스
class PlatformUtils {
  /// 현재 플랫폼이 데스크톱인지 확인
  static bool get isDesktop =>
      !kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS);

  /// 현재 플랫폼이 모바일인지 확인
  static bool get isMobile =>
      !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  /// 현재 플랫폼이 웹인지 확인
  static bool get isWeb => kIsWeb;

  /// 안드로이드/Windows 타겟 플랫폼인지 확인
  static bool get isTargetPlatform =>
      !kIsWeb && (Platform.isAndroid || Platform.isWindows);

  /// 플랫폼별 적절한 패딩 반환
  static EdgeInsetsGeometry getPlatformPadding(BuildContext context) {
    if (isDesktop) {
      return const EdgeInsets.all(24.0);
    } else {
      return const EdgeInsets.all(16.0);
    }
  }

  /// 플랫폼별 적절한 카드 마진 반환
  static EdgeInsetsGeometry getCardMargin() {
    if (isDesktop) {
      return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
    } else {
      return const EdgeInsets.symmetric(horizontal: 12, vertical: 4);
    }
  }

  /// 플랫폼별 적절한 앱바 높이 반환
  static double getAppBarHeight() {
    if (isDesktop) {
      return kToolbarHeight + 8; // 약간 더 높게
    } else {
      return kToolbarHeight;
    }
  }

  /// 플랫폼별 적절한 최대 너비 반환 (데스크톱용)
  static double getMaxWidth(BuildContext context) {
    if (isDesktop) {
      final screenWidth = MediaQuery.of(context).size.width;
      return screenWidth > 1200 ? 1200 : screenWidth;
    } else {
      return MediaQuery.of(context).size.width;
    }
  }

  /// 플랫폼별 스크롤 동작 반환
  static ScrollBehavior getScrollBehavior() {
    if (isDesktop) {
      return WindowsScrollBehavior();
    } else {
      return const MaterialScrollBehavior();
    }
  }

  /// 플랫폼별 리스트 아이템 높이 반환
  static double getListItemHeight() {
    if (isDesktop) {
      return 64.0; // 데스크톱에서는 좀 더 높게
    } else {
      return 56.0; // 모바일 기본값
    }
  }

  /// 플랫폼별 다이얼로그 너비 반환
  static double getDialogWidth(BuildContext context) {
    if (isDesktop) {
      return 500.0;
    } else {
      return MediaQuery.of(context).size.width * 0.9;
    }
  }

  /// 플랫폼별 폰트 크기 조정 반환
  static double getFontSizeMultiplier() {
    if (isDesktop) {
      return 1.0; // 데스크톱은 기본 크기
    } else {
      return 1.0; // 모바일도 기본 크기 (필요시 조정)
    }
  }

  /// 플랫폼 이름 반환
  static String getPlatformName() {
    if (kIsWeb) return 'Web';
    if (Platform.isAndroid) return 'Android';
    if (Platform.isIOS) return 'iOS';
    if (Platform.isWindows) return 'Windows';
    if (Platform.isMacOS) return 'macOS';
    if (Platform.isLinux) return 'Linux';
    return 'Unknown';
  }
}

/// Windows용 커스텀 스크롤 동작
class WindowsScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.stylus,
    PointerDeviceKind.trackpad,
  };

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics();
  }

  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return Scrollbar(
      controller: details.controller,
      child: child,
    );
  }
}

/// 플랫폼 적응형 위젯을 위한 확장
extension PlatformWidget on Widget {
  /// 플랫폼별 최대 너비 제한 적용
  Widget constrainedByPlatform(BuildContext context) {
    if (PlatformUtils.isDesktop) {
      return Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: PlatformUtils.getMaxWidth(context),
          ),
          child: this,
        ),
      );
    }
    return this;
  }

  /// 플랫폼별 패딩 적용
  Widget paddedByPlatform(BuildContext context) {
    return Padding(
      padding: PlatformUtils.getPlatformPadding(context),
      child: this,
    );
  }
}