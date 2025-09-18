import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:renthouse/features/auth/application/auth_controller.dart';
import 'package:renthouse/core/logging/crash_reporting_service.dart';
import 'package:renthouse/core/logging/crash_consent_dialog.dart';
import 'package:renthouse/core/services/database_backup_service.dart';
import 'dart:io';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _crashReportingEnabled = false;
  int _pendingLogCount = 0;

  @override
  void initState() {
    super.initState();
    _loadCrashReportingState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 화면이 다시 표시될 때마다 상태 새로고침
    _loadCrashReportingState();
  }

  Future<void> _loadCrashReportingState() async {
    final isEnabled = await CrashReportingService.getUserConsent();
    final logCount = CrashReportingService.getPendingLogCount();
    
    if (mounted) {
      setState(() {
        _crashReportingEnabled = isEnabled;
        _pendingLogCount = logCount;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // 프로필 섹션
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '프로필',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('프로필 관리'),
                    subtitle: const Text('개인정보 수정, 비밀번호 변경'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () => context.go('/settings/profile'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.delete_forever),
                    title: const Text('회원 탈퇴'),
                    subtitle: const Text('계정을 완전히 삭제합니다'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () => _showDeleteAccountDialog(context, ref),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // 앱 설정 섹션
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '앱 설정',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.attach_money),
                    title: const Text('통화 설정'),
                    subtitle: const Text('원화(KRW), 달러(USD) 등'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () => context.go('/settings/currency'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.backup),
                    title: const Text('데이터베이스 백업'),
                    subtitle: const Text('현재 데이터를 안전한 위치에 백업'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () => _handleDatabaseBackup(context),
                  ),
                  ListTile(
                    leading: const Icon(Icons.bug_report),
                    title: const Text('오류 보고'),
                    subtitle: Text(
                      _crashReportingEnabled 
                        ? '앱 개선을 위해 오류 정보를 전송합니다'
                        : '오류 보고가 비활성화되어 있습니다'
                    ),
                    trailing: Switch(
                      value: _crashReportingEnabled,
                      onChanged: (value) => _handleCrashReportingToggle(context),
                    ),
                    onTap: () => _handleCrashReportingToggle(context),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.send,
                      color: _pendingLogCount > 0 ? Colors.blue : Colors.grey,
                    ),
                    title: const Text('누적 로그 전송'),
                    subtitle: Text(
                      _pendingLogCount > 0 
                        ? '$_pendingLogCount건의 로그가 저장되어 있습니다'
                        : '전송할 로그가 없습니다'
                    ),
                    trailing: _pendingLogCount > 0 
                      ? const Icon(Icons.arrow_forward_ios)
                      : null,
                    onTap: _pendingLogCount > 0 
                      ? () => _sendPendingLogs(context)
                      : null,
                  ),
                  // 개발 모드에서만 테스트 크래시 버튼 표시
                  if (kDebugMode) ...[
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.warning, color: Colors.orange),
                      title: const Text('테스트 크래시 발생'),
                      subtitle: const Text('크래시 보고 시스템 테스트용'),
                      onTap: () => _triggerTestCrash(context),
                    ),
                  ],
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 32),
          
          // 로그아웃 버튼
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: authState.isLoading ? null : () => _handleLogout(context, ref),
              icon: authState.isLoading 
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.logout),
              label: const Text('로그아웃'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context, WidgetRef ref) async {
    final passwordController = TextEditingController();
    final focusNode = FocusNode();
    final textFieldKey = GlobalKey();

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        // Use ensureVisible to make the TextField visible
        Future.delayed(const Duration(milliseconds: 300), () {
          final context = textFieldKey.currentContext;
          if (context != null) {
            Scrollable.ensureVisible(
              context,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              alignment: 0.5, // Center the field in the viewport
            );
          }
        });
      }
    });

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('회원 탈퇴'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '정말로 계정을 삭제하시겠습니까?\n\n'
                      '⚠️ 이 작업은 되돌릴 수 없으며, 다음 데이터가 영구적으로 삭제됩니다:\n'
                      '• 계정 정보\n'
                      '• 등록된 모든 자산과 유닛\n'
                      '• 임차인 계약 정보\n'
                      '• 청구서 및 수납 내역\n'
                      '• 기타 모든 관련 데이터\n',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '비밀번호를 입력하여 본인 확인을 해주세요:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      key: textFieldKey,
                      controller: passwordController,
                      focusNode: focusNode,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: '현재 비밀번호',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('취소'),
                ),
                FilledButton(
                  onPressed: () {
                    final password = passwordController.text.trim();
                    if (password.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('비밀번호를 입력해주세요.'),
                          backgroundColor: Colors.orange,
                        ),
                      );
                      return;
                    }
                    
                    Navigator.of(context).pop();
                    _handleDeleteAccount(context, ref, password);
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.error,
                  ),
                  child: const Text('계정 삭제 및 재시작'),
                ),
              ],
            );
          },
        );
      },
    );

    // Dispose controllers after the dialog is closed
    passwordController.dispose();
    focusNode.dispose();
  }

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(authControllerProvider.notifier).logout();
      if (context.mounted) {
        context.go('/login');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('로그아웃 실패: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleCrashReportingToggle(BuildContext context) async {
    await CrashConsentManager.changeConsentFromSettings(context);
    // 상태 변경 후 UI 새로고침
    await _loadCrashReportingState();
  }

  void _sendPendingLogs(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('누적 로그 전송'),
        content: Text(
          '저장된 ${CrashReportingService.getPendingLogCount()}건의 로그를 개발자에게 전송하시겠습니까?\n\n'
          '이메일 앱이 열리면서 미리 작성된 내용을 확인하고 전송할 수 있습니다.'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await CrashReportingService.sendAllPendingLogs();
              
              if (context.mounted) {
                // 로그 개수 업데이트
                setState(() {
                  _pendingLogCount = CrashReportingService.getPendingLogCount();
                });
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('이메일 앱이 열렸습니다. 확인 후 전송해주세요.'),
                    backgroundColor: Colors.blue,
                  ),
                );
              }
            },
            child: const Text('전송'),
          ),
        ],
      ),
    );
  }

  void _triggerTestCrash(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('테스트 크래시'),
        content: const Text('크래시 보고 시스템을 테스트하기 위해 의도적으로 오류를 발생시킵니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              
              // 다양한 테스트 크래시 유형
              CrashReportingService.recordUserAction('test_crash_triggered');
              
              // 1초 후 크래시 발생 (UI가 닫힌 후)
              Future.delayed(const Duration(seconds: 1), () {
                CrashReportingService.reportException(
                  Exception('테스트 크래시: 이메일 기반 크래시 보고 시스템 검증용'),
                  StackTrace.current,
                  context: 'settings_screen_test',
                  extra: {
                    'test_type': 'manual_crash',
                    'timestamp': DateTime.now().toIso8601String(),
                    'user_triggered': true,
                  },
                );
                
                // 로그 개수 업데이트
                if (mounted) {
                  setState(() {
                    _pendingLogCount = CrashReportingService.getPendingLogCount();
                  });
                }
                
                // 실제 예외도 발생시켜서 Flutter 오류 핸들러도 테스트
                throw Exception('테스트용 예외: 이메일 기반 오류 보고 검증');
              });
            },
            child: const Text('크래시 발생'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleDeleteAccount(BuildContext context, WidgetRef ref, String password) async {
    BuildContext? dialogContext;

    try {
      // 1. 로딩 다이얼로그 표시
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) {
            dialogContext = ctx;
            return const AlertDialog(
              content: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 16),
                  Text('계정을 삭제하는 중...'),
                ],
              ),
            );
          },
        );
      }

      // 2. 계정 데이터 삭제
      await ref.read(authControllerProvider.notifier).deleteAccount(password);

      // 3. 로그아웃하여 세션 정리
      await ref.read(authControllerProvider.notifier).logout();

      // 4. 로딩 다이얼로그 닫기
      if (dialogContext != null && dialogContext!.mounted) {
        Navigator.of(dialogContext!).pop();
      }

      // 5. 앱 종료
      _restartApp();

    } catch (e) {
      // 오류 발생 시 로딩 다이얼로그 닫기
      if (dialogContext != null && dialogContext!.mounted) {
        Navigator.of(dialogContext!).pop();
      }

      // UI 안정화를 위한 대기
      await Future.delayed(const Duration(milliseconds: 100));

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('회원 탈퇴 실패: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleDatabaseBackup(BuildContext context) async {
    bool isDialogOpen = false;

    try {
      // 백업 폴더 선택
      final backupFolder = await DatabaseBackupService.selectBackupFolder();

      if (backupFolder == null) {
        if (mounted && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('백업 폴더가 선택되지 않았습니다.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      if (!mounted || !context.mounted) return;

      // 로딩 다이얼로그 표시
      isDialogOpen = true;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => const AlertDialog(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text('데이터베이스를 백업하는 중...'),
            ],
          ),
        ),
      );

      try {
        // 백업 실행
        final success = await DatabaseBackupService.backupDatabase(backupFolder);

        // 로딩 다이얼로그 닫기
        if (isDialogOpen && mounted && context.mounted) {
          Navigator.of(context, rootNavigator: true).pop();
          isDialogOpen = false;
        }

        // 잠시 대기 후 SnackBar 표시 (UI 안정화)
        await Future.delayed(const Duration(milliseconds: 300));

        if (mounted && context.mounted) {
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('데이터베이스가 성공적으로 백업되었습니다.\n위치: $backupFolder'),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 4),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('데이터베이스 백업에 실패했습니다.'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        // 백업 중 오류 발생 시 다이얼로그 닫기
        if (isDialogOpen && mounted && context.mounted) {
          Navigator.of(context, rootNavigator: true).pop();
          isDialogOpen = false;
        }
        rethrow;
      }
    } catch (e) {
      // 전체 과정에서 오류 발생 시 다이얼로그 닫기
      if (isDialogOpen && mounted && context.mounted) {
        try {
          Navigator.of(context, rootNavigator: true).pop();
        } catch (_) {
          // 이미 닫혔을 수 있음
        }
        isDialogOpen = false;
      }

      // 잠시 대기 후 에러 메시지 표시
      await Future.delayed(const Duration(milliseconds: 300));

      if (mounted && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('백업 중 오류 발생: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _restartApp() {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      // 데스크톱 플랫폼에서는 앱 종료 후 사용자가 수동으로 재시작
      exit(0);
    } else if (Platform.isAndroid) {
      // 안드로이드에서는 SystemNavigator.pop()으로 종료
      SystemNavigator.pop();
    }
  }
}