class PasswordValidator {
  // 비밀번호 정책:
  // - 8자 이상
  // - 영문자, 숫자만 허용 (한글, 특수문자 제외)
  // - 대문자 1개 이상 포함
  // - 소문자 1개 이상 포함
  // - 숫자 1개 이상 포함
  
  static const int minLength = 8;
  
  /// 비밀번호 유효성 검증
  static String? validate(String password) {
    if (password.isEmpty) {
      return '비밀번호를 입력해주세요';
    }
    
    // 길이 검증
    if (password.length < minLength) {
      return '비밀번호는 ${minLength}자 이상이어야 합니다';
    }
    
    // 영문자와 숫자만 허용 (한글, 특수문자 제외)
    if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(password)) {
      return '비밀번호는 영문자와 숫자만 사용할 수 있습니다';
    }
    
    // 대문자 포함 여부
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return '비밀번호에 대문자를 1개 이상 포함해야 합니다';
    }
    
    // 소문자 포함 여부
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return '비밀번호에 소문자를 1개 이상 포함해야 합니다';
    }
    
    // 숫자 포함 여부
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return '비밀번호에 숫자를 1개 이상 포함해야 합니다';
    }
    
    return null; // 유효함
  }
  
  /// 비밀번호 강도 측정 (0~4)
  static int getStrength(String password) {
    int strength = 0;
    
    if (password.length >= minLength) strength++;
    if (RegExp(r'[A-Z]').hasMatch(password)) strength++;
    if (RegExp(r'[a-z]').hasMatch(password)) strength++;
    if (RegExp(r'[0-9]').hasMatch(password)) strength++;
    
    return strength;
  }
  
  /// 비밀번호 강도 텍스트
  static String getStrengthText(int strength) {
    switch (strength) {
      case 0:
      case 1:
        return '매우 약함';
      case 2:
        return '약함';
      case 3:
        return '보통';
      case 4:
        return '강함';
      default:
        return '알 수 없음';
    }
  }
  
  /// 비밀번호 강도 색상
  static String getStrengthColor(int strength) {
    switch (strength) {
      case 0:
      case 1:
        return 'red';
      case 2:
        return 'orange';
      case 3:
        return 'yellow';
      case 4:
        return 'green';
      default:
        return 'grey';
    }
  }
}