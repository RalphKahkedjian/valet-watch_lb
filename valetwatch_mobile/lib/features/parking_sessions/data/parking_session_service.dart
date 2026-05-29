import 'package:dio/dio.dart';

import '../../../core/network/dio_client.dart';

class ParkingSessionService {
  final Dio _dio = DioClient.dio;

  Future<String> startSession({
    required int vehicleId,
    required double latitude,
    required double longitude,
  }) async {
    final response = await _dio.post(
      '/parking-sessions',
      data: {
        'vehicle_id': vehicleId,
        'latitude': latitude,
        'longitude': longitude,
      },
    );

    return response.data['message'];
  }

  Future<void> completeSession(int sessionId) async {
    await _dio.patch('/parking-sessions/$sessionId/complete');
  }

  Future<List<dynamic>> getSessions() async {
    final response = await _dio.get('/parking-sessions');
    return response.data['data'];
  }
}