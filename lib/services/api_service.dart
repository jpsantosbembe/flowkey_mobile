import 'package:dio/dio.dart';

import '../models/key_model.dart';

class ApiService {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      Response response = await _dio.post(
        'http://192.168.15.167:8000/api/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      print('Erro ao logar: $e');
    }
    return null;
  }

  Future<List<KeyModel>> fetchUserKeys(int userId, String token) async {
    try {
      Response response = await _dio.get(
        'http://192.168.15.167:8000/api/user/$userId/keys',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => KeyModel.fromJson(json)).toList();
      }
    } catch (e) {
      print('Erro ao buscar chaves: $e');
    }
    return [];
  }

}
