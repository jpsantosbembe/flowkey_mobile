import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class AuthViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  UserModel? _user;
  bool _isLoading = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;

  Future<bool> login(String email, String password) async {
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
      return true;
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> logout() async {
    await _storage.delete(key: 'token');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    _user = null;
    notifyListeners();
  }

  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString('user');

    if (userData != null) {
      _user = UserModel.fromJson(jsonDecode(userData));
      notifyListeners();
    }
  }
}
