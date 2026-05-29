import 'dart:io';

import 'package:dio/dio.dart';

import '../../../core/network/dio_client.dart';

class CarScanService {
  final Dio _dio = DioClient.dio;

  Future<void> uploadScan({
    required int parkingSessionId,
    required String scanType,
    required File image,
  }) async {
    final formData = FormData.fromMap({
      'parking_session_id': parkingSessionId,
      'scan_type': scanType,
      'image': await MultipartFile.fromFile(
        image.path,
        filename: image.path.split('/').last,
      ),
    });

    await _dio.post(
      '/car-scans',
      data: formData,
    );
  }
}