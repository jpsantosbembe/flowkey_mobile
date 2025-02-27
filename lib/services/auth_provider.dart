import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';

class AuthProvider with ChangeNotifier {
  final Dio _dio = Dio();
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<bool> login(String email, String password) async {
    try {
      Response response = await _dio.post(
        'http://172.16.0.100:8000/api/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      if (response.statusCode == 200) {
        await _storage.write(key: 'token', value: response.data['token']);
        return true;
      }
    } catch (e) {
      print('Erro ao logar: $e');
    }
    return false;
  }

  Future<void> logout() async {
    await _storage.delete(key: 'token');
    notifyListeners();
  }
}
