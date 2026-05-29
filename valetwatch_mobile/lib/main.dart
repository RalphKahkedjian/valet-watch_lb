import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valetwatch_mobile/features/reports/presentation/report_provider.dart';

import 'core/routes/app_router.dart';
import 'features/auth/presentation/auth_provider.dart';
import 'features/parking_zones/presentation/parking_zone_provider.dart';
import 'features/vehicles/presentation/providers/vehicle_provider.dart';
import 'features/parking_sessions/presentation/parking_session_provider.dart';
import 'features/car_scans/presentation/car_scan_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider()..checkAuth(),
        ),
        ChangeNotifierProvider(
          create: (_) => ParkingZoneProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ReportProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => VehicleProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ParkingSessionProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CarScanProvider(),
        ),
      ],
      child: const ValetWatchApp(),
    ),
  );
}

class ValetWatchApp extends StatelessWidget {
  const ValetWatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ValetWatch',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.blueGrey,
        useMaterial3: true,
      ),
      routerConfig: AppRouter.router(context),
    );
  }
}