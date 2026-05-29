import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../data/valet_verification_service.dart';

// ─── Brand Colors ─────────────────────────────────────────────────────────────
const _kRust    = Color(0xFFAB3C26);
const _kGreen   = Color(0xFF689451);
const _kCream   = Color(0xFFF5F2F2);
const _kDark    = Color(0xFF1A1208);
const _kSurface = Color(0xFFFDF9F8);
const _kCard    = Color(0xFFFFFFFF);

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final ValetVerificationService _service = ValetVerificationService();
  bool _isProcessing = false;

  // ─── Handle Scan ────────────────────────────────────────────────────────────
  Future<void> _handleScan(String rawValue) async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);

    try {
      final data     = jsonDecode(rawValue);
      final response = await _service.verifyQr(
        attendantId: data['attendant_id'],
        zoneId:      data['zone_id'],
      );

      if (!mounted) return;

      final bool verified = response['verified'] == true;
      _showResultSheet(verified: verified, message: response['message']);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Invalid QR code'),
          backgroundColor: _kRust,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      setState(() => _isProcessing = false);
    }
  }

  // ─── Result Sheet ───────────────────────────────────────────────────────────
  void _showResultSheet({required bool verified, required String message}) {
    final Color accent = verified ? _kGreen : _kRust;
    final IconData icon = verified
        ? Icons.verified_rounded
        : Icons.gpp_bad_rounded;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      builder: (_) {
        return Container(
          decoration: const BoxDecoration(
            color: _kSurface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.fromLTRB(22, 28, 22,
              MediaQuery.of(context).padding.bottom + 270),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              // drag handle
              Container(
                width: 40, height: 4,
                margin: const EdgeInsets.only(bottom: 28),
                decoration: BoxDecoration(
                  color: _kDark.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // result icon
              Container(
                width: 72, height: 72,
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: accent.withOpacity(0.25), width: 2),
                ),
                child: Icon(icon, color: accent, size: 34),
              ),

              const SizedBox(height: 18),

              Text(
                verified ? 'Valet Verified' : 'Verification Failed',
                style: const TextStyle(
                  color: _kDark,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _kDark.withOpacity(0.55),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 28),

              // CTA
              SizedBox(
                width: double.infinity,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // sheet
                    Navigator.pop(context); // screen
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: accent,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: accent.withOpacity(0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'Done',
                        style: TextStyle(
                          color: _kCream,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
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
    ).whenComplete(() => setState(() => _isProcessing = false));
  }

  // ─── Build ───────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [

          // ── Live camera feed ───────────────────────────────────────────────
          MobileScanner(
            onDetect: (capture) {
              final value = capture.barcodes.first.rawValue;
              if (value != null) _handleScan(value);
            },
          ),

          // ── Scan frame overlay ─────────────────────────────────────────────
          _ScanOverlay(isProcessing: _isProcessing),

          // ── Floating top bar ───────────────────────────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 42, height: 42,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.45),
                        borderRadius: BorderRadius.circular(13),
                        border: Border.all(color: Colors.white.withOpacity(0.15)),
                      ),
                      child: const Icon(Icons.arrow_back_rounded,
                          color: Colors.white, size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 42,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.45),
                        borderRadius: BorderRadius.circular(13),
                        border: Border.all(color: Colors.white.withOpacity(0.15)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.qr_code_scanner_rounded,
                              color: _kCream.withOpacity(0.8), size: 18),
                          const SizedBox(width: 8),
                          const Text(
                            'Scan Valet QR',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
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

          // ── Bottom hint + debug button ─────────────────────────────────────
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(22, 28, 22, 48),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.75),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Point your camera at the\nvalet attendant\'s QR code',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Debug button
                  GestureDetector(
                    onTap: () =>
                        _handleScan('{"attendant_id":1,"zone_id":1}'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 13),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: Colors.white.withOpacity(0.2)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.bug_report_rounded,
                              color: Colors.white.withOpacity(0.7), size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'Test QR Verification',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
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

          // ── Processing overlay ─────────────────────────────────────────────
          if (_isProcessing)
            Container(
              color: Colors.black.withOpacity(0.55),
              child: const Center(
                child: CircularProgressIndicator(color: _kCream),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Scan Overlay (viewfinder frame) ─────────────────────────────────────────
class _ScanOverlay extends StatelessWidget {
  final bool isProcessing;
  const _ScanOverlay({required this.isProcessing});

  @override
  Widget build(BuildContext context) {
    final Color frameColor = isProcessing
        ? _kRust
        : Colors.white;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 240, height: 240,
            child: Stack(
              children: [
                // dim surrounding
                CustomPaint(
                  size: const Size(240, 240),
                  painter: _FramePainter(color: frameColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Frame Painter ────────────────────────────────────────────────────────────
class _FramePainter extends CustomPainter {
  final Color color;
  const _FramePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const double r  = 14; // corner radius
    const double cl = 36; // corner arc length

    final w = size.width;
    final h = size.height;

    // top-left
    canvas.drawArc(Rect.fromLTWH(0, 0, r * 2, r * 2),
        3.14159, 3.14159 / 2, false, paint);
    canvas.drawLine(Offset(r, 0), Offset(r + cl, 0), paint);
    canvas.drawLine(Offset(0, r), Offset(0, r + cl), paint);

    // top-right
    canvas.drawArc(Rect.fromLTWH(w - r * 2, 0, r * 2, r * 2),
        -3.14159 / 2, 3.14159 / 2, false, paint);
    canvas.drawLine(Offset(w - r - cl, 0), Offset(w - r, 0), paint);
    canvas.drawLine(Offset(w, r), Offset(w, r + cl), paint);

    // bottom-left
    canvas.drawArc(Rect.fromLTWH(0, h - r * 2, r * 2, r * 2),
        3.14159 / 2, 3.14159 / 2, false, paint);
    canvas.drawLine(Offset(r, h), Offset(r + cl, h), paint);
    canvas.drawLine(Offset(0, h - r - cl), Offset(0, h - r), paint);

    // bottom-right
    canvas.drawArc(Rect.fromLTWH(w - r * 2, h - r * 2, r * 2, r * 2),
        0, 3.14159 / 2, false, paint);
    canvas.drawLine(Offset(w - r - cl, h), Offset(w - r, h), paint);
    canvas.drawLine(Offset(w, h - r - cl), Offset(w, h - r), paint);
  }

  @override
  bool shouldRepaint(_FramePainter old) => old.color != color;
}