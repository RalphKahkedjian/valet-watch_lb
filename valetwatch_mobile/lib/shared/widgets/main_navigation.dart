import 'package:flutter/material.dart';

import '../../features/auth/presentation/home_screen.dart';
import '../../features/parking_sessions/presentation/start_session_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/reports/presentation/report_screen.dart';
import '../../features/map/presentation/map_screen.dart';
import '../../features/vehicles/presentation/screens/vehicles_screen.dart';
import '../../features/valet_verification/presentation/qr_scanner_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  THEME
// ─────────────────────────────────────────────────────────────────────────────
const _kBarColor     = Color(0xFFAB3C26);
const _kBubbleColor  = Color(0xFFAB3C26);
const _kIconInactive = Color(0x99F5F2F2); 
const _kIconActive   = Color(0xFFF5F2F2);

// ─────────────────────────────────────────────────────────────────────────────
//  NAV ITEMS  ← order must match _screens below, 1-to-1
// ─────────────────────────────────────────────────────────────────────────────
const _navItems = [
  _NavItem(icon: Icons.dashboard_outlined,      activeIcon: Icons.dashboard,      label: 'Home'),      // 0
  _NavItem(icon: Icons.local_parking_outlined,  activeIcon: Icons.local_parking,  label: 'Session'),   // 1
  _NavItem(icon: Icons.map_outlined,            activeIcon: Icons.map,            label: 'Map'),       // 2
  _NavItem(icon: Icons.report_outlined,         activeIcon: Icons.report,         label: 'Report'),    // 3
  _NavItem(icon: Icons.directions_car_outlined, activeIcon: Icons.directions_car, label: 'Vehicles'),  // 4
  _NavItem(icon: Icons.qr_code_outlined,        activeIcon: Icons.qr_code,        label: 'Scan'),      // 5
  _NavItem(icon: Icons.person_outline,          activeIcon: Icons.person,         label: 'Profile'),   // 6
];

// ─────────────────────────────────────────────────────────────────────────────
//  SHELL
// ─────────────────────────────────────────────────────────────────────────────
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _index = 0;
  late final PageController _page;

  // ⚠️  SAME ORDER as _navItems above – index 0..6 must match exactly
  final _screens = const [
    HomeScreen(),        // 0 – Home
    StartSessionScreen(), // 1 – Session
    MapScreen(),         // 2 – Map
    ReportScreen(),      // 3 – Report
    VehiclesScreen(),    // 4 – Vehicles
    QrScannerScreen(),   // 5 – Scan
    ProfileScreen(),     // 6 – Profile
  ];

  @override
  void initState() {
    super.initState();
    _page = PageController();
  }

  @override
  void dispose() {
    _page.dispose();
    super.dispose();
  }

  void _go(int i) {
    if (i == _index) return;
    setState(() => _index = i);
    _page.animateToPage(i,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFFF0F4FF),
      body: PageView(
        controller: _page,
        physics: const NeverScrollableScrollPhysics(),
        children: _screens,
      ),
      bottomNavigationBar: _NotchedNavBar(
        currentIndex: _index,
        items: _navItems,
        onTap: _go,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  DATA
// ─────────────────────────────────────────────────────────────────────────────
class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _NavItem({required this.icon, required this.activeIcon, required this.label});
}

// ─────────────────────────────────────────────────────────────────────────────
//  NOTCHED NAV BAR
// ─────────────────────────────────────────────────────────────────────────────
class _NotchedNavBar extends StatefulWidget {
  final int currentIndex;
  final List<_NavItem> items;
  final ValueChanged<int> onTap;

  const _NotchedNavBar({
    required this.currentIndex,
    required this.items,
    required this.onTap,
  });

  @override
  State<_NotchedNavBar> createState() => _NotchedNavBarState();
}

class _NotchedNavBarState extends State<_NotchedNavBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _posAnim;
  int _prev = 0;

  @override
  void initState() {
    super.initState();
    _prev = widget.currentIndex;
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 380));
    _posAnim = AlwaysStoppedAnimation(widget.currentIndex.toDouble());
  }

  @override
  void didUpdateWidget(_NotchedNavBar old) {
    super.didUpdateWidget(old);
    if (old.currentIndex != widget.currentIndex) {
      _posAnim = Tween<double>(
        begin: _prev.toDouble(),
        end: widget.currentIndex.toDouble(),
      ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOutCubic));
      _ctrl.forward(from: 0);
      _prev = widget.currentIndex;
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final count   = widget.items.length;
    const barH    = 62.0;
    const bubbleR = 28.0;
    const lift    = 20.0;

    return SizedBox(
      height: barH + lift + MediaQuery.of(context).padding.bottom,
      child: AnimatedBuilder(
        animation: _posAnim,
        builder: (context, _) {
          return LayoutBuilder(builder: (ctx, box) {
            final totalW    = box.maxWidth;
            final itemW     = totalW / count;
            final centerX   = _posAnim.value * itemW + itemW / 2;
            final bottomPad = MediaQuery.of(context).padding.bottom;

            return Stack(
              clipBehavior: Clip.none,
              children: [

                // ── BAR ──────────────────────────────────────────────────
                Positioned(
                  left: 0, right: 0, bottom: 0,
                  height: barH + bottomPad,
                  child: CustomPaint(
                    painter: _NotchPainter(
                      notchCenterX: centerX,
                      notchRadius: bubbleR + 8,
                      color: _kBarColor,
                    ),
                  ),
                ),

                // ── INACTIVE ITEMS ────────────────────────────────────────
                Positioned(
                  left: 0, right: 0,
                  bottom: bottomPad,
                  height: barH,
                  child: Row(
                    children: List.generate(count, (i) {
                      final isActive = i == widget.currentIndex;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => widget.onTap(i),
                          behavior: HitTestBehavior.opaque,
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 220),
                            opacity: isActive ? 0.0 : 1.0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(widget.items[i].icon,
                                    color: _kIconInactive, size: 22),
                                const SizedBox(height: 2),
                                Text(
                                  widget.items[i].label,
                                  style: const TextStyle(
                                    color: _kIconInactive,
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                // ── FLOATING BUBBLE ───────────────────────────────────────
                Positioned(
                  left: centerX - bubbleR,
                  bottom: barH + bottomPad - bubbleR + lift,
                  width: bubbleR * 2,
                  height: bubbleR * 2,
                  child: GestureDetector(
                    onTap: () => widget.onTap(widget.currentIndex),
                    child: Container(
                      decoration: BoxDecoration(
                        color: _kBubbleColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFAB3C26).withOpacity(0.40),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder: (child, anim) =>
                            ScaleTransition(scale: anim, child: child),
                        child: Icon(
                          widget.items[widget.currentIndex].activeIcon,
                          key: ValueKey(widget.currentIndex),
                          color: _kIconActive,
                          size: 26,
                        ),
                      ),
                    ),
                  ),
                ),

              ],
            );
          });
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  PAINTER
// ─────────────────────────────────────────────────────────────────────────────
class _NotchPainter extends CustomPainter {
  final double notchCenterX;
  final double notchRadius;
  final Color color;

  const _NotchPainter({
    required this.notchCenterX,
    required this.notchRadius,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final r  = notchRadius;
    final cx = notchCenterX;
    const sw = 12.0;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(cx - r - sw, 0)
      ..cubicTo(cx - r, 0, cx - r * 0.55, r * 0.75, cx, r)
      ..cubicTo(cx + r * 0.55, r * 0.75, cx + r, 0, cx + r + sw, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_NotchPainter old) =>
      old.notchCenterX != notchCenterX ||
      old.notchRadius  != notchRadius  ||
      old.color        != color;
}