import 'package:dio/dio.dart';

import '../../../core/network/dio_client.dart';
import '../../../core/services/token_storage.dart';

class AuthService {
  final Dio _dio = DioClient.dio;

  Future<void> login({
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

    await TokenStorage.saveToken(token);
  }

  Future<void> logout() async {
    await _dio.post('/logout');
    await TokenStorage.removeToken();
  }
}