import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

// Nova classe para armazenar credenciais de login
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

  // Método para salvar credenciais
  Future<void> saveCredentials(String email, String password) async {
    await _storage.write(key: 'saved_email', value: email);
    await _storage.write(key: 'saved_password', value: password);
  }

  // Método para obter credenciais salvas
  Future<SavedCredentials?> getSavedCredentials() async {
    final email = await _storage.read(key: 'saved_email');
    final password = await _storage.read(key: 'saved_password');

    if (email != null && password != null) {
      return SavedCredentials(email: email, password: password);
    }

    return null;
  }

  // Método para limpar credenciais salvas
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

    // Não limpa as credenciais salvas aqui, elas devem permanecer
    // para que o usuário possa fazer login novamente com facilidade
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  void setRole(String role) {
    _selectedRole = role;
    notifyListeners();
  }

  // Verificar se o usuário está logado ao iniciar o aplicativo
  Future<bool> checkLoggedInUser() async {
    final token = await _storage.read(key: 'token');

    if (token != null) {
      // Carregar os dados do usuário do SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('user');

      if (userData != null) {
        try {
          _user = UserModel.fromJson(jsonDecode(userData));

          // Se o usuário tem apenas um papel, já o define
          if (_user!.roles.length == 1) {
            _selectedRole = _user!.roles.first;
          }

          notifyListeners();
          return true;
        } catch (e) {
          // Se houver erro ao decodificar os dados, limpa tudo
          await logout();
        }
      }
    }

    return false;
  }
}