import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:subtrack_pro/core/services/sharedpref_service.dart';
import 'package:subtrack_pro/features/auth/auth_screen.dart';
import 'package:subtrack_pro/features/home/home_screen.dart';
import 'package:subtrack_pro/features/onboarding/onboarding_screen.dart';
import 'package:subtrack_pro/features/auth/lock_screen.dart';

import '../core/services/drift_service.dart';
import '../core/services/biometric_service.dart';
import '../core/services/notification_service.dart';
import '../data/models/user_model.dart';

class AppController extends GetxController {
  static AppController get to => Get.find();

  final isPremium = false.obs;
  final isLoggedInUser = false.obs;
  final hasLoggedInBefore = false.obs;
  final notificationsEnabled = true.obs;
  final biometricEnabled = false.obs;

  Rxn<UserModel> userData = Rxn<UserModel>();
  final monthlyBudget = 0.0.obs;

  final DriftService _drift = DriftService();

  Future<void> checkUserSession() async {
    isLoggedInUser.value = SharedPrefService.getIsLoggedIn();
    notificationsEnabled.value = SharedPrefService.getIsNotificationsEnabled();
    biometricEnabled.value = SharedPrefService.getIsBiometricEnabled();
    hasLoggedInBefore.value = SharedPrefService.getHasLoggedInBefore();
    final bool isSkipOnboarding = SharedPrefService.getIsSkipOnboarding();

    if (!isSkipOnboarding) {
      Get.offAll(() => const OnboardingScreen());
      return;
    }

    /// will implement in next version
    // if (hasLoggedInBefore.value) {
    //   Get.offAll(() => const AuthScreen());
    //   return;
    // }

    await loadUserData();
    
    if (biometricEnabled.value) {
      Get.offAll(() => const LockScreen());
    } else {
      Get.offAll(() => const HomeScreen());
    }
  }

  Future<void> loadUserData() async {
    final localUser = await _drift.getLastLoggedInUser();
    if (localUser != null) {
      userData.value = localUser;
      isPremium.value = localUser.isPremiumUser;
      monthlyBudget.value = localUser.monthlyBudget;
    }
  }

  Future<void> updateMonthlyBudget(double budget) async {
    if (userData.value == null) {
      // Create a default guest user if none exists
      final newUser = UserModel(
        id: 'guest_${DateTime.now().millisecondsSinceEpoch}',
        name: 'Guest User',
        email: 'guest@subtrack.pro',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        monthlyBudget: budget,
      );
      await _drift.saveUser(newUser);
      userData.value = newUser;
      monthlyBudget.value = budget;
    } else {
      final updatedUser = userData.value!.copyWith(
        monthlyBudget: budget,
        updatedAt: DateTime.now(),
      );
      await _drift.saveUser(updatedUser);
      userData.value = updatedUser;
      monthlyBudget.value = budget;
    }
  }

  Future<void> toggleNotifications(bool value) async {
    notificationsEnabled.value = value;
    await SharedPrefService.saveIsNotificationsEnabled(value);

    // If notifications were turned off, we should cancel all existing notifications
    if (!value) {
      await NotificationService().cancelAllNotifications();
    } else {
      // If turned back on, we probably want to reschedule active subscriptions.
      // But we don't have GetSubscriptionsController easily accessible here.
      // Easiest is to just let them reschedule on next open or update.
    }
  }

  Future<void> toggleBiometric(bool value) async {
    if (value) {
      // Trying to enable it - prompt for authentication
      final success = await BiometricService().authenticate();
      if (success) {
        biometricEnabled.value = true;
        await SharedPrefService.saveIsBiometricEnabled(true);
      } else {
        // Auth failed or canceled, keep it disabled
        biometricEnabled.value = false;
        Get.snackbar('Authentication Failed', 'Could not enable biometric lock');
      }
    } else {
      // Disabling it - we could prompt here too for security, but usually disabling is fine
      // Or we can prompt again to verify it's the owner disabling it:
      final success = await BiometricService().authenticate();
      if (success) {
        biometricEnabled.value = false;
        await SharedPrefService.saveIsBiometricEnabled(false);
      } else {
        Get.snackbar('Authentication Failed', 'Could not disable biometric lock');
      }
    }
  }

  Future<void> signOutUser() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print(e);
    }
    isPremium.value = false;
    userData.value = null;
    await SharedPrefService.clear();
    Get.offAll(() => AuthScreen());
  }
}
