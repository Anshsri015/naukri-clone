import 'package:flutter/material.dart';
import '../core/api_service.dart';
import '../models/user_model.dart';
import 'package:dio/dio.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  String? _error;
  bool _isFirstLogin = true;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isFirstLogin => _isFirstLogin;

  // Register
  Future<bool> register(String name, String email, String password, {String? phone}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await ApiService.register({
        'name': name,
        'email': email,
        'password': password,
        if (phone != null) 'phone': phone,
      });
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      if (e is DioException) {
        print('🔴 DioException: ${e.response?.statusCode} - ${e.response
            ?.data} - ${e.message}');
        _error = e.response?.data['message'] ??
            'Registration failed. Please try again.';
      } else {
        print('🔴 Unknown error: $e');
        _error = 'Registration failed. Please try again.';
      }
      notifyListeners();
      return false;
    }
  }

  // Login
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.login({
        'email': email,
        'password': password,
      });
      _user = UserModel.fromJson(response.data['user']);
      await ApiService.setToken(response.data['token']);

      // Check if profile already exists
      try {
        await ApiService.getProfile();
        _isFirstLogin = false; // Profile exists — skip onboarding
      } catch (e) {
        _isFirstLogin = true; // No profile — show onboarding
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = 'Invalid email or password.';
      notifyListeners();
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    _user = null;
    _isFirstLogin = true;
    await ApiService.clearToken();
    notifyListeners();
  }
}

