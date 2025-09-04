import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/services/auth_service.dart';

class AuthProvider with ChangeNotifier{
  final AuthService _authService = AuthService();

  String? _token;
  bool _isLoading = true;
  String? _error;

  String? get token => _token;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _token != null;

  AuthProvider(){
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final response = await _authService.login(username, password);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', response);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String username, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
     try {
       await _authService.register(username, email, password);
       _isLoading = false;
       notifyListeners();
       return true;
     } catch(e) {
       _error = e.toString();
       _isLoading = false;
       notifyListeners();
       return false;
     }
  }

  Future<void> logout() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    notifyListeners();
  }
}