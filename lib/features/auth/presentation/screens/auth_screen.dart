import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:subtrack_pro/controllers/app_controller.dart';
import 'package:subtrack_pro/controllers/auth_controller.dart';
import 'package:subtrack_pro/core/services/sharedpref_service.dart';
import 'package:subtrack_pro/core/services/validation_service.dart';
import 'package:subtrack_pro/features/home/presentation/screens/home_screen.dart';
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
  final _form = GlobalKey<FormState>();
  late AnimationController _animCtrl;

  final authController = Get.put(AuthController());
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
    super.dispose();
  }

  void _switchMode(_AuthMode mode) {
    setState(() => _mode = mode);
    _animCtrl.forward(from: 0);
  }

  void _submit() async {
    if (!(_form.currentState?.validate() ?? false)) return;
    if(_mode == _AuthMode.login){
      authController.loginUser();
    }else if(_mode == _AuthMode.signup){
      authController.signupUser(context);
    }else{
      // forgot password will be implement here
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
              child: Obx((){
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
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

                          // TextButton(
                          //   onPressed: () async{
                          //     await SharedPrefService.saveIsSkipLogin();
                          //     Get.offAll(()=>HomeScreen());
                          //   },
                          //   child: const Text(
                          //     'Skip ',
                          //     style: TextStyle(
                          //         color: AppColors.textSecondaryLight),
                          //   ),
                          // ),
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
                          hint: 'Enter Name',
                          controller: authController.nameTextController,
                          prefixIcon: Icons.person_outline_rounded,
                          validator: ValidationService.validateFullName,
                        ),
                        const SizedBox(height: 16),
                      ],
                      AppTextField(
                        label: 'Email',
                        hint: 'hello@example.com',
                        controller: authController.emailController,
                        prefixIcon: Icons.mail_outline_rounded,
                        keyboardType: TextInputType.emailAddress,
                        validator: ValidationService.validateEmail,

                      ),
                      if (_mode != _AuthMode.forgotPassword) ...[
                        const SizedBox(height: 16),
                        AppTextField(
                          label: 'Password',
                          hint: '••••••••',
                          controller: authController.passwordController,
                          prefixIcon: Icons.lock_outline_rounded,
                          obscure: authController.isObscureText.value,
                          suffix: GestureDetector(
                            onTap: () => authController.changeObscure(),
                            child: Icon(
                              authController.isObscureText.value
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              size: 18,
                              color: AppColors.textSecondaryLight,
                            ),
                          ),
                          validator: ValidationService.validatePassword,

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
                        isLoading: authController.isLoading.value,
                        onTap: _submit,
                      ),

                      if(!AppController.to.hasLoggedInBefore.value && !authController.isLoading.value)...[
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                                child: Divider(
                                    color: isDark
                                        ? AppColors.borderDark
                                        : AppColors.borderLight)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              child: Text('or',
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

                        AppButton(
                          isOutlined: true,
                          label: 'Continue as Guest',
                          isLoading: false,
                          onTap:()async{
                            await SharedPrefService.saveIsGuestUser(true);
                            Get.offAll(()=>HomeScreen());
                          },
                        ),

                      ],


                      // if (_mode != _AuthMode.forgotPassword) ...[
                      //   const SizedBox(height: 24),
                      //   Row(
                      //     children: [
                      //       Expanded(
                      //           child: Divider(
                      //               color: isDark
                      //                   ? AppColors.borderDark
                      //                   : AppColors.borderLight)),
                      //       Padding(
                      //         padding: const EdgeInsets.symmetric(horizontal: 14),
                      //         child: Text('or continue with',
                      //             style: theme.textTheme.bodySmall),
                      //       ),
                      //       Expanded(
                      //           child: Divider(
                      //               color: isDark
                      //                   ? AppColors.borderDark
                      //                   : AppColors.borderLight)),
                      //     ],
                      //   ),
                      //   const SizedBox(height: 16),
                      //   Row(
                      //     children: [
                      //       Expanded(
                      //         child: SocialAuthButton(
                      //           label: 'Google',
                      //           logoText: 'G',
                      //           logoColor: const Color(0xFFEA4335),
                      //           onTap: () {},
                      //         ),
                      //       ),
                      //       const SizedBox(width: 12),
                      //       Expanded(
                      //         child: SocialAuthButton(
                      //           label: 'Apple',
                      //           logoText: '',
                      //           logoColor: isDark ? Colors.white : Colors.black,
                      //           onTap: () {},
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ],

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
                                 TextSpan(
                                  text: _mode == _AuthMode.signup?'Sign in':'Sign up',
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
                  );
                }
              ),
            ),
          ),
        ),
      ),
    );
  }
}
