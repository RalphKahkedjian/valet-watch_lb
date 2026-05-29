import 'dart:io';

import 'package:flutter/material.dart';

import '../data/car_scan_service.dart';

class CarScanProvider extends ChangeNotifier {
  final CarScanService _service = CarScanService();

  bool isLoading = false;

  Future<bool> uploadScan({
    required int parkingSessionId,
    required String scanType,
    required File image,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      await _service.uploadScan(
        parkingSessionId: parkingSessionId,
        scanType: scanType,
        image: image,
      );

      return true;
    } catch (_) {
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}