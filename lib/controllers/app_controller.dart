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
  final isLoggedInUser = false.obs;
  final hasLoggedInBefore = false.obs;

  Rxn<UserModel> userData = Rxn<UserModel>();

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