import 'package:flutter/material.dart';

import '../../../core/services/token_storage.dart';
import '../data/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool isLoading = false;
  bool isAuthenticated = false;

  String? name;
  String? email;

  Future<void> checkAuth() async {
    final token = await TokenStorage.getToken();

    isAuthenticated = token != null;

    if (isAuthenticated) {
      try {
        final user = await _authService.me();

        name = user['name'];
        email = user['email'];
      } catch (_) {
        await TokenStorage.removeToken();
        isAuthenticated = false;
      }
    }

    notifyListeners();
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final user = await _authService.login(
        email: email,
        password: password,
      );

      name = user['name'];
      this.email = user['email'];

      isAuthenticated = true;
      return true;
    } catch (_) {
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authService.logout();

    name = null;
    email = null;
    isAuthenticated = false;

    notifyListeners();
  }
}