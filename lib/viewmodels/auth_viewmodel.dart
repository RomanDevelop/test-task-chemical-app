import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/auth_models.dart';
import '../services/auth_service.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState(status: AuthStatus.initial)) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      final user = await AuthService.getCurrentUser();
      if (user != null) {
        state = AuthState(status: AuthStatus.authenticated, user: user);
      } else {
        state = const AuthState(status: AuthStatus.unauthenticated);
      }
    } catch (e) {
      state = AuthState(status: AuthStatus.unauthenticated, error: 'Ошибка проверки авторизации');
    }
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(status: AuthStatus.initial, error: null, clearError: true);

    try {
      final request = LoginRequest(email: email, password: password);
      final response = await AuthService.login(request);

      state = AuthState(status: AuthStatus.authenticated, user: response.user);

      return true;
    } catch (e) {
      state = AuthState(status: AuthStatus.unauthenticated, error: e.toString().replaceAll('Exception: ', ''));
      return false;
    }
  }

  Future<bool> register(String email, String password, String name) async {
    state = state.copyWith(status: AuthStatus.initial, error: null, clearError: true);

    try {
      final request = RegisterRequest(email: email, password: password, name: name);
      final response = await AuthService.register(request);

      state = AuthState(status: AuthStatus.authenticated, user: response.user);

      return true;
    } catch (e) {
      state = AuthState(status: AuthStatus.unauthenticated, error: e.toString().replaceAll('Exception: ', ''));
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await AuthService.logout();
      state = const AuthState(status: AuthStatus.unauthenticated);
    } catch (e) {
      state = AuthState(status: AuthStatus.unauthenticated, error: 'Ошибка при выходе');
    }
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}
