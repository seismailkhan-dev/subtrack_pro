import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:subtrack_pro/controllers/app_controller.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoCtrl;
  late AnimationController _textCtrl;
  late AnimationController _loaderCtrl;
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _textOpacity;
  late Animation<Offset> _textSlide;
  late Animation<double> _loaderOpacity;

  @override
  void initState() {
    super.initState();

    _logoCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _textCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _loaderCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _logoScale = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _logoCtrl, curve: Curves.elasticOut),
    );
    _logoOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _logoCtrl, curve: const Interval(0, 0.5)),
    );
    _textOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _textCtrl, curve: Curves.easeOut),
    );
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textCtrl, curve: Curves.easeOut));
    _loaderOpacity = Tween<double>(begin: 0, end: 1).animate(_loaderCtrl);

    _startSequence();
  }

  void _startSequence() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _logoCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 500));
    _textCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 400));
    _loaderCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 1400));
    if (mounted) {
     AppController.to.checkUserSession();
    }
  }

  @override
  void dispose() {
    _logoCtrl.dispose();
    _textCtrl.dispose();
    _loaderCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: Stack(
          children: [
            // Background decoration
            Positioned(
              top: -80,
              right: -60,
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.07),
                ),
              ),
            ),
            Positioned(
              bottom: -100,
              left: -80,
              child: Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),
            // Content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  AnimatedBuilder(
                    animation: _logoCtrl,
                    builder: (_, child) => Transform.scale(
                      scale: _logoScale.value,
                      child: Opacity(
                        opacity: _logoOpacity.value,
                        child: child,
                      ),
                    ),
                    child: Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 32,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'S',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 44,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  // Text
                  AnimatedBuilder(
                    animation: _textCtrl,
                    builder: (_, child) => SlideTransition(
                      position: _textSlide,
                      child: Opacity(opacity: _textOpacity.value, child: child),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'SubTrack Pro',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Track. Save. Control.',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.75),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 64),
                  // Loader
                  AnimatedBuilder(
                    animation: _loaderCtrl,
                    builder: (_, child) =>
                        Opacity(opacity: _loaderOpacity.value, child: child),
                    child: SizedBox(
                      width: 32,
                      height: 32,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
