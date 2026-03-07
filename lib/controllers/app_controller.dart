import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:subtrack_pro/core/services/sharedpref_service.dart';
import 'package:subtrack_pro/features/auth/auth_screen.dart';
import 'package:subtrack_pro/features/home/home_screen.dart';
import 'package:subtrack_pro/features/onboarding/onboarding_screen.dart';

import '../core/services/drift_service.dart';
import '../data/models/user_model.dart';

class AppController extends GetxController{
  static AppController get to => Get.find();

  final isPremium = false.obs;
  final isLoggedInUser = false.obs;
  final hasLoggedInBefore = false.obs;

  Rxn<UserModel> userData = Rxn<UserModel>();
  final monthlyBudget = 0.0.obs;

  final DriftService _drift = DriftService();


  Future<void> checkUserSession() async {
    isLoggedInUser.value = SharedPrefService.getIsLoggedIn();
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
    Get.offAll(() => const HomeScreen());
    return;
  }


  Future<void> loadUserData() async {
    final localUser = await _drift.getLastLoggedInUser();
    if(localUser!=null){
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


  Future<void> signOutUser()async{
    try{
      await FirebaseAuth.instance.signOut();
    }catch(e){
      print(e);
    }
    isPremium.value = false;
    userData.value= null;
    await SharedPrefService.clear();
    Get.offAll(()=>AuthScreen());
  }

}