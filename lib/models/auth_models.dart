import 'user.dart';

class LoginRequest {
  final String email;
  final String password;

  const LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password};
  }
}

class RegisterRequest {
  final String email;
  final String password;
  final String name;

  const RegisterRequest({required this.email, required this.password, required this.name});

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password, 'name': name};
  }
}

class AuthResponse {
  final User user;
  final String token;
  final DateTime expiresAt;

  const AuthResponse({required this.user, required this.token, required this.expiresAt});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {'user': user.toJson(), 'token': token, 'expiresAt': expiresAt.toIso8601String()};
  }
}

enum AuthStatus { initial, authenticated, unauthenticated }

class AuthState {
  final AuthStatus status;
  final User? user;
  final String? error;

  const AuthState({required this.status, this.user, this.error});

  AuthState copyWith({AuthStatus? status, User? user, String? error, bool clearError = false, bool clearUser = false}) {
    return AuthState(
      status: status ?? this.status,
      user: clearUser ? null : (user ?? this.user),
      error: clearError ? null : (error ?? this.error),
    );
  }

  bool get isAuthenticated => status == AuthStatus.authenticated && user != null;
  bool get isUnauthenticated => status == AuthStatus.unauthenticated;
}
