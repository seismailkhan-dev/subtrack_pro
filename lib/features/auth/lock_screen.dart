import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:subtrack_pro/controllers/app_controller.dart';
import 'package:subtrack_pro/core/services/biometric_service.dart';
import 'package:subtrack_pro/core/theme/app_theme.dart';
import 'package:subtrack_pro/features/home/home_screen.dart';
import 'package:subtrack_pro/shared/widgets/app_widgets.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  @override
  void initState() {
    super.initState();
    // Attempt biometric automatically on open
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _attemptUnlock();
    });
  }

  Future<void> _attemptUnlock() async {
    final success = await BiometricService().authenticate();
    if (success) {
      Get.offAll(() => const HomeScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: AppShadows.primary,
                ),
                child: const Center(
                  child: Icon(
                    Icons.fingerprint_rounded,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'SubTrack Pro is Locked',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Please authenticate to access your subscriptions',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondaryLight,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              AppButton(
                label: 'Unlock',
                onTap: _attemptUnlock,
                icon: Icons.lock_open_rounded,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  // Fallback to sign out if they can't unlock it anymore
                  AppController.to.signOutUser();
                },
                child: const Text(
                  'Sign Out',
                  style: TextStyle(color: AppColors.danger),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
