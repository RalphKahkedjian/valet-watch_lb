import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../parking_zones/presentation/parking_zone_provider.dart';

// ─── Brand Colors ─────────────────────────────────────────────────────────────
const _kRust    = Color(0xFFAB3C26);
const _kGreen   = Color(0xFF689451);
const _kCream   = Color(0xFFF5F2F2);
const _kDark    = Color(0xFF1A1208);
const _kSurface = Color(0xFFFDF9F8);
const _kCard    = Color(0xFFFFFFFF);

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<ParkingZoneProvider>().fetchZones());
  }

  // ─── Zone Detail Sheet ────────────────────────────────────────────────────
  void _showZoneSheet(BuildContext context, dynamic zone) {
    final bool isApproved = zone.status == 'approved';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return Container(
          decoration: const BoxDecoration(
            color: _kSurface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(22, 10, 22, 36),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // drag handle
              Center(
                child: Container(
                  width: 40, height: 4,
                  margin: const EdgeInsets.only(bottom: 22),
                  decoration: BoxDecoration(
                    color: _kDark.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Zone name + status badge
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      zone.name,
                      style: const TextStyle(
                        color: _kDark,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.4,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: isApproved
                          ? _kGreen.withOpacity(0.12)
                          : const Color(0xFFE07B2A).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isApproved
                            ? _kGreen.withOpacity(0.4)
                            : const Color(0xFFE07B2A).withOpacity(0.4),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6, height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isApproved
                                ? const Color(0xFF8BC34A)
                                : const Color(0xFFE07B2A),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          isApproved ? 'Approved' : 'Pending',
                          style: TextStyle(
                            color: isApproved
                                ? const Color(0xFF4a7035)
                                : const Color(0xFF9a5010),
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Info cards row
              Row(
                children: [
                  Expanded(
                    child: _InfoTile(
                      icon: Icons.payments_rounded,
                      label: 'Official Price',
                      value: '${zone.officialPrice} L.L',
                      color: _kRust,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _InfoTile(
                      icon: Icons.radar_rounded,
                      label: 'Radius',
                      value: '${zone.radius}m',
                      color: _kGreen,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 26),

              // Start Session CTA
              SizedBox(
                width: double.infinity,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: _kRust,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: _kRust.withOpacity(0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.local_parking_rounded, color: _kCream, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Start Session Here',
                          style: TextStyle(
                            color: _kCream,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ─── Build ────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    final provider = context.watch<ParkingZoneProvider>();

    return Scaffold(
      backgroundColor: _kSurface,
      body: Stack(
        children: [

          // ── Map (full bleed) ───────────────────────────────────────────────
          if (!provider.isLoading)
            FlutterMap(
              options: const MapOptions(
                initialCenter: LatLng(33.8938, 35.5018),
                initialZoom: 13,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.valetwatch.mobile',
                ),
                MarkerLayer(
                  markers: provider.zones.map((zone) {
                    final bool isApproved = zone.status == 'approved';
                    return Marker(
                      point: LatLng(zone.latitude, zone.longitude),
                      width: 56,
                      height: 66,
                      child: GestureDetector(
                        onTap: () => _showZoneSheet(context, zone),
                        child: Column(
                          children: [
                            // pin bubble
                            Container(
                              width: 42, height: 42,
                              decoration: BoxDecoration(
                                color: isApproved ? _kGreen : const Color(0xFFE07B2A),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: (isApproved ? _kGreen : const Color(0xFFE07B2A))
                                        .withOpacity(0.45),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                                border: Border.all(color: _kCard, width: 2.5),
                              ),
                              child: const Icon(Icons.local_parking_rounded,
                                  color: _kCard, size: 20),
                            ),
                            // pin tail
                            Container(
                              width: 3, height: 10,
                              decoration: BoxDecoration(
                                color: isApproved ? _kGreen : const Color(0xFFE07B2A),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),

          // ── Loading overlay ────────────────────────────────────────────────
          if (provider.isLoading)
            const Center(child: CircularProgressIndicator(color: _kRust)),

          // ── Floating Header ────────────────────────────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  // back button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 42, height: 42,
                      decoration: BoxDecoration(
                        color: _kCard,
                        borderRadius: BorderRadius.circular(13),
                        boxShadow: [
                          BoxShadow(
                            color: _kDark.withOpacity(0.12),
                            blurRadius: 12,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.arrow_back_rounded, color: _kDark, size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // title pill
                  Expanded(
                    child: Container(
                      height: 42,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: _kCard,
                        borderRadius: BorderRadius.circular(13),
                        boxShadow: [
                          BoxShadow(
                            color: _kDark.withOpacity(0.10),
                            blurRadius: 12,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.map_rounded, color: _kRust, size: 18),
                          const SizedBox(width: 8),
                          const Text(
                            'Valet Map',
                            style: TextStyle(
                              color: _kDark,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'Lebanon',
                            style: TextStyle(
                              color: _kDark.withOpacity(0.4),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Legend chip (bottom-left) ──────────────────────────────────────
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 80, left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _kCard,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: _kDark.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _LegendDot(color: _kGreen, label: 'Approved zone'),
                  const SizedBox(height: 5),
                  _LegendDot(color: Color(0xFFE07B2A), label: 'Pending zone'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Info Tile ────────────────────────────────────────────────────────────────
class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _kCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.12)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(
              color: _kDark.withOpacity(0.45),
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              color: _kDark,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Legend Dot ───────────────────────────────────────────────────────────────
class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10, height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 7),
        Text(
          label,
          style: TextStyle(
            color: _kDark.withOpacity(0.65),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}