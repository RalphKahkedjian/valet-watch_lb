import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../parking_zones/presentation/parking_zone_provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() =>
      _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
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
        title: const Text('Valet Map'),
      ),
      body: provider.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : FlutterMap(
              options: MapOptions(
                initialCenter: const LatLng(
                  33.8938,
                  35.5018,
                ),
                initialZoom: 13,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName:
                      'com.valetwatch.mobile',
                ),

                MarkerLayer(
                  markers: provider.zones.map((zone) {
                    return Marker(
                      point: LatLng(
                        zone.latitude,
                        zone.longitude,
                      ),
                      width: 80,
                      height: 80,
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (_) {
                              return Padding(
                                padding:
                                    const EdgeInsets.all(24),
                                child: Column(
                                  mainAxisSize:
                                      MainAxisSize.min,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      zone.name,
                                      style:
                                          const TextStyle(
                                        fontSize: 22,
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(
                                        height: 12),

                                    Text(
                                      'Official Price: ${zone.officialPrice} L.L',
                                    ),

                                    const SizedBox(
                                        height: 8),

                                    Text(
                                      'Radius: ${zone.radius}m',
                                    ),

                                    const SizedBox(
                                        height: 8),

                                    Text(
                                      'Status: ${zone.status}',
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: Icon(
                          Icons.location_on,
                          size: 42,
                          color:
                              zone.status == 'approved'
                                  ? Colors.green
                                  : Colors.orange,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
    );
  }
}