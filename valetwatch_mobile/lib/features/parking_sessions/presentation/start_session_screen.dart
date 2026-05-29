import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../parking_zones/presentation/parking_zone_provider.dart';
import '../../vehicles/presentation/providers/vehicle_provider.dart';
import 'parking_session_provider.dart';

// ─── Brand Colors ─────────────────────────────────────────────────────────────
const _kRust    = Color(0xFFAB3C26);
const _kGreen   = Color(0xFF689451);
const _kCream   = Color(0xFFF5F2F2);
const _kDark    = Color(0xFF1A1208);
const _kSurface = Color(0xFFFDF9F8);
const _kCard    = Color(0xFFFFFFFF);

class StartSessionScreen extends StatefulWidget {
  const StartSessionScreen({super.key});

  @override
  State<StartSessionScreen> createState() => _StartSessionScreenState();
}

class _StartSessionScreenState extends State<StartSessionScreen> {
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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    final vehicleProvider = context.watch<VehicleProvider>();
    final zoneProvider    = context.watch<ParkingZoneProvider>();
    final sessionProvider = context.watch<ParkingSessionProvider>();

    final approvedZones = zoneProvider.zones
        .where((z) => z.status == 'approved')
        .toList();

    final bool canStart =
        selectedVehicleId != null && selectedZoneId != null;

    return Scaffold(
      backgroundColor: _kSurface,
      body: Column(
        children: [

          // ── Header ────────────────────────────────────────────────────
          _SessionHeader(),

          // ── Body ──────────────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 24, 18, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ── Start Session Card ───────────────────────────────
                  Container(
                    decoration: BoxDecoration(
                      color: _kCard,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: _kRust.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // Card title
                        Row(children: [
                          Container(
                            width: 40, height: 40,
                            decoration: BoxDecoration(
                              color: _kRust.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.add_circle_outline_rounded,
                                color: _kRust, size: 20),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Start New Session',
                            style: TextStyle(
                              color: _kDark,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ]),

                        const SizedBox(height: 22),

                        // Vehicle dropdown
                        _DropLabel(label: 'Vehicle'),
                        const SizedBox(height: 8),
                        _StyledDropdown<int>(
                          value: selectedVehicleId,
                          hint: 'Select your vehicle',
                          icon: Icons.directions_car_rounded,
                          items: vehicleProvider.vehicles.map((v) {
                            return DropdownMenuItem(
                              value: v.id,
                              child: Text(
                                '${v.brand} ${v.model} · ${v.plateNumber}',
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (val) =>
                              setState(() => selectedVehicleId = val),
                        ),

                        const SizedBox(height: 16),

                        // Zone dropdown
                        _DropLabel(label: 'Parking Zone'),
                        const SizedBox(height: 8),
                        _StyledDropdown<int>(
                          value: selectedZoneId,
                          hint: 'Select approved zone',
                          icon: Icons.location_on_rounded,
                          items: approvedZones.map((z) {
                            return DropdownMenuItem(
                              value: z.id,
                              child: Text(
                                '${z.name}  ·  ${z.officialPrice} L.L',
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (val) =>
                              setState(() => selectedZoneId = val),
                        ),

                        const SizedBox(height: 24),

                        // Start button
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton.icon(
                            onPressed: canStart
                                ? () async {
                                    final ok =
                                        await sessionProvider.startSession(
                                      vehicleId: selectedVehicleId!,
                                      zoneId: selectedZoneId!,
                                    );
                                    if (!context.mounted) return;
                                    _showSnack(
                                      context,
                                      ok
                                          ? 'Parking session started!'
                                          : 'Failed to start session',
                                      ok,
                                    );
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _kRust,
                              foregroundColor: _kCream,
                              disabledBackgroundColor:
                                  _kDark.withOpacity(0.08),
                              disabledForegroundColor:
                                  _kDark.withOpacity(0.3),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            icon: const Icon(Icons.play_circle_filled_rounded,
                                size: 20),
                            label: const Text(
                              'Start Session',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ── Sessions List ────────────────────────────────────
                  Row(children: [
                    Container(
                      width: 4, height: 20,
                      decoration: BoxDecoration(
                        color: _kGreen,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Your Sessions',
                      style: TextStyle(
                        color: _kDark,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ]),

                  const SizedBox(height: 14),

                  sessionProvider.isLoading
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Center(
                            child: CircularProgressIndicator(color: _kRust),
                          ),
                        )
                      : sessionProvider.sessions.isEmpty
                          ? _EmptyState()
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: sessionProvider.sessions.length,
                              itemBuilder: (_, i) {
                                final s = sessionProvider.sessions[i];
                                final status = s['status'] ?? 'active';
                                return _SessionTile(
                                  session: s,
                                  status: status,
                                  onComplete: () async {
                                    final ok = await sessionProvider
                                        .completeSession(s['id']);
                                    if (!context.mounted) return;
                                    _showSnack(
                                      context,
                                      ok
                                          ? 'Session completed'
                                          : 'Failed to complete session',
                                      ok,
                                    );
                                  },
                                );
                              },
                            ),

                  // Bottom navbar clearance
                  const SizedBox(height: 110),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnack(BuildContext ctx, String msg, bool success) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: Row(children: [
          Icon(
            success ? Icons.check_circle_outline : Icons.error_outline,
            color: Colors.white,
            size: 18,
          ),
          const SizedBox(width: 10),
          Text(msg),
        ]),
        backgroundColor: success ? _kGreen : _kRust,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      ),
    );
  }
}

// ─── Header ───────────────────────────────────────────────────────────────────
class _SessionHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFBF4A30), _kRust, Color(0xFF8C3020)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -30, top: -30,
            child: Container(
              width: 130, height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          Positioned(
            left: -20, bottom: -10,
            child: Container(
              width: 90, height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _kGreen.withOpacity(0.15),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Row(
                children: [
                  const Icon(Icons.local_parking_rounded,
                      color: _kCream, size: 28),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Parking Sessions',
                        style: TextStyle(
                          color: _kCream,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.4,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Start, track & complete sessions',
                        style: TextStyle(
                          color: Color(0xAAF5F2F2),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Helpers ──────────────────────────────────────────────────────────────────
class _DropLabel extends StatelessWidget {
  final String label;
  const _DropLabel({required this.label});
  @override
  Widget build(BuildContext context) => Text(
        label,
        style: const TextStyle(
          color: _kDark,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      );
}

class _StyledDropdown<T> extends StatelessWidget {
  final T? value;
  final String hint;
  final IconData icon;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  const _StyledDropdown({
    required this.value,
    required this.hint,
    required this.icon,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      onChanged: onChanged,
      items: items,
      isExpanded: true,
      icon: const Icon(Icons.keyboard_arrow_down_rounded,
          color: _kDark, size: 20),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: _kDark.withOpacity(0.3), fontSize: 14),
        prefixIcon: Icon(icon, color: _kDark.withOpacity(0.35), size: 20),
        filled: true,
        fillColor: _kDark.withOpacity(0.04),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: _kDark.withOpacity(0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: _kDark.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _kRust, width: 1.8),
        ),
      ),
      style: const TextStyle(color: _kDark, fontSize: 14),
      dropdownColor: _kCard,
      borderRadius: BorderRadius.circular(14),
    );
  }
}

// ─── Session Tile ─────────────────────────────────────────────────────────────
class _SessionTile extends StatelessWidget {
  final Map session;
  final String status;
  final VoidCallback onComplete;

  const _SessionTile({
    required this.session,
    required this.status,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final isActive    = status == 'active';
    final statusColor = isActive ? _kRust : _kGreen;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: _kCard,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Icon
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(
                isActive ? Icons.local_parking_rounded : Icons.check_circle_rounded,
                color: statusColor,
                size: 22,
              ),
            ),

            const SizedBox(width: 14),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session['vehicle']?['plate_number'] ?? 'Vehicle',
                    style: const TextStyle(
                      color: _kDark,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    session['zone']?['name'] ?? 'No zone',
                    style: TextStyle(
                      color: _kDark.withOpacity(0.5),
                      fontSize: 12.5,
                    ),
                  ),
                ],
              ),
            ),

            // Trailing
            isActive
                ? GestureDetector(
                    onTap: onComplete,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: _kGreen,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Complete',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: _kGreen.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Done',
                          style: TextStyle(
                            color: _kGreen,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${session['official_price'] ?? '-'} L.L',
                        style: const TextStyle(
                          color: _kDark,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}

// ─── Empty State ──────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Column(
          children: [
            Container(
              width: 72, height: 72,
              decoration: BoxDecoration(
                color: _kRust.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.local_parking_rounded,
                  color: _kRust, size: 32),
            ),
            const SizedBox(height: 16),
            const Text(
              'No sessions yet',
              style: TextStyle(
                color: _kDark,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Start a session above to track\nyour parking activity',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _kDark.withOpacity(0.45),
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}