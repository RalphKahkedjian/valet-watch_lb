import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../auth/presentation/auth_provider.dart';
import '../parking_sessions/presentation/parking_session_provider.dart';
import '../vehicles/presentation/providers/vehicle_provider.dart';

const _kRust = Color(0xFFAB3C26);
const _kGreen = Color(0xFF689451);
const _kCream = Color(0xFFF5F2F2);
const _kDark = Color(0xFF1A1208);
const _kSurface = Color(0xFFFDF9F8);
const _kCard = Color(0xFFFFFFFF);

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<ParkingSessionProvider>().fetchSessions();
      context.read<VehicleProvider>().fetchVehicles();
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light,
    );

    final auth = context.watch<AuthProvider>();
    final sessions =
        context.watch<ParkingSessionProvider>().sessions.length;
    final vehicles =
        context.watch<VehicleProvider>().vehicles.length;

    const reports = 0;

    return Scaffold(
      backgroundColor: _kSurface,
      body: Column(
        children: [
          _ProfileHeader(
            name: auth.name ?? 'Unknown User',
            email: auth.email ?? '-',
          ),

          Expanded(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.fromLTRB(18, 28, 18, 0),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _StatChip(
                          icon: Icons.local_parking_rounded,
                          color: _kRust,
                          label: 'Sessions',
                          value: sessions.toString(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatChip(
                          icon: Icons.report_rounded,
                          color: _kGreen,
                          label: 'Reports',
                          value: reports.toString(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatChip(
                          icon: Icons.directions_car_rounded,
                          color: const Color(0xFF7B6A3E),
                          label: 'Vehicles',
                          value: vehicles.toString(),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  _SectionLabel(label: 'Account'),
                  const SizedBox(height: 12),

                  _MenuTile(
                    icon: Icons.person_outline_rounded,
                    color: _kRust,
                    title: 'Edit Profile',
                    subtitle: 'Update your name and details',
                    onTap: () {},
                  ),

                  _MenuTile(
                    icon: Icons.lock_outline_rounded,
                    color: _kGreen,
                    title: 'Change Password',
                    subtitle: 'Keep your account secure',
                    onTap: () {},
                  ),

                  _MenuTile(
                    icon: Icons.notifications_outlined,
                    color: const Color(0xFF7B6A3E),
                    title: 'Notifications',
                    subtitle: 'Manage alert preferences',
                    onTap: () {},
                  ),

                  const SizedBox(height: 28),

                  _SectionLabel(label: 'App'),
                  const SizedBox(height: 12),

                  _MenuTile(
                    icon: Icons.shield_outlined,
                    color: _kGreen,
                    title: 'Privacy Policy',
                    subtitle: 'How we handle your data',
                    onTap: () {},
                  ),

                  _MenuTile(
                    icon: Icons.info_outline_rounded,
                    color: _kRust,
                    title: 'About ValetWatch',
                    subtitle: 'Version 1.0.0',
                    onTap: () {},
                    showChevron: false,
                  ),

                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: () =>
                          _confirmLogout(context, auth),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _kRust.withOpacity(0.08),
                        foregroundColor: _kRust,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(16),
                          side: BorderSide(
                            color: _kRust.withOpacity(0.25),
                          ),
                        ),
                      ),
                      icon: const Icon(
                        Icons.logout_rounded,
                        size: 20,
                      ),
                      label: const Text(
                        'Sign Out',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 110),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmLogout(
    BuildContext context,
    AuthProvider auth,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _kCard,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => Padding(
        padding:
            const EdgeInsets.fromLTRB(24, 20, 24, 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: _kDark.withOpacity(0.15),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const SizedBox(height: 24),

            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: _kRust.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.logout_rounded,
                color: _kRust,
                size: 28,
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              'Sign out?',
              style: TextStyle(
                color: _kDark,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'You\'ll need to sign in again to access ValetWatch.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _kDark.withOpacity(0.5),
                fontSize: 13.5,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 28),

            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () =>
                          Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _kDark,
                        side: BorderSide(
                          color:
                              _kDark.withOpacity(0.15),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        auth.logout();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _kRust,
                        foregroundColor: _kCream,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Sign Out',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
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

class _ProfileHeader extends StatelessWidget {
  final String name;
  final String email;

  const _ProfileHeader({
    required this.name,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFBF4A30),
            _kRust,
            Color(0xFF8C3020),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(36),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding:
              const EdgeInsets.fromLTRB(20, 20, 20, 36),
          child: Column(
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.18),
                  border: Border.all(
                    color:
                        Colors.white.withOpacity(0.35),
                    width: 2.5,
                  ),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: _kCream,
                  size: 44,
                ),
              ),

              const SizedBox(height: 14),

              Text(
                name,
                style: const TextStyle(
                  color: _kCream,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                email,
                style: TextStyle(
                  color: _kCream.withOpacity(0.65),
                  fontSize: 13.5,
                ),
              ),

              const SizedBox(height: 14),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: _kGreen.withOpacity(0.22),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _kGreen.withOpacity(0.45),
                  ),
                ),
                child: const Text(
                  'Verified Member',
                  style: TextStyle(
                    color: Color(0xFFB8D98A),
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String value;

  const _StatChip({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: _kCard,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: _kDark,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: _kDark.withOpacity(0.45),
              fontSize: 11,
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
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: _kRust,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(
            color: _kDark,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool showChevron;

  const _MenuTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.showChevron = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: _kCard,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color:
                  Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: _kDark,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color:
                          _kDark.withOpacity(0.45),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (showChevron)
              Icon(
                Icons.chevron_right_rounded,
                color: _kDark.withOpacity(0.25),
              ),
          ],
        ),
      ),
    );
  }
}