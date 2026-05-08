import 'dart:io' show Platform;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../home_screen.dart';
import '../../theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _loading = false;

  // Email/password form (used on desktop)
  bool _isDesktop = false;
  bool _isSignUp = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Use email/password on web and all desktop platforms.
    // Google Sign-In only works on Android & iOS (requires real OAuth setup).
    _isDesktop = kIsWeb || Platform.isWindows || Platform.isLinux || Platform.isMacOS;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signInGoogle() async {
    setState(() => _loading = true);
    try {
      final result = await AuthService.instance.signInWithGoogle();
      if (result == null) {
        if (mounted) setState(() => _loading = false);
        return; // user cancelled
      }
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
      FirestoreService.instance.ensureProfile().catchError((e) {
        debugPrint('ensureProfile warning: $e');
      });
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      _showError(AuthService.friendlyError(e));
    } catch (e) {
      debugPrint('Google sign-in error: $e');
      if (!mounted) return;
      _showError('Google sign-in failed. Please try again.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _signInWithEmail() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      if (_isSignUp) {
        await AuthService.instance.signUpWithEmail(
          email: _emailController.text,
          password: _passwordController.text,
        );
      } else {
        await AuthService.instance.signInWithEmail(
          email: _emailController.text,
          password: _passwordController.text,
        );
      }
      // Navigate immediately — Firestore profile creation is best-effort
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
      FirestoreService.instance.ensureProfile().catchError((e) {
        debugPrint('ensureProfile warning (non-fatal): $e');
      });
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      _showError(AuthService.friendlyError(e));
    } catch (e) {
      debugPrint('Email sign-in error: $e');
      if (!mounted) return;
      final msg = e.toString().replaceFirst('Exception: ', '');
      _showError(msg.length > 120 ? 'Sign-in failed. Please try again.' : msg);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontFamily: 'Satoshi')),
        backgroundColor: AppColors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.black, width: 2),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colors = context.h;

    return Scaffold(
      backgroundColor: colors.background,
      body: Stack(
        children: [
          // Top Image Area
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: size.height * 0.55,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/loginpage.png'),
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.transparent,
                      colors.background,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // App Name Heading
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 0,
            right: 0,
            child: const Center(
              child: Text(
                'HemiSphere',
                style: TextStyle(
                  fontFamily: 'Clash Display',
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: AppColors.yellow,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),

          // Bottom Content block
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(28, 32, 28, 48),
              decoration: BoxDecoration(
                color: colors.card,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                border: const Border(
                  top: BorderSide(color: AppColors.black, width: 2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Build a Better Community',
                    style: AppTextStyles.displayMedium.copyWith(
                      color: colors.textPrimary,
                      height: 1.1,
                      fontSize: 32,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Connect, engage, and manage your neighborhood safety securely. Hemisphere empowers you to share insights, alert your community, and make your local surroundings safer for everyone.',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: colors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Desktop: show email/password form
                  if (_isDesktop) ...[
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(color: colors.textPrimary),
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(color: colors.textSecondary),
                              filled: true,
                              fillColor: colors.background,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: AppColors.black, width: 2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: colors.textSecondary.withOpacity(0.4), width: 1.5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: AppColors.yellow, width: 2),
                              ),
                            ),
                            validator: (v) =>
                                (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            style: TextStyle(color: colors.textPrimary),
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(color: colors.textSecondary),
                              filled: true,
                              fillColor: colors.background,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: AppColors.black, width: 2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: colors.textSecondary.withOpacity(0.4), width: 1.5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: AppColors.yellow, width: 2),
                              ),
                            ),
                            validator: (v) =>
                                (v == null || v.length < 6) ? 'Password must be at least 6 characters' : null,
                          ),
                          const SizedBox(height: 20),
                          // Sign In / Sign Up button
                          GestureDetector(
                            onTap: _loading ? null : _signInWithEmail,
                            child: Container(
                              width: double.infinity,
                              height: 60,
                              decoration: BoxDecoration(
                                color: AppColors.yellow,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.black, width: 2),
                                boxShadow: const [
                                  BoxShadow(
                                    color: AppColors.black,
                                    blurRadius: 0,
                                    offset: Offset(4, 4),
                                  ),
                                ],
                              ),
                              child: _loading
                                  ? const Center(
                                      child: SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          color: AppColors.black,
                                          strokeWidth: 3,
                                        ),
                                      ),
                                    )
                                  : Center(
                                      child: Text(
                                        _isSignUp ? 'Create Account --->' : 'Sign In --->',
                                        style: AppTextStyles.buttonLarge.copyWith(
                                          color: AppColors.black,
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Toggle sign in / sign up
                          GestureDetector(
                            onTap: () => setState(() => _isSignUp = !_isSignUp),
                            child: Center(
                              child: Text(
                                _isSignUp
                                    ? 'Already have an account? Sign in'
                                    : "Don't have an account? Sign up",
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: colors.textSecondary,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    // Mobile/Web: Google Sign-In button
                    GestureDetector(
                      onTap: _loading ? null : _signInGoogle,
                      child: Container(
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.yellow,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.black, width: 2),
                          boxShadow: const [
                            BoxShadow(
                              color: AppColors.black,
                              blurRadius: 0,
                              offset: Offset(4, 4),
                            ),
                          ],
                        ),
                        child: _loading
                            ? const Center(
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: AppColors.black,
                                    strokeWidth: 3,
                                  ),
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.g_mobiledata_rounded,
                                    color: AppColors.black,
                                    size: 36,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Get Started --->',
                                    style: AppTextStyles.buttonLarge.copyWith(
                                      color: AppColors.black,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
