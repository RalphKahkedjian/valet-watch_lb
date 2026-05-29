import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../core/services/location_service.dart';
import '../../car_scans/presentation/car_scan_provider.dart';
import '../../vehicles/presentation/providers/vehicle_provider.dart';
import 'parking_session_provider.dart';

const _kRust = Color(0xFFAB3C26);
const _kGreen = Color(0xFF689451);
const _kCream = Color(0xFFF5F2F2);
const _kDark = Color(0xFF1A1208);
const _kCard = Color(0xFFFFFFFF);
const _kAmber = Color(0xFFB07A00);

class StartSessionScreen extends StatefulWidget {
  const StartSessionScreen({super.key});

  @override
  State<StartSessionScreen> createState() => _StartSessionScreenState();
}

class _StartSessionScreenState extends State<StartSessionScreen> {
  int? selectedVehicleId;

  Future<void> uploadCarScan({
    required int sessionId,
    required String scanType,
  }) async {
    final picker = ImagePicker();

    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedImage == null) return;

    final success = await context.read<CarScanProvider>().uploadScan(
          parkingSessionId: sessionId,
          scanType: scanType,
          image: File(pickedImage.path),
        );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? '$scanType scan uploaded successfully'
              : 'Failed to upload $scanType scan',
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<VehicleProvider>().fetchVehicles();
      context.read<ParkingSessionProvider>().fetchSessions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vehicleProvider = context.watch<VehicleProvider>();
    final sessionProvider = context.watch<ParkingSessionProvider>();

    return Scaffold(
      backgroundColor: _kCream,
      appBar: AppBar(
        backgroundColor: _kRust,
        foregroundColor: _kCream,
        elevation: 0,
        title: const Text(
          'Parking Sessions',
          style: TextStyle(
            color: _kCream,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _StartCard(
              vehicleProvider: vehicleProvider,
              sessionProvider: sessionProvider,
              selectedVehicleId: selectedVehicleId,
              onVehicleSelected: (id) {
                setState(() {
                  selectedVehicleId = id;
                });
              },
            ),

            const SizedBox(height: 20),

            const _SectionLabel(label: 'My Sessions'),

            const SizedBox(height: 12),

            Expanded(
              child: sessionProvider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: _kRust),
                    )
                  : sessionProvider.sessions.isEmpty
                      ? const _EmptyState()
                      : ListView.builder(
                          itemCount: sessionProvider.sessions.length,
                          itemBuilder: (context, index) {
                            final session =
                                sessionProvider.sessions[index];

                            return _SessionCard(
                              session: session,
                              onBeforeScan: () {
                                uploadCarScan(
                                  sessionId: session['id'],
                                  scanType: 'before',
                                );
                              },
                              onAfterScan: () {
                                uploadCarScan(
                                  sessionId: session['id'],
                                  scanType: 'after',
                                );
                              },
                              onComplete: () async {
                                final success =
                                    await sessionProvider.completeSession(
                                  session['id'],
                                );

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
                            );
                          },
                        ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _StartCard extends StatelessWidget {
  final VehicleProvider vehicleProvider;
  final ParkingSessionProvider sessionProvider;
  final int? selectedVehicleId;
  final ValueChanged<int?> onVehicleSelected;

  const _StartCard({
    required this.vehicleProvider,
    required this.sessionProvider,
    required this.selectedVehicleId,
    required this.onVehicleSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _kCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.black.withOpacity(0.07),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Start a Session',
            style: TextStyle(
              color: _kDark,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            "Select your vehicle. We'll use your location to verify if you're inside an approved valet zone.",
            style: TextStyle(
              color: _kDark.withOpacity(0.48),
              fontSize: 12,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            'YOUR VEHICLES',
            style: TextStyle(
              color: _kDark.withOpacity(0.4),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 7),

          Container(
            decoration: BoxDecoration(
              color: _kCream,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.black.withOpacity(0.08),
                width: 0.5,
              ),
            ),
            clipBehavior: Clip.hardEdge,
            child: vehicleProvider.vehicles.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'No vehicles added yet.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : Column(
                    children:
                        vehicleProvider.vehicles.asMap().entries.map((entry) {
                      final i = entry.key;
                      final v = entry.value;
                      final isSelected = v.id == selectedVehicleId;
                      final isLast = i == vehicleProvider.vehicles.length - 1;

                      return GestureDetector(
                        onTap: () => onVehicleSelected(v.id),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 13,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? _kRust.withOpacity(0.06)
                                : Colors.transparent,
                            border: isLast
                                ? null
                                : Border(
                                    bottom: BorderSide(
                                      color: Colors.black.withOpacity(0.06),
                                      width: 0.5,
                                    ),
                                  ),
                          ),
                          child: Row(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected
                                        ? _kRust
                                        : _kDark.withOpacity(0.2),
                                    width: 2,
                                  ),
                                  color: isSelected
                                      ? _kRust
                                      : Colors.transparent,
                                ),
                                child: isSelected
                                    ? const Center(
                                        child: CircleAvatar(
                                          radius: 3,
                                          backgroundColor: Colors.white,
                                        ),
                                      )
                                    : null,
                              ),

                              const SizedBox(width: 12),

                              Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: _kRust.withOpacity(0.09),
                                  borderRadius: BorderRadius.circular(9),
                                ),
                                child: const Icon(
                                  Icons.directions_car_rounded,
                                  color: _kRust,
                                  size: 18,
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${v.brand} ${v.model}',
                                      style: const TextStyle(
                                        color: _kDark,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 1),
                                    Text(
                                      v.plateNumber,
                                      style: TextStyle(
                                        color: _kDark.withOpacity(0.42),
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: GestureDetector(
              onTap: selectedVehicleId == null || sessionProvider.isLoading
                  ? null
                  : () async {
                      final position =
                          await LocationService.getCurrentLocation();

                      if (!context.mounted) return;

                      if (position == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Location not detected. Enable location and try again.',
                            ),
                          ),
                        );
                        return;
                      }

                      final success = await sessionProvider.startSession(
                        vehicleId: selectedVehicleId!,
                        latitude: position.latitude,
                        longitude: position.longitude,
                      );

                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            success
                                ? sessionProvider.lastMessage ??
                                    'Parking session started'
                                : 'Failed to start session',
                          ),
                        ),
                      );
                    },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: selectedVehicleId == null || sessionProvider.isLoading
                      ? _kDark.withOpacity(0.1)
                      : _kRust,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.my_location_rounded,
                      size: 18,
                      color: selectedVehicleId == null
                          ? _kDark.withOpacity(0.3)
                          : Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      sessionProvider.isLoading
                          ? 'Starting...'
                          : 'Start Session at My Location',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: selectedVehicleId == null
                            ? _kDark.withOpacity(0.3)
                            : Colors.white,
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
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 18,
          decoration: BoxDecoration(
            color: _kRust,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 9),
        Text(
          label,
          style: const TextStyle(
            color: _kDark,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _SessionCard extends StatelessWidget {
  final Map<String, dynamic> session;
  final VoidCallback onComplete;
  final VoidCallback onBeforeScan;
  final VoidCallback onAfterScan;

  const _SessionCard({
    required this.session,
    required this.onComplete,
    required this.onBeforeScan,
    required this.onAfterScan,
  });

  @override
  Widget build(BuildContext context) {
    final status = session['status'] ?? 'active';

    final iconData = status == 'completed'
        ? Icons.check_rounded
        : status == 'unverified'
            ? Icons.warning_amber_rounded
            : Icons.local_parking_rounded;

    final iconColor = status == 'completed'
        ? _kGreen
        : status == 'unverified'
            ? _kAmber
            : _kRust;

    final badgeText = status == 'completed'
        ? 'Completed'
        : status == 'unverified'
            ? 'Unverified'
            : 'Active';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _kCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.black.withOpacity(0.07),
          width: 0.5,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(iconData, color: iconColor, size: 20),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session['vehicle']?['plate_number'] ?? 'Vehicle',
                      style: const TextStyle(
                        color: _kDark,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      session['zone']?['name'] ?? 'No approved zone',
                      style: TextStyle(
                        color: _kDark.withOpacity(0.45),
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  badgeText,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: iconColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _SmallActionButton(
                  label: 'Before Scan',
                  icon: Icons.camera_alt_rounded,
                  color: _kGreen,
                  onTap: onBeforeScan,
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: _SmallActionButton(
                  label: 'After Scan',
                  icon: Icons.image_search_rounded,
                  color: _kAmber,
                  onTap: onAfterScan,
                ),
              ),

              if (status == 'active' || status == 'unverified') ...[
                const SizedBox(width: 8),
                Expanded(
                  child: _SmallActionButton(
                    label: 'Complete',
                    icon: Icons.check_rounded,
                    color: _kRust,
                    onTap: onComplete,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _SmallActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _SmallActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(height: 3),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: _kRust.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.local_parking_rounded,
              color: _kRust,
              size: 28,
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            'No sessions yet',
            style: TextStyle(
              color: _kDark,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            'Start your first session above',
            style: TextStyle(
              color: _kDark.withOpacity(0.4),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}