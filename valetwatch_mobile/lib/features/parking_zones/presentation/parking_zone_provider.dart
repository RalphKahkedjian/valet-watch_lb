import 'package:flutter/material.dart';

import '../../../shared/models/parking_zone.dart';
import '../data/parking_zone_service.dart';

class ParkingZoneProvider extends ChangeNotifier {
  final ParkingZoneService _service = ParkingZoneService();

  bool isLoading = false;
  List<ParkingZone> zones = [];

  Future<void> fetchZones() async {
    try {
      isLoading = true;
      notifyListeners();

      zones = await _service.getZones();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}