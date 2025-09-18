import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:renthouse/features/auth/application/auth_controller.dart';
import 'package:renthouse/features/auth/domain/user.dart' as auth;
import 'package:renthouse/core/utils/password_validator.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // 개인정보 수정 폼
  final _nameFormKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  // 비밀번호 변경 폼
  final _passwordFormKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // 사용자 정보 초기화는 build에서 authState를 통해 처리
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    // 사용자 정보가 로드되면 텍스트 컨트롤러에 초기화
    authState.whenData((user) {
      if (user != null && _nameController.text.isEmpty) {
        _nameController.text = user.name;
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필 관리'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '개인정보', icon: Icon(Icons.person)),
            Tab(text: '비밀번호 변경', icon: Icon(Icons.lock)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPersonalInfoTab(authState),
          _buildPasswordChangeTab(authState),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoTab(AsyncValue<auth.User?> authState) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _nameFormKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
            const SizedBox(height: 24),
            Text(
              '개인정보 수정',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            TextFormField(
              controller: _nameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '이름을 입력해주세요';
                }
                if (value.length < 2) {
                  return '이름은 2자 이상 입력해주세요';
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: '이름',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            
            // 이메일은 수정 불가능하게 표시
            authState.when(
              data: (user) => TextFormField(
                initialValue: user?.email ?? "",
                enabled: false,
                decoration: const InputDecoration(
                  labelText: '이메일 (수정 불가)',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
              ),
              loading: () => TextFormField(
                enabled: false,
                decoration: InputDecoration(
                  labelText: '이메일 (로딩 중...)',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
              ),
              error: (error, _) => TextFormField(
                enabled: false,
                decoration: InputDecoration(
                  labelText: '이메일 (오류)',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 32),
            
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: authState.isLoading ? null : _handleUpdateName,
                child: authState.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('개인정보 수정'),
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }

  Widget _buildPasswordChangeTab(AsyncValue<auth.User?> authState) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _passwordFormKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
            const SizedBox(height: 24),
            Text(
              '비밀번호 변경',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            // 현재 비밀번호
            TextFormField(
              controller: _currentPasswordController,
              obscureText: _obscureCurrentPassword,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '현재 비밀번호를 입력해주세요';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: '현재 비밀번호',
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(_obscureCurrentPassword ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _obscureCurrentPassword = !_obscureCurrentPassword;
                    });
                  },
                ),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            
            // 새 비밀번호
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: _obscureNewPassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '새 비밀번호를 입력해주세요';
                    }
                    return PasswordValidator.validate(value);
                  },
                  onChanged: (value) {
                    setState(() {}); // 비밀번호 강도 업데이트
                  },
                  decoration: InputDecoration(
                    labelText: '새 비밀번호',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureNewPassword ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _obscureNewPassword = !_obscureNewPassword;
                        });
                      },
                    ),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                if (_newPasswordController.text.isNotEmpty)
                  _buildPasswordStrengthIndicator(),
              ],
            ),
            const SizedBox(height: 16),
            
            // 새 비밀번호 확인
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: _obscureConfirmPassword,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '새 비밀번호 확인을 입력해주세요';
                }
                if (value != _newPasswordController.text) {
                  return '새 비밀번호가 일치하지 않습니다';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: '새 비밀번호 확인',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(_obscureConfirmPassword ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 32),
            
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: authState.isLoading ? null : _handleChangePassword,
                child: authState.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('비밀번호 변경'),
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }

  Widget _buildPasswordStrengthIndicator() {
    final strength = PasswordValidator.getStrength(_newPasswordController.text);
    final strengthText = PasswordValidator.getStrengthText(strength);
    
    Color getStrengthColor() {
      switch (strength) {
        case 0:
        case 1:
          return Colors.red;
        case 2:
          return Colors.orange;
        case 3:
          return Colors.yellow[700]!;
        case 4:
          return Colors.green;
        default:
          return Colors.grey;
      }
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '비밀번호 강도: ',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            Text(
              strengthText,
              style: TextStyle(
                fontSize: 12,
                color: getStrengthColor(),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: strength / 4.0,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(getStrengthColor()),
        ),
      ],
    );
  }

  Future<void> _handleUpdateName() async {
    if (!_nameFormKey.currentState!.validate()) {
      return;
    }

    try {
      final request = auth.UpdateUserRequest(
        name: _nameController.text,
      );
      
      await ref.read(authControllerProvider.notifier).updateUserProfile(request);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('개인정보가 수정되었습니다!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('개인정보 수정 실패: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleChangePassword() async {
    if (!_passwordFormKey.currentState!.validate()) {
      return;
    }

    try {
      final request = auth.UpdateUserRequest(
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
      );
      
      await ref.read(authControllerProvider.notifier).updateUserProfile(request);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('비밀번호가 변경되었습니다!'),
            backgroundColor: Colors.green,
          ),
        );
        
        // 폼 리셋
        _currentPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('비밀번호 변경 실패: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}