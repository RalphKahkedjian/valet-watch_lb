import 'package:flutter/material.dart';

import '../data/parking_session_service.dart';

class ParkingSessionProvider extends ChangeNotifier {
  final ParkingSessionService _service = ParkingSessionService();

  bool isLoading = false;
  String? lastMessage;
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
    required double latitude,
    required double longitude,
  }) async {
    try {
      isLoading = true;
      lastMessage = null;
      notifyListeners();

      lastMessage = await _service.startSession(
        vehicleId: vehicleId,
        latitude: latitude,
        longitude: longitude,
      );

      await fetchSessions();
      return true;
    } catch (_) {
      lastMessage = null;
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