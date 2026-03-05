import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:subtrack_pro/core/services/sharedpref_service.dart';
import 'package:subtrack_pro/features/auth/presentation/screens/auth_screen.dart';
import 'package:subtrack_pro/features/home/presentation/screens/home_screen.dart';
import 'package:subtrack_pro/features/onboarding/presentation/screens/onboarding_screen.dart';

import '../core/services/drift_service.dart';
import '../data/models/user_model.dart';

class AppController extends GetxController{
  static AppController get to => Get.find();

  final isPremium = false.obs;
  final hasLoggedInBefore = false.obs;

  Rxn<UserModel> userData = Rxn<UserModel>();

  final DriftService _drift = DriftService();


  Future<void> checkUserSession() async {
    final bool isLoggedIn = SharedPrefService.getIsLoggedIn();
    final bool isSkipOnboarding = SharedPrefService.getIsSkipOnboarding();
    final bool isGuestUser = SharedPrefService.getIsGuestUser();
    final bool hasLoggedInBeforeFlag = SharedPrefService.getHasLoggedInBefore();

    // 1️⃣ Show onboarding for first-time users
    if (!isSkipOnboarding) {
      Get.offAll(() => const OnboardingScreen());
      return;
    }

    // 2️⃣ User is currently logged in → load their data
    if (isLoggedIn) {
      await loadUserData();
      Get.offAll(() => const HomeScreen());
      return;
    }

    // 3️⃣ User not logged in
    if (hasLoggedInBeforeFlag) {
      hasLoggedInBefore.value = hasLoggedInBeforeFlag;
      // Previously logged-in user → force login even offline
      Get.offAll(() => const AuthScreen());
      return;
    }

    if (isGuestUser) {
      // First-time guest or returning guest → load local guest data
      await loadUserData();
      Get.offAll(() => const HomeScreen());
      return;
    }

    // 4️⃣ Never logged in / never guest → show AuthScreen
    Get.offAll(() => const AuthScreen());
  }


  Future<void> loadUserData() async {
    final localUser = await _drift.getLastLoggedInUser();
    if(localUser!=null){
      userData.value = localUser;
      isPremium.value = localUser.isPremiumUser;
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