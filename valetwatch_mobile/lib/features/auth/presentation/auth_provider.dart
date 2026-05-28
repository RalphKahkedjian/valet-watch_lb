import 'package:flutter/material.dart';

import '../../../core/services/token_storage.dart';
import '../data/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool isLoading = false;
  bool isAuthenticated = false;

  Future<void> checkAuth() async {
    final token = await TokenStorage.getToken();
    isAuthenticated = token != null;
    notifyListeners();
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      await _authService.login(
        email: email,
        password: password,
      );

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
    isAuthenticated = false;
    notifyListeners();
  }
}