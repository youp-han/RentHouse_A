import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'crash_consent_dialog.dart';

/// 앱 전체를 감싸서 최초 1회 동의 요청을 처리하는 Wrapper
class CrashConsentWrapper extends ConsumerStatefulWidget {
  final Widget child;

  const CrashConsentWrapper({super.key, required this.child});

  @override
  ConsumerState<CrashConsentWrapper> createState() => _CrashConsentWrapperState();
}

class _CrashConsentWrapperState extends ConsumerState<CrashConsentWrapper> {
  bool _hasCheckedConsent = false;

  @override
  void initState() {
    super.initState();
    // 약간의 딜레이 후에 동의 확인 (UI가 완전히 로드된 후)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkConsentAfterDelay();
    });
  }

  Future<void> _checkConsentAfterDelay() async {
    if (_hasCheckedConsent) return;
    
    // 2초 딜레이 후 동의 확인 (앱이 완전히 로드된 후)
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      await CrashConsentManager.checkAndRequestConsent(context);
      _hasCheckedConsent = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}