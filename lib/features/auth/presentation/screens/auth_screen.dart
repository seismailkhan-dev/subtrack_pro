import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_router.dart';
import '../../../../shared/widgets/app_widgets.dart';

enum _AuthMode { login, signup, forgotPassword }

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  _AuthMode _mode = _AuthMode.login;
  bool _isLoading = false;
  bool _obscure = true;
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _name = TextEditingController();
  final _form = GlobalKey<FormState>();
  late AnimationController _animCtrl;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _email.dispose();
    _password.dispose();
    _name.dispose();
    super.dispose();
  }

  void _switchMode(_AuthMode mode) {
    setState(() => _mode = mode);
    _animCtrl.forward(from: 0);
  }

  void _submit() async {
    if (!(_form.currentState?.validate() ?? false)) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: AnimatedBuilder(
            animation: _animCtrl,
            builder: (_, child) => FadeTransition(
              opacity: CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut),
              child: child,
            ),
            child: Form(
              key: _form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // Header
                  Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text('S',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text('SubTrack Pro', style: theme.textTheme.headlineSmall),
                    ],
                  ),
                  const SizedBox(height: 36),
                  Text(
                    _mode == _AuthMode.forgotPassword
                        ? 'Reset Password'
                        : _mode == _AuthMode.login
                            ? 'Welcome back 👋'
                            : 'Create account ✨',
                    style: theme.textTheme.displaySmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _mode == _AuthMode.forgotPassword
                        ? "We'll send a reset link to your email"
                        : _mode == _AuthMode.login
                            ? 'Sign in to continue'
                            : 'Start your free 14-day trial',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 32),

                  // Fields
                  if (_mode == _AuthMode.signup) ...[
                    AppTextField(
                      label: 'Full Name',
                      hint: 'Ismail Khan',
                      controller: _name,
                      prefixIcon: Icons.person_outline_rounded,
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                  ],
                  AppTextField(
                    label: 'Email',
                    hint: 'hello@example.com',
                    controller: _email,
                    prefixIcon: Icons.mail_outline_rounded,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) =>
                        v == null || !v.contains('@') ? 'Invalid email' : null,
                  ),
                  if (_mode != _AuthMode.forgotPassword) ...[
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'Password',
                      hint: '••••••••',
                      controller: _password,
                      prefixIcon: Icons.lock_outline_rounded,
                      obscure: _obscure,
                      suffix: GestureDetector(
                        onTap: () => setState(() => _obscure = !_obscure),
                        child: Icon(
                          _obscure
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          size: 18,
                          color: AppColors.textSecondaryLight,
                        ),
                      ),
                      validator: (v) => v == null || v.length < 6
                          ? 'Min 6 characters'
                          : null,
                    ),
                  ],

                  if (_mode == _AuthMode.login) ...[
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () => _switchMode(_AuthMode.forgotPassword),
                        child: const Text(
                          'Forgot password?',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 28),
                  AppButton(
                    label: _mode == _AuthMode.forgotPassword
                        ? 'Send Reset Link'
                        : _mode == _AuthMode.login
                            ? 'Sign In'
                            : 'Create Account',
                    isLoading: _isLoading,
                    onTap: _submit,
                  ),

                  if (_mode != _AuthMode.forgotPassword) ...[
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                            child: Divider(
                                color: isDark
                                    ? AppColors.borderDark
                                    : AppColors.borderLight)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Text('or continue with',
                              style: theme.textTheme.bodySmall),
                        ),
                        Expanded(
                            child: Divider(
                                color: isDark
                                    ? AppColors.borderDark
                                    : AppColors.borderLight)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: SocialAuthButton(
                            label: 'Google',
                            logoText: 'G',
                            logoColor: const Color(0xFFEA4335),
                            onTap: () {},
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SocialAuthButton(
                            label: 'Apple',
                            logoText: '',
                            logoColor: isDark ? Colors.white : Colors.black,
                            onTap: () {},
                          ),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 28),
                  // Switch mode
                  Center(
                    child: GestureDetector(
                      onTap: () => _mode == _AuthMode.forgotPassword
                          ? _switchMode(_AuthMode.login)
                          : _switchMode(_mode == _AuthMode.login
                              ? _AuthMode.signup
                              : _AuthMode.login),
                      child: RichText(
                        text: TextSpan(
                          style: theme.textTheme.bodyMedium,
                          children: [
                            TextSpan(
                              text: _mode == _AuthMode.forgotPassword
                                  ? 'Back to '
                                  : _mode == _AuthMode.login
                                      ? "Don't have an account? "
                                      : 'Already have an account? ',
                            ),
                            const TextSpan(
                              text: 'Sign in',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
