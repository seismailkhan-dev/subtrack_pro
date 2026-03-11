import 'package:flutter/material.dart';
import '../../features/insights/insights_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/auth/auth_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/add_subscription/add_subscription_screen.dart';
import '../../features/subscription_detail/subscription_detail_screen.dart';
import '../../features/analytics/analytics_screen.dart';
import '../../features/calendar/calendar_screen.dart';
import '../../features/premium/premium_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../core/constants/app_constants.dart';

class AppRoutes {
  AppRoutes._();
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String auth = '/auth';
  static const String home = '/home';
  static const String addSubscription = '/add-subscription';
  static const String subscriptionDetail = '/subscription-detail';
  static const String analytics = '/analytics';
  static const String calendar = '/calendar';
  static const String insights = '/insights';
  static const String premium = '/premium';
  static const String settings = '/settings';
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return _buildRoute(const SplashScreen(), settings);
      case AppRoutes.onboarding:
        return _buildRoute(const OnboardingScreen(), settings);
      case AppRoutes.auth:
        return _buildRoute(const AuthScreen(), settings);
      case AppRoutes.home:
        return _buildRoute(const HomeScreen(), settings);
      case AppRoutes.addSubscription:
        return _buildRoute(const AddSubscriptionScreen(), settings);
      case AppRoutes.analytics:
        return _buildRoute(const AnalyticsScreen(), settings);
      case AppRoutes.calendar:
        return _buildRoute(const CalendarScreen(), settings);
      case AppRoutes.insights:
        return _buildRoute(const InsightsScreen(), settings);
      case AppRoutes.premium:
        return _buildRoute(const PremiumScreen(), settings);
      case AppRoutes.settings:
        return _buildRoute(const SettingsScreen(), settings);
      default:
        return _buildRoute(const SplashScreen(), settings);
    }
  }

  static PageRouteBuilder _buildRoute(Widget page, RouteSettings routeSettings) {
    return PageRouteBuilder(
      settings: routeSettings,
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.05, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 280),
    );
  }
}
