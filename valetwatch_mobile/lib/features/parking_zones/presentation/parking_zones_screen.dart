import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'parking_zone_provider.dart';

class ParkingZonesScreen extends StatefulWidget {
  const ParkingZonesScreen({super.key});

  @override
  State<ParkingZonesScreen> createState() =>
      _ParkingZonesScreenState();
}

class _ParkingZonesScreenState
    extends State<ParkingZonesScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<ParkingZoneProvider>().fetchZones();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider =
        context.watch<ParkingZoneProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Parking Zones'),
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.zones.length,
              itemBuilder: (context, index) {
                final zone = provider.zones[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Icon(
                      Icons.location_on,
                      color: zone.status == 'approved'
                          ? Colors.green
                          : Colors.orange,
                    ),
                    title: Text(zone.name),
                    subtitle: Text(
                      '${zone.status} • ${zone.officialPrice} L.L',
                    ),
                    trailing: Text('${zone.radius}m'),
                  ),
                );
              },
            ),
    );
  }
}