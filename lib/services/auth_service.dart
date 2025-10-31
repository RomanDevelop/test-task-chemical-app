import 'dart:async';
import '../models/auth_models.dart';
import '../models/user.dart';
import 'auth_storage_service.dart';

class AuthService {
  static const Duration _mockDelay = Duration(milliseconds: 800);
  static const String _mockUserEmail = 'test@example.com';
  static const String _mockUserPassword = 'password123';
  static const String _mockUserId = 'user_123';
  static const String _mockUserName = 'Test User';

  static Future<AuthResponse> login(LoginRequest request) async {
    await Future.delayed(_mockDelay);

    if (request.email == _mockUserEmail && request.password == _mockUserPassword) {
      final user = User(id: _mockUserId, email: _mockUserEmail, name: _mockUserName);

      final token = _generateMockToken();
      final expiresAt = DateTime.now().add(const Duration(hours: 24));

      final response = AuthResponse(user: user, token: token, expiresAt: expiresAt);

      await AuthStorageService.saveSession(response);

      return response;
    } else {
      throw Exception('Неверный email или пароль');
    }
  }

  static Future<AuthResponse> register(RegisterRequest request) async {
    await Future.delayed(_mockDelay);

    if (request.email.contains('@') && request.password.length >= 6 && request.name.isNotEmpty) {
      final user = User(id: 'user_${DateTime.now().millisecondsSinceEpoch}', email: request.email, name: request.name);

      final token = _generateMockToken();
      final expiresAt = DateTime.now().add(const Duration(hours: 24));

      final response = AuthResponse(user: user, token: token, expiresAt: expiresAt);

      await AuthStorageService.saveSession(response);

      return response;
    } else {
      throw Exception('Неверные данные для регистрации');
    }
  }

  static Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    await AuthStorageService.clearSession();
  }

  static Future<User?> getCurrentUser() async {
    final session = await AuthStorageService.getSession();
    if (session == null) return null;

    final now = DateTime.now();
    if (session.expiresAt.isBefore(now)) {
      await AuthStorageService.clearSession();
      return null;
    }

    return session.user;
  }

  static Future<bool> isAuthenticated() async {
    final user = await getCurrentUser();
    return user != null;
  }

  static String _generateMockToken() {
    return 'mock_token_${DateTime.now().millisecondsSinceEpoch}';
  }
}
