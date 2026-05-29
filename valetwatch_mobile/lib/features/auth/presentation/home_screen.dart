import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../parking_sessions/presentation/start_session_screen.dart';

// ─── Brand Colors ────────────────────────────────────────────────────────────
const _kRust    = Color(0xFFAB3C26);
const _kGreen   = Color(0xFF689451);
const _kCream   = Color(0xFFF5F2F2);
const _kDark    = Color(0xFF1A1208);
const _kSurface = Color(0xFFFDF9F8); // warm off-white page bg
const _kCard    = Color(0xFFFFFFFF);

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Status bar icons dark on light header
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return Scaffold(
      backgroundColor: _kSurface,
      body: CustomScrollView(
        slivers: [

          // ── Collapsible Header ──────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 210,
            pinned: true,
            backgroundColor: _kRust,
            systemOverlayStyle: SystemUiOverlayStyle.light,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: _HeroHeader(),
            ),
            // collapsed title
            title: const Text(
              'ValetWatch',
              style: TextStyle(
                color: _kCream,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            titleTextStyle: const TextStyle(color: _kCream),
            iconTheme: const IconThemeData(color: _kCream),
          ),

          // ── Body ───────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 24, 18, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Section: Quick Actions
                  _SectionLabel(label: 'Quick Actions'),
                  const SizedBox(height: 14),
                  _QuickActionsGrid(),

                  const SizedBox(height: 32),

                  // Section: Safety Tips
                  _SectionLabel(label: 'Safety Tips'),
                  const SizedBox(height: 14),
                  const _TipCard(
                    icon: Icons.qr_code_2_rounded,
                    color: _kRust,
                    title: 'Ask for valet verification',
                    description:
                        'Only trust valet workers connected to approved zones or official businesses.',
                  ),
                  const _TipCard(
                    icon: Icons.payments_rounded,
                    color: _kGreen,
                    title: 'Check the official price',
                    description:
                        'Valet pricing should be transparent before giving your car.',
                  ),
                  const _TipCard(
                    icon: Icons.camera_alt_rounded,
                    color: _kRust,
                    title: 'Take photos before leaving',
                    description:
                        'Capture your car condition and belongings before handing over the keys.',
                  ),

                  // Bottom padding so content clears the floating navbar
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

// ─── Hero Header ─────────────────────────────────────────────────────────────
class _HeroHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFBF4A30), _kRust, Color(0xFF8C3020)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
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
            right: 40, top: 50,
            child: Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          Positioned(
            left: -20, bottom: -20,
            child: Container(
              width: 120, height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _kGreen.withOpacity(0.18),
              ),
            ),
          ),

          // content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 16, 22, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _kGreen.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _kGreen.withOpacity(0.5)),
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
                          'Lebanon · Active',
                          style: TextStyle(
                            color: Color(0xFFB8D98A),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'ValetWatch',
                    style: TextStyle(
                      color: _kCream,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                      height: 1.1,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    'Protect your car · Verify valet zones · Report scams',
                    style: TextStyle(
                      color: _kCream.withOpacity(0.72),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.1,
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

// ─── Section Label ────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4, height: 20,
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
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }
}

// ─── Quick Actions Grid ───────────────────────────────────────────────────────
class _QuickActionsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final actions = [
      _ActionData(
        icon: Icons.local_parking_rounded,
        label: 'Start Session',
        sub: 'Park your vehicle',
        color: _kRust,
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const StartSessionScreen())),
      ),
      _ActionData(
        icon: Icons.report_rounded,
        label: 'Report Issue',
        sub: 'Fake valet or scam',
        color: const Color(0xFFC0392B),
        onTap: () {},
      ),
      _ActionData(
        icon: Icons.map_rounded,
        label: 'View Map',
        sub: 'Nearby valet zones',
        color: _kGreen,
        onTap: () {},
      ),
      _ActionData(
        icon: Icons.camera_alt_rounded,
        label: 'Evidence',
        sub: 'Upload proof',
        color: const Color(0xFF7B6A3E),
        onTap: () {},
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: actions.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 1.05,
      ),
      itemBuilder: (_, i) => _ActionCard(data: actions[i]),
    );
  }
}

class _ActionData {
  final IconData icon;
  final String label;
  final String sub;
  final Color color;
  final VoidCallback onTap;
  const _ActionData({
    required this.icon,
    required this.label,
    required this.sub,
    required this.color,
    required this.onTap,
  });
}

class _ActionCard extends StatelessWidget {
  final _ActionData data;
  const _ActionCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: data.onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: _kCard,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: data.color.withOpacity(0.12),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: data.color.withOpacity(0.12),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // icon pill
            Container(
              width: 46, height: 46,
              decoration: BoxDecoration(
                color: data.color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(data.icon, color: data.color, size: 24),
            ),

            const Spacer(),

            Text(
              data.label,
              style: const TextStyle(
                color: _kDark,
                fontSize: 15,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.1,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              data.sub,
              style: TextStyle(
                color: _kDark.withOpacity(0.45),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Tip Card ─────────────────────────────────────────────────────────────────
class _TipCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String description;

  const _TipCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: _kCard,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: _kDark,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: _kDark.withOpacity(0.55),
                    fontSize: 12.5,
                    height: 1.45,
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