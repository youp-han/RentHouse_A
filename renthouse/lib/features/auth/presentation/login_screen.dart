import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:renthouse/features/auth/application/auth_controller.dart';
import 'package:renthouse/core/auth/auth_repository.dart';
import 'package:renthouse/core/services/database_backup_service.dart';
import 'dart:io';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _hasRegisteredUser = false;

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadUserEmail() async {
    try {
      final authRepository = ref.read(authRepositoryProvider);
      final email = await authRepository.getFirstUserEmail();
      if (email != null && mounted) {
        _emailController.text = email;
        setState(() {
          _hasRegisteredUser = true;
        });
      }
    } catch (e) {
      // 에러가 있어도 로그인 화면은 정상적으로 표시
      print('사용자 이메일 로딩 실패: $e');
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return '이메일을 입력해주세요';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return '올바른 이메일 형식을 입력해주세요';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return '비밀번호를 입력해주세요';
    }
    return null;
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      await ref.read(authControllerProvider.notifier).login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (mounted) {
        context.go('/'); // 메인 화면으로 이동
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('로그인 실패: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleDatabaseRestore() async {
    BuildContext? dialogContext;

    try {
      // 백업 파일 선택
      final backupFilePath = await DatabaseBackupService.selectBackupFile();

      if (backupFilePath == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('복원할 파일이 선택되지 않았습니다.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      // 확인 다이얼로그
      final confirmed = await _showRestoreConfirmationDialog(backupFilePath);
      if (!confirmed) return;

      // 로딩 다이얼로그 표시
      if (mounted) {
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
                  Text('데이터베이스를 복원하는 중...'),
                ],
              ),
            );
          },
        );
      }

      // 복원 실행
      final success = await DatabaseBackupService.restoreDatabase(backupFilePath);

      // 로딩 다이얼로그 닫기
      if (dialogContext != null && dialogContext!.mounted) {
        Navigator.of(dialogContext!).pop();
        dialogContext = null;
      }

      // 잠시 대기 후 결과 표시 (UI 안정화)
      await Future.delayed(const Duration(milliseconds: 100));

      if (mounted) {
        if (success) {
          // 복원 성공 - 앱 재시작 필요 안내
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: const Text('복원 준비 완료'),
              content: const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('데이터베이스 복원이 준비되었습니다.'),
                  SizedBox(height: 8),
                  Text(
                    '복원을 완료하려면 앱을 재시작해주세요.',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  Text(
                    '• 앱을 완전히 종료 후 다시 실행\n'
                    '• 복원 후 백업된 데이터로 로그인',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              actions: [
                FilledButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // 앱 강제 재시작
                    _restartApp();
                  },
                  child: const Text('확인 및 재시작'),
                ),
              ],
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('데이터베이스 복원에 실패했습니다.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      // 로딩 다이얼로그가 열려있다면 닫기
      if (dialogContext != null && dialogContext!.mounted) {
        Navigator.of(dialogContext!).pop();
        dialogContext = null;
      }

      // 잠시 대기 후 에러 메시지 표시
      await Future.delayed(const Duration(milliseconds: 100));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('복원 중 오류 발생: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<bool> _showRestoreConfirmationDialog(String filePath) async {
    final backupInfo = await DatabaseBackupService.getBackupFileInfo(filePath);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('데이터베이스 복원'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '선택한 백업 파일로 현재 데이터베이스를 완전히 교체하시겠습니까?\n',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  border: Border.all(color: Colors.orange[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '⚠️ 주의사항:',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '• 현재 모든 데이터가 삭제됩니다\n'
                      '• 백업 파일의 데이터로 완전 교체됩니다\n'
                      '• 현재 데이터는 자동으로 백업됩니다\n'
                      '• 복원 후 앱 재시작이 필요합니다',
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              if (backupInfo.isNotEmpty) ...[
                const Text(
                  '백업 파일 정보:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    border: Border.all(color: Colors.blue[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('📁 파일명: ${backupInfo['fileName'] ?? 'Unknown'}'),
                      const SizedBox(height: 4),
                      Text('📏 크기: ${backupInfo['sizeFormatted'] ?? 'Unknown'}'),
                      const SizedBox(height: 4),
                      Text('📅 수정일: ${backupInfo['modifiedFormatted'] ?? 'Unknown'}'),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            child: const Text('복원하기'),
          ),
        ],
      ),
    );

    return confirmed ?? false;
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

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('로그인'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 24.0,
                right: 24.0,
                top: 24.0,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24.0,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 48.0,
                ),
                child: IntrinsicHeight(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
              const SizedBox(height: 24),
              Icon(
                Icons.home,
                size: 48,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 16),
              Text(
                '렌트하우스',
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                '임대 관리 솔루션',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              
              // 이메일 입력 필드 (자동으로 채워짐)
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail,
                readOnly: true,  // 단일 사용자 앱이므로 이메일 변경 불가
                decoration: const InputDecoration(
                  labelText: '이메일 (자동 설정)',
                  hintText: '등록된 사용자 이메일',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Color(0xFFF5F5F5),
                ),
              ),
              const SizedBox(height: 16),
              
              // 비밀번호 입력 필드
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                validator: _validatePassword,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                ],
                decoration: InputDecoration(
                  labelText: '비밀번호',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              // 로그인 버튼
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: authState.isLoading ? null : _handleLogin,
                  child: authState.isLoading 
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('로그인'),
                ),
              ),
              const SizedBox(height: 16),

              // 회원가입 화면으로 이동 (등록된 사용자가 없을 때만 표시)
              if (!_hasRegisteredUser)
                TextButton(
                  onPressed: () => context.go('/register'),
                  child: const Text('계정이 없으신가요? 회원가입하기'),
                ),

              // 데이터베이스 복원 버튼 (항상 표시)
              TextButton.icon(
                onPressed: _handleDatabaseRestore,
                icon: const Icon(Icons.restore),
                label: const Text('백업에서 데이터 복원'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue[600],
                ),
              ),

              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 12),
              
              // 단일 사용자 안내
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.person, color: Colors.green[600], size: 20),
                        const SizedBox(width: 8),
                        Text(
                          '개인 사용자 전용',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '이 앱은 단일 사용자 전용입니다. 등록된 사용자의 이메일이 자동으로 설정됩니다.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}