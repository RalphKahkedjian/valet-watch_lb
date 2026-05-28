import 'package:flutter/material.dart';

import '../data/parking_session_service.dart';

class ParkingSessionProvider extends ChangeNotifier {
  final ParkingSessionService _service = ParkingSessionService();

  bool isLoading = false;
  List<dynamic> sessions = [];

  Future<void> fetchSessions() async {
    try {
      isLoading = true;
      notifyListeners();

      sessions = await _service.getSessions();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> startSession({
    required int vehicleId,
    int? zoneId,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      await _service.startSession(
        vehicleId: vehicleId,
        zoneId: zoneId,
      );

      await fetchSessions();

      return true;
    } catch (_) {
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> completeSession(int sessionId) async {
  try {
    isLoading = true;
    notifyListeners();

    await _service.completeSession(sessionId);

    await fetchSessions();

    return true;
  } catch (_) {
    return false;
  } finally {
    isLoading = false;
    notifyListeners();
  }
}
}