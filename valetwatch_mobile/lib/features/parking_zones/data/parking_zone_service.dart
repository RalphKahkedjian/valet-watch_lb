import 'package:dio/dio.dart';

import '../../../core/network/dio_client.dart';
import '../../../shared/models/parking_zone.dart';

class ParkingZoneService {
  final Dio _dio = DioClient.dio;

  Future<List<ParkingZone>> getZones() async {
    final response = await _dio.get('/parking-zones');

    final List data = response.data['data'];

    return data
        .map((json) => ParkingZone.fromJson(json))
        .toList();
  }
}