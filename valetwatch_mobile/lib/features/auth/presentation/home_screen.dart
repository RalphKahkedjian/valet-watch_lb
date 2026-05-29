import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../parking_sessions/presentation/parking_session_provider.dart';
import '../../parking_sessions/presentation/start_session_screen.dart';
import '../../parking_zones/presentation/parking_zone_provider.dart';

const _kRust = Color(0xFFAB3C26);
const _kGreen = Color(0xFF689451);
const _kCream = Color(0xFFF5F2F2);
const _kDark = Color(0xFF1A1208);
const _kSurface = Color(0xFFF5F2F2);
const _kCard = Color(0xFFFFFFFF);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<ParkingSessionProvider>().fetchSessions();
      context.read<ParkingZoneProvider>().fetchZones();
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light,
    );

    final sessions =
        context.watch<ParkingSessionProvider>().sessions;

    final zones =
        context.watch<ParkingZoneProvider>().zones;

    final activeSessions = sessions.where((s) {
      final status = s['status'];

      return status == 'active' ||
          status == 'unverified';
    }).length;

    final verifiedZones = zones.where((z) {
      return z.status == 'approved';
    }).length;

    return Scaffold(
      backgroundColor: _kSurface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 190,
            pinned: true,
            backgroundColor: _kRust,
            systemOverlayStyle:
                SystemUiOverlayStyle.light,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: const _HeroHeader(),
            ),
            title: const Text(
              'ValetWatch',
              style: TextStyle(
                color: _kCream,
                fontSize: 17,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
            iconTheme:
                const IconThemeData(color: _kCream),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                20,
                16,
                0,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          value:
                              activeSessions.toString(),
                          label: 'Active sessions',
                          valueColor: _kRust,
                          badgeText: activeSessions == 0
                              ? 'No active'
                              : 'Running',
                          badgeColor: _kRust,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: _StatCard(
                          value:
                              verifiedZones.toString(),
                          label: 'Verified zones',
                          valueColor: _kGreen,
                          badgeText: verifiedZones == 0
                              ? 'No zones'
                              : 'Nearby',
                          badgeColor: _kGreen,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  const _SectionLabel(
                    label: 'Quick Actions',
                  ),

                  const SizedBox(height: 12),

                  const _QuickActionsRow(),

                  const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 20),
                    child: Divider(
                      color: Color(0x14000000),
                      thickness: 0.5,
                    ),
                  ),

                  const _SectionLabel(
                    label: 'Safety Tips',
                  ),

                  const SizedBox(height: 4),

                  const _TipRow(
                    icon: Icons.qr_code_2_rounded,
                    accentColor: _kRust,
                    title:
                        'Ask for valet verification',
                    description:
                        'Only trust workers connected to approved zones or official businesses.',
                  ),

                  const _TipRow(
                    icon: Icons.receipt_rounded,
                    accentColor: _kGreen,
                    title:
                        'Check the official price',
                    description:
                        'Valet pricing should be transparent before giving your car.',
                  ),

                  const _TipRow(
                    icon: Icons.camera_alt_rounded,
                    accentColor: _kRust,
                    title:
                        'Take photos before leaving',
                    description:
                        'Capture your car condition and belongings before handing over the keys.',
                    isLast: true,
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
}

class _HeroHeader extends StatelessWidget {
  const _HeroHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
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
      ),
      child: Stack(
        children: [
          Positioned(
            right: -40,
            top: -50,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    Colors.white.withOpacity(0.05),
              ),
            ),
          ),

          Positioned(
            left: -20,
            bottom: -20,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    _kGreen.withOpacity(0.15),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                14,
                20,
                18,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                mainAxisAlignment:
                    MainAxisAlignment.end,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color:
                          _kGreen.withOpacity(0.22),
                      borderRadius:
                          BorderRadius.circular(20),
                      border: Border.all(
                        color:
                            _kGreen.withOpacity(0.4),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration:
                              const BoxDecoration(
                            color:
                                Color(0xFF8BC34A),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'Lebanon · Active',
                          style: TextStyle(
                            color:
                                Color(0xFFB8D98A),
                            fontSize: 11,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'ValetWatch',
                    style: TextStyle(
                      color: _kCream,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    'Protect your car · Verify zones · Report scams',
                    style: TextStyle(
                      color:
                          _kCream.withOpacity(0.65),
                      fontSize: 12.5,
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

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color valueColor;
  final String badgeText;
  final Color badgeColor;

  const _StatCard({
    required this.value,
    required this.label,
    required this.valueColor,
    required this.badgeText,
    required this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.fromLTRB(14, 13, 14, 13),
      decoration: BoxDecoration(
        color: _kCard,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: valueColor,
            ),
          ),

          const SizedBox(height: 2),

          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: _kDark.withOpacity(0.45),
            ),
          ),

          const SizedBox(height: 5),

          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 7,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color:
                  badgeColor.withOpacity(0.1),
              borderRadius:
                  BorderRadius.circular(6),
            ),
            child: Text(
              badgeText,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: badgeColor,
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
            borderRadius:
                BorderRadius.circular(2),
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

class _QuickActionsRow extends StatelessWidget {
  const _QuickActionsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionCard(
            icon: Icons.local_parking_rounded,
            label: 'Start Session',
            sub: 'Park your vehicle',
            color: _kRust,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const StartSessionScreen(),
                ),
              );
            },
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: _ActionCard(
            icon: Icons.warning_amber_rounded,
            label: 'Report Issue',
            sub: 'Fake valet or scam',
            color: Colors.red,
            onTap: () {},
          ),
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sub;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.sub,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 130,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: _kCard,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),

            const Spacer(),

            Text(
              label,
              style: const TextStyle(
                color: _kDark,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 3),

            Text(
              sub,
              style: TextStyle(
                color:
                    _kDark.withOpacity(0.42),
                fontSize: 11.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TipRow extends StatelessWidget {
  final IconData icon;
  final Color accentColor;
  final String title;
  final String description;
  final bool isLast;

  const _TipRow({
    required this.icon,
    required this.accentColor,
    required this.title,
    required this.description,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(vertical: 13),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color:
                  accentColor.withOpacity(0.09),
              borderRadius:
                  BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: accentColor,
              size: 17,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: _kDark,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  description,
                  style: TextStyle(
                    color:
                        _kDark.withOpacity(0.5),
                    fontSize: 11.5,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}