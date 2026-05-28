import 'dart:io';

import 'package:flutter/material.dart';

import '../../../core/services/location_service.dart';
import '../data/report_service.dart';

class ReportProvider extends ChangeNotifier {
  final ReportService _reportService = ReportService();

  bool isLoading = false;

  Future<bool> createReport({
    required String reportType,
    required String description,
    int? zoneId,
    File? image,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final position = await LocationService.getCurrentLocation();

      await _reportService.createReport(
        reportType: reportType,
        description: description,
        zoneId: zoneId,
        latitude: position?.latitude,
        longitude: position?.longitude,
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