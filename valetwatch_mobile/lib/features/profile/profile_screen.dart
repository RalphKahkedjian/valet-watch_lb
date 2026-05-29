import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../auth/presentation/auth_provider.dart';

// ─── Brand Colors ─────────────────────────────────────────────────────────────
const _kRust    = Color(0xFFAB3C26);
const _kGreen   = Color(0xFF689451);
const _kCream   = Color(0xFFF5F2F2);
const _kDark    = Color(0xFF1A1208);
const _kSurface = Color(0xFFFDF9F8);
const _kCard    = Color(0xFFFFFFFF);

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: _kSurface,
      body: Column(
        children: [

          // ── Hero header with avatar ──────────────────────────────────
          _ProfileHeader(
            name:  auth.name  ?? 'Unknown User',
            email: auth.email ?? '-',
          ),

          // ── Content ──────────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 28, 18, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ── Stats row ────────────────────────────────────────
                  Row(children: [
                    Expanded(child: _StatChip(
                      icon: Icons.local_parking_rounded,
                      color: _kRust,
                      label: 'Sessions',
                      value: '12',
                    )),
                    const SizedBox(width: 12),
                    Expanded(child: _StatChip(
                      icon: Icons.report_rounded,
                      color: _kGreen,
                      label: 'Reports',
                      value: '3',
                    )),
                    const SizedBox(width: 12),
                    Expanded(child: _StatChip(
                      icon: Icons.directions_car_rounded,
                      color: const Color(0xFF7B6A3E),
                      label: 'Vehicles',
                      value: '2',
                    )),
                  ]),

                  const SizedBox(height: 32),

                  // ── Account section ──────────────────────────────────
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

                  // ── App section ──────────────────────────────────────
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

                  // ── Logout button ────────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: () => _confirmLogout(context, auth),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _kRust.withOpacity(0.08),
                        foregroundColor: _kRust,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: _kRust.withOpacity(0.25)),
                        ),
                      ),
                      icon: const Icon(Icons.logout_rounded, size: 20),
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

  void _confirmLogout(BuildContext context, AuthProvider auth) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _kCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // drag handle
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: _kDark.withOpacity(0.15),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: 60, height: 60,
              decoration: BoxDecoration(
                color: _kRust.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.logout_rounded,
                  color: _kRust, size: 28),
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
            Row(children: [
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _kDark,
                      side: BorderSide(color: _kDark.withOpacity(0.15)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text('Cancel',
                        style: TextStyle(fontWeight: FontWeight.w600)),
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
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text('Sign Out',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

// ─── Profile Header ───────────────────────────────────────────────────────────
class _ProfileHeader extends StatelessWidget {
  final String name;
  final String email;
  const _ProfileHeader({required this.name, required this.email});

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
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(36)),
      ),
      child: Stack(
        children: [
          // decorative circles
          Positioned(
            right: -30, top: -30,
            child: Container(
              width: 160, height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          Positioned(
            left: -20, bottom: -20,
            child: Container(
              width: 100, height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _kGreen.withOpacity(0.15),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 36),
              child: Column(
                children: [
                  // Avatar
                  Stack(
                    children: [
                      Container(
                        width: 88, height: 88,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.18),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.35),
                            width: 2.5,
                          ),
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          color: _kCream,
                          size: 44,
                        ),
                      ),
                      // edit badge
                      Positioned(
                        bottom: 0, right: 0,
                        child: Container(
                          width: 26, height: 26,
                          decoration: BoxDecoration(
                            color: _kGreen,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: _kRust, width: 2),
                          ),
                          child: const Icon(Icons.edit_rounded,
                              color: Colors.white, size: 13),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  Text(
                    name,
                    style: const TextStyle(
                      color: _kCream,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
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

                  // Verified badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: _kGreen.withOpacity(0.22),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: _kGreen.withOpacity(0.45)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6, height: 6,
                          decoration: const BoxDecoration(
                            color: Color(0xFF8BC34A),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'Verified Member',
                          style: TextStyle(
                            color: Color(0xFFB8D98A),
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
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

// ─── Stat Chip ────────────────────────────────────────────────────────────────
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
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
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
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: _kDark,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: _kDark.withOpacity(0.45),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Section Label ────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});
  @override
  Widget build(BuildContext context) => Row(children: [
    Container(
      width: 4, height: 18,
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
        letterSpacing: -0.1,
      ),
    ),
  ]);
}

// ─── Menu Tile ────────────────────────────────────────────────────────────────
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: _kCard,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, color: color, size: 19),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                      color: _kDark,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    )),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: TextStyle(
                      color: _kDark.withOpacity(0.45),
                      fontSize: 12,
                    )),
              ],
            ),
          ),
          if (showChevron)
            Icon(Icons.chevron_right_rounded,
                color: _kDark.withOpacity(0.25), size: 20),
        ]),
      ),
    );
  }
}