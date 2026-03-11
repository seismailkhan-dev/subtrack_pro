import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  /// Returns the correct FirebaseOptions depending on the platform
  static FirebaseOptions get firebaseOptions {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return const FirebaseOptions(
          apiKey: "AIzaSyD28plGtiwpDsYAml3zHFbmk0OX0QtACQE",
          appId: "1:616010288926:android:e6d54cfefd0426344a830f",
          messagingSenderId: "616010288926",
          projectId: "subtrackpro-9ac16",
          storageBucket: "subtrackpro-9ac16.firebasestorage.app",
        );
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return const FirebaseOptions(
          apiKey: "AIzaSyAu28RvNU8KJUIOMAN2nS_aKUMhbrxoMYI",
          appId: "1:616010288926:ios:cf7b9ee2e01d974e4a830f",
          messagingSenderId: "616010288926",
          projectId: "subtrackpro-9ac16",
          storageBucket: "subtrackpro-9ac16.firebasestorage.app",
          iosBundleId: "com.ikappsstudio.subtrackpro",
        );
      default:
        throw UnsupportedError("DefaultFirebaseOptions are not supported for this platform.");
    }
  }
}