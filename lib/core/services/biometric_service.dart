import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class BiometricService {
  static final BiometricService _instance = BiometricService._internal();
  factory BiometricService() => _instance;
  BiometricService._internal();

  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> isBiometricAvailable() async {
    try {
      final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final bool canAuthenticate =
          canAuthenticateWithBiometrics || await _auth.isDeviceSupported();
      return canAuthenticate;
    } on PlatformException catch (e) {
      print('Error checking biometric availability: \$e');
      return false;
    }
  }

  Future<bool> authenticate() async {
    try {
      if (!await isBiometricAvailable()) {
        return false;
      }

      return await _auth.authenticate(
        localizedReason: 'Please authenticate to access SubTrack Pro',
        persistAcrossBackgrounding: true,
        biometricOnly: false, // fallback to PIN/Passcode if needed
      );
    } on PlatformException catch (e) {
      print('Error authenticating with biometrics: \$e');
      return false;
    }
  }
}
