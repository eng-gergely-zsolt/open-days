import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const _userId = 'user_id';
  static const _authorizationToken = 'authorization_token';

  static const _secureStorage = FlutterSecureStorage();

  static Future<String?> getUserId() async => await _secureStorage.read(key: _userId);

  static Future<String?> getAuthorizationToken() async =>
      await _secureStorage.read(key: _authorizationToken);

  static Future setUserId(String userId) async =>
      await _secureStorage.write(key: _userId, value: userId);

  static Future setAuthorizationToken(String authorizationToken) async =>
      await _secureStorage.write(key: _authorizationToken, value: authorizationToken);
}
