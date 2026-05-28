import 'package:flutter/material.dart';

import '../../features/auth/presentation/home_screen.dart';
import '../../features/parking_zones/presentation/parking_zones_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/reports/presentation/report_screen.dart';
import '../../features/map/presentation/map_screen.dart';
import '../../features/vehicles/presentation/screens/vehicles_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() =>
      _MainNavigationState();
}

class _MainNavigationState
    extends State<MainNavigation> {
  int currentIndex = 0;

  final screens = const [
    HomeScreen(),
    ParkingZonesScreen(),
    MapScreen(),
    VehiclesScreen(),
    ReportScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],

      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        destinations: const [
  NavigationDestination(
    icon: Icon(Icons.dashboard_outlined),
    selectedIcon: Icon(Icons.dashboard),
    label: 'Home',
  ),
  NavigationDestination(
    icon: Icon(Icons.local_parking_outlined),
    selectedIcon: Icon(Icons.local_parking),
    label: 'Zones',
  ),
  NavigationDestination(
    icon: Icon(Icons.map_outlined),
    selectedIcon: Icon(Icons.map),
    label: 'Map',
  ),
  NavigationDestination(
    icon: Icon(Icons.report_outlined),
    selectedIcon: Icon(Icons.report),
    label: 'Report',
  ),
  NavigationDestination(
    icon: Icon(Icons.directions_car_outlined),
    selectedIcon: Icon(Icons.directions_car),
    label: 'Vehicles',
  ),
  NavigationDestination(
    icon: Icon(Icons.person_outline),
    selectedIcon: Icon(Icons.person),
    label: 'Profile',
  ),
],
      ),
    );
  }
}