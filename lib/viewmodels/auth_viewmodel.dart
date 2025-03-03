import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class SavedCredentials {
  final String email;
  final String password;

  SavedCredentials({required this.email, required this.password});
}

class AuthViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  UserModel? _user;
  String? _selectedRole;
  bool _isLoading = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get selectedRole => _selectedRole;

  Future<void> saveCredentials(String email, String password) async {
    await _storage.write(key: 'saved_email', value: email);
    await _storage.write(key: 'saved_password', value: password);
  }

  Future<SavedCredentials?> getSavedCredentials() async {
    final email = await _storage.read(key: 'saved_email');
    final password = await _storage.read(key: 'saved_password');

    if (email != null && password != null) {
      return SavedCredentials(email: email, password: password);
    }

    return null;
  }

  Future<void> clearSavedCredentials() async {
    await _storage.delete(key: 'saved_email');
    await _storage.delete(key: 'saved_password');
  }

  Future<bool> login(String email, String password, BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    final data = await _apiService.login(email, password);

    if (data != null && data.containsKey('token')) {
      await _storage.write(key: 'token', value: data['token']);
      _user = UserModel.fromJson(data['user']);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', jsonEncode(data['user']));

      _isLoading = false;
      notifyListeners();

      if (!context.mounted) return false;

      if (_user!.roles.length > 1) {
        Navigator.pushReplacementNamed(context, '/role_selection');
      } else {
        _selectedRole = _user!.roles.first;
        Navigator.pushReplacementNamed(context, '/home');
      }

      return true;
    }

    _isLoading = false;
    notifyListeners();

    if (!context.mounted) return false;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Falha no login! Verifique suas credenciais.'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );

    return false;
  }

  Future<void> logout() async {
    await _storage.delete(key: 'token');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    _user = null;
    _selectedRole = null;
    notifyListeners();
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  void setRole(String role) {
    _selectedRole = role;
    notifyListeners();
  }

  Future<bool> checkLoggedInUser() async {
    final token = await _storage.read(key: 'token');

    if (token != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('user');

      if (userData != null) {
        try {
          _user = UserModel.fromJson(jsonDecode(userData));

          if (_user!.roles.length == 1) {
            _selectedRole = _user!.roles.first;
          }

          notifyListeners();
          return true;
        } catch (e) {
          await logout();
        }
      }
    }
    return false;
  }

}