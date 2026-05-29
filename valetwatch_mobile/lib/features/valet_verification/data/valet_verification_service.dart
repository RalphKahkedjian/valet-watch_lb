import 'package:dio/dio.dart';

import '../../../core/network/dio_client.dart';

class ValetVerificationService {
  final Dio _dio = DioClient.dio;

  Future<Map<String, dynamic>> verifyQr({
    required int attendantId,
    required int zoneId,
  }) async {
    final response = await _dio.post(
      '/valet/verify-qr',
      data: {
        'attendant_id': attendantId,
        'zone_id': zoneId,
      },
    );

    return response.data;
  }
}