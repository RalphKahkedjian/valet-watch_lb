import 'package:dio/dio.dart';

import '../../../core/network/dio_client.dart';
import '../../../core/services/token_storage.dart';

class AuthService {
  final Dio _dio = DioClient.dio;

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(
      '/login',
      data: {
        'email': email,
        'password': password,
      },
    );

    final token = response.data['token'];
    final user = response.data['user'];

    await TokenStorage.saveToken(token);

    return user;
  }

  Future<Map<String, dynamic>> me() async {
    final response = await _dio.get('/me');
    return response.data['user'];
  }

  Future<void> logout() async {
    await _dio.post('/logout');
    await TokenStorage.removeToken();
  }
}