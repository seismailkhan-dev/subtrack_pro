import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage();

  static String _keyForPassword(String userId) => 'password_$userId';

  static Future<void> savePasswordHash(
      String userId, String hash) async {
    await _storage.write(key: _keyForPassword(userId), value: hash);
  }

  static Future<String?> getPasswordHash(String userId) async {
    return _storage.read(key: _keyForPassword(userId));
  }

  static Future<void> deletePassword(String userId) async {
    await _storage.delete(key: _keyForPassword(userId));
  }

  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}