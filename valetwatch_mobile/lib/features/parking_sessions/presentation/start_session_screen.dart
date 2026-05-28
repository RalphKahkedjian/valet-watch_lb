import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../parking_zones/presentation/parking_zone_provider.dart';
import '../../vehicles/presentation/providers/vehicle_provider.dart';
import 'parking_session_provider.dart';

class StartSessionScreen extends StatefulWidget {
  const StartSessionScreen({super.key});

  @override
  State<StartSessionScreen> createState() =>
      _StartSessionScreenState();
}

class _StartSessionScreenState
    extends State<StartSessionScreen> {
  int? selectedVehicleId;
  int? selectedZoneId;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<VehicleProvider>().fetchVehicles();
      context.read<ParkingZoneProvider>().fetchZones();
      context.read<ParkingSessionProvider>().fetchSessions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vehicleProvider =
        context.watch<VehicleProvider>();

    final zoneProvider =
        context.watch<ParkingZoneProvider>();

    final sessionProvider =
        context.watch<ParkingSessionProvider>();

    final approvedZones = zoneProvider.zones
        .where((zone) => zone.status == 'approved')
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Parking Sessions'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Start Parking Session',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 18),

                    DropdownButtonFormField<int>(
                      value: selectedVehicleId,
                      decoration:
                          const InputDecoration(
                        labelText: 'Select Vehicle',
                        border:
                            OutlineInputBorder(),
                      ),
                      items: vehicleProvider.vehicles
                          .map((vehicle) {
                        return DropdownMenuItem(
                          value: vehicle.id,
                          child: Text(
                            '${vehicle.brand} ${vehicle.model} (${vehicle.plateNumber})',
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedVehicleId = value;
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    DropdownButtonFormField<int>(
                      value: selectedZoneId,
                      decoration:
                          const InputDecoration(
                        labelText:
                            'Select Approved Parking Zone',
                        border:
                            OutlineInputBorder(),
                      ),
                      items: approvedZones.map((zone) {
                        return DropdownMenuItem(
                          value: zone.id,
                          child: Text(
                            '${zone.name} (${zone.officialPrice} L.L)',
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedZoneId = value;
                        });
                      },
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed:
                            selectedVehicleId == null ||
                                    selectedZoneId == null
                                ? null
                                : () async {
                                    final success =
                                        await sessionProvider
                                            .startSession(
                                      vehicleId:
                                          selectedVehicleId!,
                                      zoneId:
                                          selectedZoneId!,
                                    );

                                    if (!context
                                        .mounted) {
                                      return;
                                    }

                                    ScaffoldMessenger.of(
                                            context)
                                        .showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          success
                                              ? 'Parking session started'
                                              : 'Failed to start session',
                                        ),
                                      ),
                                    );
                                  },
                        icon: const Icon(
                          Icons.play_arrow,
                        ),
                        label: const Text(
                          'Start Session',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            Expanded(
              child: sessionProvider.isLoading
                  ? const Center(
                      child:
                          CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      itemCount:
                          sessionProvider.sessions.length,
                      itemBuilder: (context, index) {
                        final session =
                            sessionProvider.sessions[index];

                        final status = session['status'] ?? 'active';

return Card(
  margin: const EdgeInsets.only(bottom: 12),
  child: ListTile(
    leading: CircleAvatar(
      backgroundColor:
          status == 'completed' ? Colors.green.shade100 : Colors.blue.shade100,
      child: Icon(
        status == 'completed'
            ? Icons.check
            : Icons.local_parking,
      ),
    ),
    title: Text(
      session['vehicle']?['plate_number'] ?? 'Vehicle',
    ),
    subtitle: Text(
      '${session['zone']?['name'] ?? 'No zone'} • $status',
    ),
    trailing: status == 'active'
        ? TextButton(
            onPressed: () async {
              final success =
                  await sessionProvider.completeSession(session['id']);

              if (!context.mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    success
                        ? 'Session completed'
                        : 'Failed to complete session',
                  ),
                ),
              );
            },
            child: const Text('Complete'),
          )
        : Text(
            '${session['official_price'] ?? '-'} L.L',
          ),
  ),
);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}