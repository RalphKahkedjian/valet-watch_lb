import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'auth_provider.dart';

const _kRust = Color(0xFFAB3C26);
const _kGreen = Color(0xFF689451);
const _kCream = Color(0xFFF5F2F2);
const _kDark = Color(0xFF1A1208);

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() =>
      _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool _obscure = true;
  String? _error;

  late final AnimationController _fadeCtrl;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();

    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeAnim = CurvedAnimation(
      parent: _fadeCtrl,
      curve: Curves.easeOut,
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _fadeCtrl,
        curve: Curves.easeOutCubic,
      ),
    );

    _fadeCtrl.forward();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light,
    );

    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: _kRust,
      body: Stack(
        children: [
          Positioned(
            top: -60,
            right: -60,
            child: _Circle(
              size: 220,
              color: Colors.white.withOpacity(0.06),
            ),
          ),
          Positioned(
            bottom: 200,
            left: -50,
            child: _Circle(
              size: 160,
              color: _kGreen.withOpacity(0.15),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 64,
                          height: 64,
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
                          'Create Account',
                          style: TextStyle(
                            color: _kCream,
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Join ValetWatch Lebanon',
                          style: TextStyle(
                            color: _kCream.withOpacity(0.65),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Expanded(
                  flex: 4,
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
                        padding: const EdgeInsets.fromLTRB(
                          28,
                          32,
                          28,
                          24,
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Register',
                                style: TextStyle(
                                  color: _kDark,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),

                              const SizedBox(height: 24),

                              _FieldLabel(label: 'Full name'),
                              const SizedBox(height: 8),
                              _InputField(
                                controller: _nameCtrl,
                                hint: 'Your name',
                                icon: Icons.person_outline,
                              ),

                              const SizedBox(height: 16),

                              _FieldLabel(label: 'Email address'),
                              const SizedBox(height: 8),
                              _InputField(
                                controller: _emailCtrl,
                                hint: 'you@example.com',
                                icon: Icons.mail_outline,
                                keyboardType:
                                    TextInputType.emailAddress,
                              ),

                              const SizedBox(height: 16),

                              _FieldLabel(label: 'Phone'),
                              const SizedBox(height: 8),
                              _InputField(
                                controller: _phoneCtrl,
                                hint: '70111222',
                                icon: Icons.phone_outlined,
                                keyboardType: TextInputType.phone,
                              ),

                              const SizedBox(height: 16),

                              _FieldLabel(label: 'Password'),
                              const SizedBox(height: 8),
                              _InputField(
                                controller: _passwordCtrl,
                                hint: '••••••••',
                                icon: Icons.lock_outline,
                                obscure: _obscure,
                                suffix: IconButton(
                                  icon: Icon(
                                    _obscure
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: _kDark.withOpacity(0.4),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscure = !_obscure;
                                    });
                                  },
                                ),
                              ),

                              if (_error != null) ...[
                                const SizedBox(height: 14),
                                Text(
                                  _error!,
                                  style: const TextStyle(
                                    color: _kRust,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],

                              const SizedBox(height: 28),

                              SizedBox(
                                width: double.infinity,
                                height: 54,
                                child: ElevatedButton(
                                  onPressed: auth.isLoading
                                      ? null
                                      : () async {
                                          setState(() {
                                            _error = null;
                                          });

                                          final ok =
                                              await auth.register(
                                            name:
                                                _nameCtrl.text.trim(),
                                            email:
                                                _emailCtrl.text.trim(),
                                            phone:
                                                _phoneCtrl.text.trim(),
                                            password:
                                                _passwordCtrl.text,
                                          );

                                          if (!ok) {
                                            setState(() {
                                              _error =
                                                  'Registration failed';
                                            });
                                          }
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _kRust,
                                    foregroundColor: _kCream,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: auth.isLoading
                                      ? const CircularProgressIndicator(
                                          color: _kCream,
                                        )
                                      : const Text(
                                          'Create Account',
                                          style: TextStyle(
                                            fontWeight:
                                                FontWeight.w700,
                                          ),
                                        ),
                                ),
                              ),

                              const SizedBox(height: 18),

                              Center(
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    'Already have an account? Sign in',
                                    style: TextStyle(color: _kGreen),
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

class _Circle extends StatelessWidget {
  final double size;
  final Color color;

  const _Circle({
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;

  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: _kDark,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
    );
  }
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
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        suffixIcon: suffix,
        filled: true,
        fillColor: _kDark.withOpacity(0.04),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}