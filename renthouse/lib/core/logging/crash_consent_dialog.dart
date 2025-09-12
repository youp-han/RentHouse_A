import 'package:flutter/material.dart';
import 'crash_reporting_service.dart';

class CrashConsentDialog extends StatelessWidget {
  const CrashConsentDialog({super.key});

  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // 사용자가 반드시 선택해야 함
      builder: (context) => const CrashConsentDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: Icon(
        Icons.bug_report,
        size: 48,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: const Text(
        '앱 개선에 도움을 주세요',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '더 안정적인 앱을 만들기 위해 오류 정보를 수집하고자 합니다.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '수집하는 정보:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const _InfoRow(
                    icon: Icons.phone_android,
                    text: '기기 정보 (OS 버전, 모델명)',
                  ),
                  const _InfoRow(
                    icon: Icons.apps,
                    text: '앱 버전 및 실행 환경',
                  ),
                  const _InfoRow(
                    icon: Icons.error_outline,
                    text: '오류 발생 시점과 원인',
                  ),
                  const _InfoRow(
                    icon: Icons.timeline,
                    text: '마지막 사용자 행동 (버튼 클릭 등)',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.security, color: Colors.green, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        '개인정보 보호 약속',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green[800],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• 개인 식별 정보는 수집하지 않습니다\n'
                    '• 임차인, 임대료 등 민감한 데이터는 제외됩니다\n'
                    '• 수집된 정보는 오직 앱 개선 목적으로만 사용됩니다\n'
                    '• 언제든지 설정에서 동의를 철회할 수 있습니다',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green[700],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '개발자 이메일: youp.han+uk@gmail.com',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('거부'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('동의'),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            icon, 
            size: 16, 
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 앱 초기화 시 동의 확인을 위한 유틸리티 클래스
class CrashConsentManager {
  /// 앱 시작 시 동의가 필요한지 확인하고 다이얼로그 표시
  static Future<void> checkAndRequestConsent(BuildContext context) async {
    final hasAsked = await CrashReportingService.hasAskedForConsent();
    
    if (!hasAsked) {
      if (context.mounted) {
        final consent = await CrashConsentDialog.show(context);
        if (consent != null) {
          await CrashReportingService.setUserConsent(consent);
          
          // 동의한 경우 간단한 피드백 제공
          if (consent && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('감사합니다! 더 나은 앱을 만들도록 노력하겠습니다.'),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        }
      }
    }
  }
  
  /// 설정 화면에서 동의 상태를 변경할 때 사용
  static Future<void> changeConsentFromSettings(BuildContext context) async {
    final currentConsent = await CrashReportingService.getUserConsent();
    
    if (context.mounted) {
      final newConsent = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('오류 보고 설정'),
          content: Text(
            currentConsent 
              ? '현재 오류 보고가 활성화되어 있습니다.\n비활성화하시겠습니까?'
              : '오류 보고를 활성화하면 앱 문제 해결에 도움이 됩니다.\n활성화하시겠습니까?'
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('취소'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(!currentConsent),
              child: Text(currentConsent ? '비활성화' : '활성화'),
            ),
          ],
        ),
      );
      
      if (newConsent != null) {
        await CrashReportingService.setUserConsent(newConsent);
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                newConsent 
                  ? '오류 보고가 활성화되었습니다.'
                  : '오류 보고가 비활성화되었습니다.'
              ),
            ),
          );
        }
      }
    }
  }
}