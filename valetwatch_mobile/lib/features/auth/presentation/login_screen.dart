import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'auth_provider.dart';

// ─── Brand Colors (same palette) ─────────────────────────────────────────────
const _kRust    = Color(0xFFAB3C26);
const _kGreen   = Color(0xFF689451);
const _kCream   = Color(0xFFF5F2F2);
const _kDark    = Color(0xFF1A1208);

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailCtrl    = TextEditingController(text: 'ralph@test.com');
  final _passwordCtrl = TextEditingController(text: 'password123');
  bool  _obscure      = true;
  String? _error;

  late final AnimationController _fadeCtrl;
  late final Animation<double>   _fadeAnim;
  late final Animation<Offset>   _slideAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _fadeAnim  = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOutCubic));
    _fadeCtrl.forward();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: _kRust,
      body: Stack(
        children: [

          // ── Background decorations ────────────────────────────────────
          Positioned(
            top: -60, right: -60,
            child: _Circle(size: 220, color: Colors.white.withOpacity(0.06)),
          ),
          Positioned(
            top: 80, right: 40,
            child: _Circle(size: 90, color: Colors.white.withOpacity(0.05)),
          ),
          Positioned(
            bottom: 200, left: -50,
            child: _Circle(size: 160, color: _kGreen.withOpacity(0.15)),
          ),

          // ── Content ───────────────────────────────────────────────────
          SafeArea(
            child: Column(
              children: [

                // Top brand area
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon mark
                        Container(
                          width: 64, height: 64,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.25),
                              width: 1.5,
                            ),
                          ),
                          child: const Icon(
                            Icons.local_parking_rounded,
                            color: _kCream,
                            size: 34,
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'ValetWatch',
                          style: TextStyle(
                            color: _kCream,
                            fontSize: 34,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.8,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Protect your car in Lebanon',
                          style: TextStyle(
                            color: _kCream.withOpacity(0.65),
                            fontSize: 14,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Card sheet
                Expanded(
                  flex: 3,
                  child: FadeTransition(
                    opacity: _fadeAnim,
                    child: SlideTransition(
                      position: _slideAnim,
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFDF9F8),
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(36),
                          ),
                        ),
                        padding: const EdgeInsets.fromLTRB(28, 36, 28, 24),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              const Text(
                                'Welcome back',
                                style: TextStyle(
                                  color: _kDark,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.4,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Sign in to your account',
                                style: TextStyle(
                                  color: _kDark.withOpacity(0.45),
                                  fontSize: 14,
                                ),
                              ),

                              const SizedBox(height: 28),

                              // Email field
                              _FieldLabel(label: 'Email address'),
                              const SizedBox(height: 8),
                              _InputField(
                                controller: _emailCtrl,
                                hint: 'you@example.com',
                                icon: Icons.mail_outline_rounded,
                                keyboardType: TextInputType.emailAddress,
                              ),

                              const SizedBox(height: 18),

                              // Password field
                              _FieldLabel(label: 'Password'),
                              const SizedBox(height: 8),
                              _InputField(
                                controller: _passwordCtrl,
                                hint: '••••••••',
                                icon: Icons.lock_outline_rounded,
                                obscure: _obscure,
                                suffix: IconButton(
                                  icon: Icon(
                                    _obscure
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: _kDark.withOpacity(0.4),
                                    size: 20,
                                  ),
                                  onPressed: () =>
                                      setState(() => _obscure = !_obscure),
                                ),
                              ),

                              // Error
                              if (_error != null) ...[
                                const SizedBox(height: 14),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: _kRust.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: _kRust.withOpacity(0.25)),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.error_outline_rounded,
                                          color: _kRust, size: 16),
                                      const SizedBox(width: 8),
                                      Text(
                                        _error!,
                                        style: const TextStyle(
                                          color: _kRust,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],

                              const SizedBox(height: 28),

                              // Login button
                              SizedBox(
                                width: double.infinity,
                                height: 54,
                                child: ElevatedButton(
                                  onPressed: auth.isLoading
                                      ? null
                                      : () async {
                                          setState(() => _error = null);
                                          final ok = await auth.login(
                                            email: _emailCtrl.text.trim(),
                                            password: _passwordCtrl.text,
                                          );
                                          if (!ok) {
                                            setState(() => _error =
                                                'Invalid email or password');
                                          }
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _kRust,
                                    foregroundColor: _kCream,
                                    disabledBackgroundColor:
                                        _kRust.withOpacity(0.5),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: auth.isLoading
                                      ? SizedBox(
                                          width: 22, height: 22,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            color: _kCream.withOpacity(0.8),
                                          ),
                                        )
                                      : const Text(
                                          'Sign In',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                ),
                              ),

                              const SizedBox(height: 16),

                              // Divider
                              Row(children: [
                                Expanded(child: Divider(color: _kDark.withOpacity(0.12))),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: Text('or',
                                      style: TextStyle(
                                          color: _kDark.withOpacity(0.35),
                                          fontSize: 13)),
                                ),
                                Expanded(child: Divider(color: _kDark.withOpacity(0.12))),
                              ]),

                              const SizedBox(height: 16),

                              // Secondary: register hint
                              Center(
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      color: _kDark.withOpacity(0.5),
                                      fontSize: 13,
                                    ),
                                    children: [
                                      const TextSpan(text: "Don't have an account? "),
                                      TextSpan(
                                        text: 'Register',
                                        style: const TextStyle(
                                          color: _kGreen,
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
                    ),
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

// ─── Helpers ─────────────────────────────────────────────────────────────────

class _Circle extends StatelessWidget {
  final double size;
  final Color color;
  const _Circle({required this.size, required this.color});

  @override
  Widget build(BuildContext context) => Container(
        width: size, height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      );
}

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
          letterSpacing: 0.1,
        ),
      );
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscure;
  final TextInputType? keyboardType;
  final Widget? suffix;

  const _InputField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.keyboardType,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: const TextStyle(color: _kDark, fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: _kDark.withOpacity(0.3), fontSize: 14),
        prefixIcon: Icon(icon, color: _kDark.withOpacity(0.35), size: 20),
        suffixIcon: suffix,
        filled: true,
        fillColor: _kDark.withOpacity(0.04),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
    );
  }
}