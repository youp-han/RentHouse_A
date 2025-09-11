import 'dart:convert';
import 'package:crypto/crypto.dart';

String hashPassword(String password) {
  final bytes = utf8.encode(password);
  final digest = sha256.convert(bytes);
  return digest.toString();
}

void main() {
  final targetHash = 'f78bcd398eb3cac0050bfcc3778c94bb3a6449b94b1c73e34ed4d4cc97a9c7b5';
  
  // 일반적인 테스트 비밀번호들
  final testPasswords = [
    'password',
    '123456',
    'test',
    'admin',
    'qwerty',
    'password123',
    '111111',
    '000000',
    'abc123',
    'test123',
    'qwer1234',
    'ㅂㅈㄷㄱ1234',  // 한글로 잘못 입력된 경우
  ];
  
  print('타겟 해시: $targetHash');
  print('\n테스트 중...');
  
  for (final password in testPasswords) {
    final hash = hashPassword(password);
    print('$password → $hash');
    if (hash == targetHash) {
      print('✅ 일치! 비밀번호는: "$password"');
      return;
    }
  }
  
  print('\n❌ 일반적인 비밀번호들과 일치하지 않습니다.');
}