import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../core/services/location_service.dart';
import '../../../shared/models/report_type.dart';
import 'report_provider.dart';

// ─── Brand Colors ─────────────────────────────────────────────────────────────
const _kRust    = Color(0xFFAB3C26);
const _kGreen   = Color(0xFF689451);
const _kCream   = Color(0xFFF5F2F2);
const _kDark    = Color(0xFF1A1208);
const _kSurface = Color(0xFFFDF9F8);
const _kCard    = Color(0xFFFFFFFF);

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  ReportType _selectedType       = ReportType.fakeValet;
  final _descCtrl                = TextEditingController();
  final _picker                  = ImagePicker();
  bool   _hasLocation            = false;
  double? _lat, _lng;
  File?  _image;

  @override
  void initState() {
    super.initState();
    _checkLocation();
  }

  @override
  void dispose() {
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _checkLocation() async {
    final pos = await LocationService.getCurrentLocation();
    if (!mounted) return;
    setState(() {
      _hasLocation = pos != null;
      _lat = pos?.latitude;
      _lng = pos?.longitude;
    });
  }

  Future<void> _pickImage() async {
    final img = await _picker.pickImage(
        source: ImageSource.gallery, imageQuality: 80);
    if (img == null) return;
    setState(() => _image = File(img.path));
  }

  void _showSnack(BuildContext ctx, String msg, bool ok) {
    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
      content: Row(children: [
        Icon(ok ? Icons.check_circle_outline : Icons.error_outline,
            color: Colors.white, size: 18),
        const SizedBox(width: 10),
        Expanded(child: Text(msg)),
      ]),
      backgroundColor: ok ? _kGreen : _kRust,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
    ));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    final provider = context.watch<ReportProvider>();

    return Scaffold(
      backgroundColor: _kSurface,
      body: Column(
        children: [

          // ── Header ──────────────────────────────────────────────────
          _ReportHeader(),

          // ── Scrollable form ─────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 24, 18, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Location banner
                  _LocationBanner(
                    hasLocation: _hasLocation,
                    lat: _lat,
                    lng: _lng,
                    onRefresh: _checkLocation,
                  ),

                  const SizedBox(height: 24),

                  // Form card
                  Container(
                    decoration: BoxDecoration(
                      color: _kCard,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: _kRust.withOpacity(0.07),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // Report type
                        _FieldLabel(label: 'Report Type'),
                        const SizedBox(height: 8),
                        _StyledDropdown<ReportType>(
                          value: _selectedType,
                          hint: 'Select report type',
                          icon: Icons.flag_rounded,
                          items: ReportType.values.map((t) =>
                            DropdownMenuItem(value: t, child: Text(t.label)),
                          ).toList(),
                          onChanged: (v) {
                            if (v != null) setState(() => _selectedType = v);
                          },
                        ),

                        const SizedBox(height: 20),

                        // Description
                        _FieldLabel(label: 'Description'),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _descCtrl,
                          maxLines: 5,
                          style: const TextStyle(color: _kDark, fontSize: 14),
                          decoration: InputDecoration(
                            hintText:
                                'Describe what happened in detail…',
                            hintStyle: TextStyle(
                                color: _kDark.withOpacity(0.3), fontSize: 13),
                            filled: true,
                            fillColor: _kDark.withOpacity(0.04),
                            contentPadding: const EdgeInsets.all(16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide:
                                  BorderSide(color: _kDark.withOpacity(0.1)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide:
                                  BorderSide(color: _kDark.withOpacity(0.1)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(
                                  color: _kRust, width: 1.8),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Photo evidence
                        _FieldLabel(label: 'Photo Evidence'),
                        const SizedBox(height: 8),
                        _PhotoPicker(
                          image: _image,
                          onPick: _pickImage,
                          onRemove: () => setState(() => _image = null),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Submit button
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: provider.isLoading
                          ? null
                          : () async {
                              final ok = await provider.createReport(
                                reportType: _selectedType.value,
                                description: _descCtrl.text,
                                image: _image,
                              );
                              if (!context.mounted) return;
                              _showSnack(
                                context,
                                ok
                                    ? 'Report submitted successfully'
                                    : 'Failed to submit report',
                                ok,
                              );
                              if (ok) {
                                _descCtrl.clear();
                                setState(() => _image = null);
                                await _checkLocation();
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _kRust,
                        foregroundColor: _kCream,
                        disabledBackgroundColor: _kDark.withOpacity(0.08),
                        disabledForegroundColor: _kDark.withOpacity(0.3),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      icon: provider.isLoading
                          ? const SizedBox(
                              width: 18, height: 18,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2.2, color: _kCream),
                            )
                          : const Icon(Icons.send_rounded, size: 20),
                      label: Text(
                        provider.isLoading ? 'Submitting…' : 'Submit Report',
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w700),
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
}

// ─── Header ───────────────────────────────────────────────────────────────────
class _ReportHeader extends StatelessWidget {
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
              child: Row(children: [
                const Icon(Icons.report_rounded, color: _kCream, size: 28),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Report Issue',
                      style: TextStyle(
                        color: _kCream,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Flag fake valets or suspicious activity',
                      style: TextStyle(
                        color: _kCream.withOpacity(0.65),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Location Banner ──────────────────────────────────────────────────────────
class _LocationBanner extends StatelessWidget {
  final bool hasLocation;
  final double? lat, lng;
  final VoidCallback onRefresh;

  const _LocationBanner({
    required this.hasLocation,
    required this.lat,
    required this.lng,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final color = hasLocation ? _kGreen : const Color(0xFFB87333);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              hasLocation ? Icons.my_location_rounded : Icons.location_off_rounded,
              color: color, size: 19,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hasLocation ? 'Location detected' : 'Location unavailable',
                  style: TextStyle(
                    color: color,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  hasLocation
                      ? '${lat?.toStringAsFixed(5)}, ${lng?.toStringAsFixed(5)}'
                      : 'Tap refresh to detect your location',
                  style: TextStyle(
                    color: color.withOpacity(0.75),
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onRefresh,
            icon: Icon(Icons.refresh_rounded, color: color, size: 20),
            tooltip: 'Refresh location',
          ),
        ],
      ),
    );
  }
}

// ─── Photo Picker ─────────────────────────────────────────────────────────────
class _PhotoPicker extends StatelessWidget {
  final File? image;
  final VoidCallback onPick;
  final VoidCallback onRemove;

  const _PhotoPicker({
    required this.image,
    required this.onPick,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (image != null) {
      return Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.file(
              image!,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 8, right: 8,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                width: 32, height: 32,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.55),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close_rounded,
                    color: Colors.white, size: 17),
              ),
            ),
          ),
        ],
      );
    }

    return GestureDetector(
      onTap: onPick,
      child: Container(
        height: 110,
        width: double.infinity,
        decoration: BoxDecoration(
          color: _kDark.withOpacity(0.04),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _kDark.withOpacity(0.12),
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 42, height: 42,
              decoration: BoxDecoration(
                color: _kRust.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add_photo_alternate_rounded,
                  color: _kRust, size: 22),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tap to attach photo evidence',
              style: TextStyle(
                color: _kDark,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              'JPG, PNG up to 10MB',
              style: TextStyle(
                color: _kDark.withOpacity(0.38),
                fontSize: 11.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Shared helpers ───────────────────────────────────────────────────────────
class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel({required this.label});
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
        hintStyle:
            TextStyle(color: _kDark.withOpacity(0.3), fontSize: 14),
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