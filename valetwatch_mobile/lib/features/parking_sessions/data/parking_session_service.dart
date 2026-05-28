import 'package:dio/dio.dart';

import '../../../core/network/dio_client.dart';

class ParkingSessionService {
  final Dio _dio = DioClient.dio;

  Future<void> startSession({
    required int vehicleId,
    int? zoneId,
  }) async {
    await _dio.post(
      '/parking-sessions',
      data: {
        'vehicle_id': vehicleId,
        'zone_id': zoneId,
        'official_price': 400000,
      },
    );
  }

  Future<void> completeSession(int sessionId) async {
  await _dio.patch(
    '/parking-sessions/$sessionId/complete',
  );
}

  Future<List<dynamic>> getSessions() async {
    final response = await _dio.get('/parking-sessions');
    return response.data['data'];
  }
}