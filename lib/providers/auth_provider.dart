import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool isLoading = false;
  String? errorMessage;

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.keyToken);
    return token != null && token.isNotEmpty;
  }

  Future<void> loadRememberedEmail(
      TextEditingController emailController, ValueNotifier<bool> rememberMe) async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(AppConstants.keyRememberEmail);
    final remember = prefs.getBool(AppConstants.keyRememberMe) ?? false;
    if (remember && email != null) {
      emailController.text = email;
      rememberMe.value = true;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final result = await _authService.login(email: email, password: password);
      if (result.status && result.accessToken != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(AppConstants.keyToken, result.accessToken!);
        await prefs.setBool(AppConstants.keyRememberMe, rememberMe);
        if (rememberMe) {
          await prefs.setString(AppConstants.keyRememberEmail, email);
        } else {
          await prefs.remove(AppConstants.keyRememberEmail);
        }
        isLoading = false;
        notifyListeners();
        return true;
      } else {
        errorMessage = result.message ?? 'The login credentials are incorrect.';
      }
    } catch (e) {
      errorMessage = 'Something went wrong. Please try again.';
    }

    isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.keyToken);
  }
}
