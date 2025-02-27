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
  String? _selectedRole;
  bool _isLoading = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get selectedRole => _selectedRole;

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

      if (!context.mounted) return false; // ✅ Verifica se a tela ainda está ativa

      // **Se houver mais de um papel, vai para a tela de seleção**
      if (_user!.roles.length > 1) {
        Navigator.pushReplacementNamed(context, '/role_selection');
      } else {
        // **Se houver um único papel, já define e vai para Home**
        _selectedRole = _user!.roles.first;
        Navigator.pushReplacementNamed(context, '/home');
      }

      return true;
    }

    _isLoading = false;
    notifyListeners();

    if (!context.mounted) return false; // ✅ Verifica antes de exibir o alerta

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Falha no login! Verifique suas credenciais.')),
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

}
