import 'dart:io';

import 'package:dio/dio.dart';

import '../../../core/network/dio_client.dart';

class ReportService {
  final Dio _dio = DioClient.dio;

  Future<void> createReport({
    required String reportType,
    required String description,
    double? latitude,
    double? longitude,
    int? zoneId,
    File? image,
  }) async {
    final formData = FormData.fromMap({
      'zone_id': zoneId,
      'latitude': latitude,
      'longitude': longitude,
      'report_type': reportType,
      'description': description,
      if (image != null)
        'image': await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        ),
    });

    await _dio.post(
      '/parking-zone-reports',
      data: formData,
    );
  }
}