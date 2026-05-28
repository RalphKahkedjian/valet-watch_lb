import 'package:dio/dio.dart';

import '../../../../core/network/dio_client.dart';
import '../models/vehicle_model.dart';

class VehicleService {
  final Dio _dio = DioClient.dio;

  Future<List<VehicleModel>> getVehicles() async {
    final response = await _dio.get('/vehicles');

    final List data = response.data['data'];

    return data
        .map((json) => VehicleModel.fromJson(json))
        .toList();
  }

  Future<void> createVehicle({
    required String brand,
    required String model,
    required String plateNumber,
    required String color,
  }) async {
    await _dio.post(
      '/vehicles',
      data: {
        'brand': brand,
        'model': model,
        'plate_number': plateNumber,
        'color': color,
      },
    );
  }
}