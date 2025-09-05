import '../auth/auth_state.dart';

bool can(String permission) {
  // 초기 PoC: 권한-역할 매핑은 하드코딩, 추후 서버/토큰 기반으로 교체
  final roles = AuthState.instance.roles;
  if (roles.contains('OWNER') || roles.contains('ADMIN')) return true;
  // 예: billing.create 는 MANAGER 이상 허용
  if (permission == 'billing.create' && roles.contains('MANAGER')) return true;
  return false;
}
