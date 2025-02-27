import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      Response response = await _dio.post(
        'http://172.16.0.100:8000/api/login',
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
}
