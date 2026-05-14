import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

class SecurityUtils {
  static String generateSalt() {
    final random = Random.secure();
    final saltBytes = List<int>.generate(16, (_) => random.nextInt(256));
    return base64Encode(saltBytes);
  }

  static String hashPassword(String password, String salt) {
    final saltBytes = base64Decode(salt);
    final passwordBytes = utf8.encode(password);
    
    final combined = [...saltBytes, ...passwordBytes];
    final digest = sha256.convert(combined);
    
    return base64Encode(digest.bytes);
  }

  static bool verifyPassword(String password, String hashedPassword, String salt) {
    final computedHash = hashPassword(password, salt);
    return computedHash == hashedPassword;
  }

  static String generateSecureToken() {
    final random = Random.secure();
    final tokenBytes = List<int>.generate(32, (_) => random.nextInt(256));
    return base64UrlEncode(tokenBytes);
  }
}
