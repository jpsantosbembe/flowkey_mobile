import 'package:dio/dio.dart';

import '../models/authorization_model.dart';
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
        print(response.data);
        return data.map((json) => LoanModel.fromJson(json)).toList();
      }
    } catch (e) {
      print('Erro ao buscar empréstimos ativos: $e');
    }
    return [];
  }


  Future<List<KeyModel>> fetchKeys(int userId, String token, {bool isCoordinator = false}) async {
    try {
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

  Future<List<AuthorizationModel>> fetchLaboratoryAccess(int coordinatorId, int keyId, String token) async {
    try {
      String endpoint = '$apiUrl/api/coordinator/$coordinatorId/key/$keyId/laboratory-access';

      Response response = await _dio.get(
        endpoint,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data['key']['authorizations'];
        return data.map((json) => AuthorizationModel.fromJson(json)).toList();
      }
    } catch (e) {
      print('Erro ao buscar acessos ao laboratório: $e');
    }
    return [];
  }

  Future<bool> revokeAccess(int userId, int keyId, String token) async {
    try {
      String endpoint = '$apiUrl/api/key/revoke'; // 🔥 Certifique-se de que a URL está correta

      Response response = await _dio.post(
        endpoint,
        data: {
          "user_id": userId,
          "key_id": keyId,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token', // 🔥 Garante que o token está sendo enviado
            'Content-Type': 'application/json', // 🔥 Garante que o servidor reconhece o JSON
          },
        ),
      );

      if (response.statusCode == 200) {
        return true; // ✅ Remoção bem-sucedida
      } else {
        print("Erro ao revogar acesso: ${response.statusCode} - ${response.data}");
        return false;
      }
    } catch (e) {
      print('Erro ao revogar acesso: $e'); // 🔥 Agora veremos o erro real no console
      return false;
    }
  }

  Future<List<UserModel>> searchUsers(String query, String token) async {
    try {
      String endpoint = '$apiUrl/api/user/search?query=$query';

      Response response = await _dio.get(
        endpoint,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => UserModel.fromJson(json)).toList();
      }
    } catch (e) {
      print('Erro ao buscar usuários: $e');
    }
    return [];
  }

}
