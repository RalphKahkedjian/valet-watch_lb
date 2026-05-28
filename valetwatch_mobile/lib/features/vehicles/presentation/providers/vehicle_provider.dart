import 'package:flutter/material.dart';

import '../../data/models/vehicle_model.dart';
import '../../data/services/vehicle_service.dart';

class VehicleProvider extends ChangeNotifier {
  final VehicleService _vehicleService =
      VehicleService();

  bool isLoading = false;

  List<VehicleModel> vehicles = [];

  Future<void> fetchVehicles() async {
    try {
      isLoading = true;
      notifyListeners();

      vehicles =
          await _vehicleService.getVehicles();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createVehicle({
    required String brand,
    required String model,
    required String plateNumber,
    required String color,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      await _vehicleService.createVehicle(
        brand: brand,
        model: model,
        plateNumber: plateNumber,
        color: color,
      );

      await fetchVehicles();

      return true;
    } catch (_) {
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}