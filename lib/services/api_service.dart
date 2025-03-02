import 'package:dio/dio.dart';

import '../models/key_model.dart';
import '../models/loan_model.dart';

class ApiService {
  final Dio _dio = Dio();
  
  var apiUrl = 'http://172.16.0.100:8000';

  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      Response response = await _dio.post(
        '$apiUrl/api/login',
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

  Future<List<KeyModel>> fetchUserKeys(int userId, String token, {bool isCoordinator = false}) async {
    try {
      // 🔥 Se for coordenador, busca na rota correta
      String endpoint = isCoordinator
          ? '$apiUrl/api/user/$userId/coordinator-keys'
          : '$apiUrl/api/user/$userId/keys';

      Response response = await _dio.get(
        endpoint,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => KeyModel.fromJson(json['key'] ?? json)).toList();
      }
    } catch (e) {
      print('Erro ao buscar chaves: $e');
    }
    return [];
  }


  Future<List<LoanModel>> fetchActiveLoans(int userId, String token, {bool isCoordinator = false}) async {
    try {
      // 🔥 Se for coordenador, busca na rota correta
      String endpoint = isCoordinator
          ? '$apiUrl/api/coordinator/$userId/loans/active'
          : '$apiUrl/api/user/$userId/loans/active';

      Response response = await _dio.get(
        endpoint,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => LoanModel.fromJson(json)).toList();
      }
    } catch (e) {
      print('Erro ao buscar empréstimos ativos: $e');
    }
    return [];
  }


  Future<List<KeyModel>> fetchKeys(int userId, String token, {bool isCoordinator = false}) async {
    try {
      // 🔥 Se for coordenador, busca na rota correta
      String endpoint = isCoordinator
          ? '$apiUrl/api/user/$userId/coordinator-keys'
          : '$apiUrl/api/user/$userId/keys';

      Response response = await _dio.get(
        endpoint,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => KeyModel.fromJson(json['key'] ?? json)).toList();
      }
    } catch (e) {
      print('Erro ao buscar chaves: $e');
    }
    return [];
  }


}
