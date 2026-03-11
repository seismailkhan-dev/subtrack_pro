import 'package:bcrypt/bcrypt.dart';

class PasswordService {
  /// Hash plain password using bcrypt
  static String hash(String password) {
    return BCrypt.hashpw(password, BCrypt.gensalt());
  }

  /// Verify password against stored hash
  static bool verify(String password, String hash) {
    return BCrypt.checkpw(password, hash);
  }
}