import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorageService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock_this_device),
  );

  static const String _tokenKey = 'orenda_api_token';
  static const String _tokenExpiryKey = 'orenda_token_expiry';

  static Future<void> saveToken(String token, {DateTime? expiry}) async {
    await _storage.write(key: _tokenKey, value: token);
    if (expiry != null) {
      await _storage.write(key: _tokenExpiryKey, value: expiry.millisecondsSinceEpoch.toString());
    }
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  static Future<bool> isTokenExpired() async {
    final expiryStr = await _storage.read(key: _tokenExpiryKey);
    if (expiryStr == null) return true;

    final expiry = DateTime.fromMillisecondsSinceEpoch(int.parse(expiryStr));
    return DateTime.now().isAfter(expiry);
  }

  static Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _tokenExpiryKey);
  }

  static Future<void> initializeDefaultToken() async {
    const defaultToken =
        'uOkENYi7e8/kz2DRoQG/vfguBuNWxmLlReEvG2ooTTjYsTQsLPnUuU4xeNS/RF5Ej7Wdu6U33lPcpLOJTtvX26+d1WU2DXeptl25HnexZwGiu3u6s1zg4pvkGQjFeAS7aYnqA0osefBuhARxtWvQzIkmVG9ZAadh/AhFPCyZ9hS9qk9EKX2Sv7Ty+9w2tX+tGsdjmEPcRS45ukubeAnoJppinPv/vYPx1Vl0IU6EzZW9z5GDCIveUYW1zftid5Fn';

    final existingToken = await getToken();
    if (existingToken == null) {
      final expiry = DateTime.now().add(const Duration(hours: 24));
      await saveToken(defaultToken, expiry: expiry);
    }
  }
}
