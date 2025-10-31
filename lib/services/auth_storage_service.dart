import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/auth_models.dart';

class AuthStorageService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock_this_device),
  );

  static const String _sessionKey = 'user_session';
  static const String _tokenKey = 'user_token';

  static Future<void> saveSession(AuthResponse response) async {
    final sessionJson = jsonEncode(response.toJson());
    await _storage.write(key: _sessionKey, value: sessionJson);
    await _storage.write(key: _tokenKey, value: response.token);
  }

  static Future<AuthResponse?> getSession() async {
    final sessionJson = await _storage.read(key: _sessionKey);
    if (sessionJson == null) return null;

    try {
      final json = jsonDecode(sessionJson) as Map<String, dynamic>;
      return AuthResponse.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  static Future<void> clearSession() async {
    await _storage.delete(key: _sessionKey);
    await _storage.delete(key: _tokenKey);
  }

  static Future<bool> hasSession() async {
    final session = await getSession();
    if (session == null) return false;

    final now = DateTime.now();
    if (session.expiresAt.isBefore(now)) {
      await clearSession();
      return false;
    }

    return true;
  }
}
