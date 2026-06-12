// lib/providers/auth_provider.dart
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _authService.isLoggedIn;
  String? get currentUsername => _authService.currentUsername;
  String? get currentFullName => _authService.currentFullName;
  int? get currentUserId => _authService.currentUserId;

  Future<bool> login(String username, String password) async {
    _setLoading(true);
    _errorMessage = null;

    final success = await _authService.login(username, password);

    _setLoading(false);

    if (!success) {
      _errorMessage = 'Username atau password salah';
    }

    notifyListeners();
    return success;
  }

  Future<bool> register(
      String username, String password, String fullName) async {
    _setLoading(true);
    _errorMessage = null;

    final success = await _authService.register(username, password, fullName);

    _setLoading(false);

    if (!success) {
      _errorMessage = 'Username sudah terdaftar';
    }

    notifyListeners();
    return success;
  }

  Future<void> logout() async {
    await _authService.logout();
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
