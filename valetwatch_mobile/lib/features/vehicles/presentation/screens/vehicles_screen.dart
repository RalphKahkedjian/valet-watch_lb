import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/vehicle_provider.dart';

// ─── Brand Colors ─────────────────────────────────────────────────────────────
const _kRust    = Color(0xFFAB3C26);
const _kGreen   = Color(0xFF689451);
const _kCream   = Color(0xFFF5F2F2);
const _kDark    = Color(0xFF1A1208);
const _kSurface = Color(0xFFFDF9F8);
const _kCard    = Color(0xFFFFFFFF);

class VehiclesScreen extends StatefulWidget {
  const VehiclesScreen({super.key});

  @override
  State<VehiclesScreen> createState() => _VehiclesScreenState();
}

class _VehiclesScreenState extends State<VehiclesScreen> {
  final _brandController    = TextEditingController();
  final _modelController    = TextEditingController();
  final _plateController    = TextEditingController();
  final _colorController    = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<VehicleProvider>().fetchVehicles());
  }

  @override
  void dispose() {
    _brandController.dispose();
    _modelController.dispose();
    _plateController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  // ─── Input Field ────────────────────────────────────────────────────────────
  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            color: _kDark.withOpacity(0.45),
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 7),
        TextField(
          controller: controller,
          style: const TextStyle(
            color: _kDark,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: _kDark.withOpacity(0.3), fontSize: 14),
            prefixIcon: Icon(icon, color: _kRust.withOpacity(0.6), size: 20),
            filled: true,
            fillColor: _kCard,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: _kRust.withOpacity(0.15)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: _kRust, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  // ─── Bottom Sheet ────────────────────────────────────────────────────────────
  void _showAddVehicleSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          decoration: const BoxDecoration(
            color: _kSurface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(
            left: 22,
            right: 22,
            top: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 32,
          ),
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

              const Text(
                'Add Vehicle',
                style: TextStyle(
                  color: _kDark,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 22),

              _buildField(
                controller: _brandController,
                label: 'Brand',
                hint: 'e.g. Toyota',
                icon: Icons.directions_car_rounded,
              ),
              const SizedBox(height: 16),
              _buildField(
                controller: _modelController,
                label: 'Model',
                hint: 'e.g. Land Cruiser',
                icon: Icons.category_rounded,
              ),
              const SizedBox(height: 16),
              _buildField(
                controller: _plateController,
                label: 'Plate Number',
                hint: 'e.g. 22·B·1120',
                icon: Icons.pin_rounded,
              ),
              const SizedBox(height: 16),
              _buildField(
                controller: _colorController,
                label: 'Color',
                hint: 'e.g. Pearl White',
                icon: Icons.palette_rounded,
              ),
              const SizedBox(height: 26),

              // Save button
              SizedBox(
                width: double.infinity,
                child: GestureDetector(
                  onTap: () async {
                    final provider = context.read<VehicleProvider>();
                    final success = await provider.createVehicle(
                      brand:       _brandController.text,
                      model:       _modelController.text,
                      plateNumber: _plateController.text,
                      color:       _colorController.text,
                    );
                    if (!mounted) return;
                    if (success) {
                      _brandController.clear();
                      _modelController.clear();
                      _plateController.clear();
                      _colorController.clear();
                      Navigator.pop(context);
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          success ? 'Vehicle added successfully' : 'Failed to add vehicle',
                        ),
                        backgroundColor: success ? _kGreen : Colors.red.shade700,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    );
                  },
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
                    child: const Center(
                      child: Text(
                        'Save Vehicle',
                        style: TextStyle(
                          color: _kCream,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
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

  // ─── Vehicle Card ─────────────────────────────────────────────────────────
  Widget _buildVehicleCard(vehicle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _kCard,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _kRust.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: _kRust.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          // icon
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(
              color: _kRust.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.directions_car_rounded, color: _kRust, size: 26),
          ),
          const SizedBox(width: 14),

          // info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${vehicle.brand} ${vehicle.model}',
                  style: const TextStyle(
                    color: _kDark,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.1,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _Pill(label: vehicle.plateNumber, color: _kRust),
                    const SizedBox(width: 6),
                    _Pill(label: vehicle.color, color: _kGreen),
                  ],
                ),
              ],
            ),
          ),

          Icon(Icons.chevron_right_rounded, color: _kDark.withOpacity(0.25), size: 22),
        ],
      ),
    );
  }

  // ─── Empty State ───────────────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72, height: 72,
            decoration: BoxDecoration(
              color: _kRust.withOpacity(0.08),
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Icon(Icons.directions_car_rounded, color: _kRust, size: 34),
          ),
          const SizedBox(height: 16),
          const Text(
            'No vehicles yet',
            style: TextStyle(
              color: _kDark,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Add your first car to start\ntracking valet sessions.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _kDark.withOpacity(0.45),
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    final provider = context.watch<VehicleProvider>();

    return Scaffold(
      backgroundColor: _kSurface,
      body: CustomScrollView(
        slivers: [

          // ── Header ────────────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: _kRust,
            systemOverlayStyle: SystemUiOverlayStyle.light,
            leading: IconButton(
              icon: Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.arrow_back_rounded, color: _kCream, size: 18),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: GestureDetector(
                  onTap: _showAddVehicleSheet,
                  child: Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white.withOpacity(0.25)),
                    ),
                    child: const Icon(Icons.add_rounded, color: _kCream, size: 22),
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: _VehiclesHeader(),
            ),
            title: const Text(
              'My Vehicles',
              style: TextStyle(color: _kCream, fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ),

          // ── Body ──────────────────────────────────────────────────────────
          if (provider.isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator(color: _kRust)),
            )
          else if (provider.vehicles.isEmpty)
            SliverFillRemaining(child: _buildEmptyState())
          else
            SliverPadding(
              padding: EdgeInsets.fromLTRB(18, 24, 18,
                  MediaQuery.of(context).padding.bottom + 90),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) {
                    if (i == 0) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SectionLabel(label: 'Registered'),
                          const SizedBox(height: 14),
                          _buildVehicleCard(provider.vehicles[0]),
                        ],
                      );
                    }
                    return _buildVehicleCard(provider.vehicles[i]);
                  },
                  childCount: provider.vehicles.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Header ───────────────────────────────────────────────────────────────────
class _VehiclesHeader extends StatelessWidget {
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
          Positioned(right: -30, top: -30,
            child: Container(width: 160, height: 160,
              decoration: BoxDecoration(shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06)))),
          Positioned(right: 40, top: 50,
            child: Container(width: 80, height: 80,
              decoration: BoxDecoration(shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06)))),
          Positioned(left: -20, bottom: -20,
            child: Container(width: 120, height: 120,
              decoration: BoxDecoration(shape: BoxShape.circle,
                color: _kGreen.withOpacity(0.18)))),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 16, 22, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    'My Vehicles',
                    style: TextStyle(
                      color: _kCream, fontSize: 28,
                      fontWeight: FontWeight.w800, letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Manage your registered cars',
                    style: TextStyle(
                      color: _kCream.withOpacity(0.65), fontSize: 13,
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
        Container(width: 4, height: 20,
          decoration: BoxDecoration(color: _kRust, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 10),
        Text(label,
          style: const TextStyle(
            color: _kDark, fontSize: 18,
            fontWeight: FontWeight.w700, letterSpacing: -0.2,
          )),
      ],
    );
  }
}

// ─── Pill Badge ───────────────────────────────────────────────────────────────
class _Pill extends StatelessWidget {
  final String label;
  final Color color;
  const _Pill({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color.withOpacity(0.85),
          fontSize: 11.5,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}