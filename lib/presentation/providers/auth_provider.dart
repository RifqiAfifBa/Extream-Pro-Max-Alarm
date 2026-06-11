import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState {
  final bool isLoggedIn;
  final String username;
  final String storedUsername;
  final String storedPassword;

  const AuthState({
    this.isLoggedIn = false,
    this.username = '',
    this.storedUsername = 'JohnDoe',
    this.storedPassword = '123',
  });

  AuthState copyWith({
    bool? isLoggedIn,
    String? username,
    String? storedUsername,
    String? storedPassword,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      username: username ?? this.username,
      storedUsername: storedUsername ?? this.storedUsername,
      storedPassword: storedPassword ?? this.storedPassword,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  bool login(String username, String password) {
    if (username == state.storedUsername && password == state.storedPassword) {
      state = state.copyWith(isLoggedIn: true, username: username);
      return true;
    }
    return false;
  }

  void logout() {
    state = state.copyWith(isLoggedIn: false, username: '');
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
