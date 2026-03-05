import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:subtrack_pro/core/services/sharedpref_service.dart';
import 'controllers/app_controller.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_router.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefService.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.firebaseOptions);


  Get.put(AppController(),permanent: true);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const SubTrackProApp());
}

class SubTrackProApp extends StatefulWidget {
  const SubTrackProApp({super.key});

  // Global theme notifier — widgets can call SubTrackProApp.of(context).toggleTheme()
  static _SubTrackProAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_SubTrackProAppState>()!;

  @override
  State<SubTrackProApp> createState() => _SubTrackProAppState();
}

class _SubTrackProAppState extends State<SubTrackProApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void setDark(bool dark) {
    setState(() => _themeMode = dark ? ThemeMode.dark : ThemeMode.light);
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'SubTrack Pro',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: _themeMode,
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: AppRoutes.splash,
    );
  }
}
