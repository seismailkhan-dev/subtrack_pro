import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:subtrack_pro/features/home/presentation/screens/home_screen.dart';

import '../core/services/flutter_secure_storage_service.dart';
import '../core/services/password_service.dart';
import '../data/models/user_model.dart';
import '../core/services/drift_service.dart';
import '../core/services/firebase_service.dart';
import '../core/services/sharedpref_service.dart';
import '../core/services/sync_service.dart';
import '../shared/widgets/custom_snack_bar.dart';
import 'app_controller.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();

  final emailController = TextEditingController();
  final nameTextController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final FirebaseService _firebase = FirebaseService();
  final DriftService _drift = DriftService();
  late final SyncService _sync;


  RxBool isLoading = false.obs;
  RxBool isObscureText = true.obs;
  RxBool agreeTerms = false.obs;

  @override
  void onInit() {
    super.onInit();
    _sync = SyncService(firebase: _firebase, drift: _drift);
  }

  changeObscure(){ isObscureText.value = !isObscureText.value; }
  changeAgreeTerm(bool value){ agreeTerms.value = value; }

  // ================= SIGNUP =================
  Future<void> signupUser(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      isLoading(true);

      final firebaseUser =
      await _firebase.signUp(email: email, password: password);
      if (firebaseUser == null) throw Exception("Signup failed");

      final user = UserModel(
        id: firebaseUser.uid,
        name: nameTextController.text.trim(),
        email: email,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isSynced: true,
      );

      await _drift.saveUser(user);
      await _firebase.saveUser(user);

      // 🔐 Store password securely
      await SecureStorageService.savePasswordHash(
        user.id,
        PasswordService.hash(password),
      );

      navigateToDashboard(userData: user);

    }  on FirebaseAuthException catch (e) {
      customSnackBar( "Signup Error", e.message ?? "Authentication failed", );
    } catch (e) {
      customSnackBar("Signup Error", e.toString());
    } finally {
      isLoading(false);
    }
  }

  // ================= LOGIN =================
  Future<void> loginUser() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      isLoading(true);

      // 1️⃣ Try offline login
      final localUser = await _drift.getUserByEmail(email);
      print('localUser ${localUser}');
      print('localUser ${localUser?.email}');


      if (localUser != null) {
        final storedHash =
        await SecureStorageService.getPasswordHash(localUser.id);

        if (storedHash != null &&
            PasswordService.verify(password, storedHash)) {
          navigateToDashboard(userData: localUser);
          _sync.syncPendingData(localUser.id);
          return;
        }
      }

      // 2️⃣ Require internet if not found locally
      if (!await _sync.isOnline) {
        throw Exception("No internet. Login online once.");
      }

      // 3️⃣ Firebase login
      final firebaseUser =
      await _firebase.signIn(email: email, password: password);
      if (firebaseUser == null) throw Exception("Login failed");

      final remote =
      await _firebase.fetchUser(firebaseUser.uid);
      if (remote == null) throw Exception("Profile missing");

      final user = UserModel(
        id: firebaseUser.uid,
        name: remote['name'] ?? '',
        email: email,
        isPremiumUser: remote['isPremiumUser'] ?? false,
        createdAt: DateTime.parse(remote['createdAt']),
        updatedAt: DateTime.now(),
        isSynced: true,
      );

      await _drift.saveUser(user);
      await SecureStorageService.savePasswordHash(
        user.id,
        PasswordService.hash(password),
      );

      _sync.syncPendingData(user.id);
      navigateToDashboard(userData: user);

    } on FirebaseAuthException catch (e) {
      customSnackBar( "Login Error", e.message ?? "Authentication failed", );
    } catch (e) {
      customSnackBar("Login Error", e.toString());
    } finally {
      isLoading(false);
    }
  }

  void navigateToDashboard({required UserModel userData}) async {
    await SharedPrefService.saveIsLoggedIn(true);
    await SharedPrefService.saveIsGuestUser(false);
    await SharedPrefService.saveHasIsLoggedInBefore();
    final controller = AppController.to;
    controller.userData.value = userData;
    controller.isPremium.value = userData.isPremiumUser;
    Get.offAll(() => HomeScreen());
  }
}