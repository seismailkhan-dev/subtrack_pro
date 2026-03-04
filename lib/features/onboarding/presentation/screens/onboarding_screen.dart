import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_router.dart';
import '../../../../shared/widgets/app_widgets.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _ctrl = PageController();
  int _page = 0;

  static const _pages = [
    _OnboardPage(
      icon: Icons.dashboard_rounded,
      emoji: '📊',
      title: 'Track All Subscriptions\nin One Place',
      body:
          'Effortlessly manage every subscription you have — from streaming to SaaS tools.',
      gradient: [Color(0xFF4F46E5), Color(0xFF6366F1)],
    ),
    _OnboardPage(
      icon: Icons.notifications_active_rounded,
      emoji: '🔔',
      title: 'Never Miss\na Renewal',
      body:
          'Smart alerts remind you days before charges hit — so you stay in control.',
      gradient: [Color(0xFF059669), Color(0xFF10B981)],
    ),
    _OnboardPage(
      icon: Icons.savings_rounded,
      emoji: '💰',
      title: 'Save Money\nSmartly',
      body:
          'Get actionable insights. Cut unused subscriptions. Keep more of your money.',
      gradient: [Color(0xFF7C3AED), Color(0xFF8B5CF6)],
    ),
    _OnboardPage(
      icon: Icons.rocket_launch_rounded,
      emoji: '🚀',
      title: "You're Ready\nto Go!",
      body: 'Join 100,000+ users who control their subscriptions with SubTrack Pro.',
      gradient: [Color(0xFFF59E0B), Color(0xFFEF4444)],
    ),
  ];

  void _next() {
    if (_page < _pages.length - 1) {
      _ctrl.nextPage(
          duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _page == _pages.length - 1;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _ctrl,
              onPageChanged: (i) => setState(() => _page = i),
              itemCount: _pages.length,
              itemBuilder: (_, i) => _OnboardPageView(page: _pages[i]),
            ),
          ),
          // Controls
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 0, 28, 52),
            child: Column(
              children: [
                SmoothPageIndicator(
                  controller: _ctrl,
                  count: _pages.length,
                  effect: ExpandingDotsEffect(
                    activeDotColor: AppColors.primary,
                    dotColor: AppColors.borderLight,
                    dotHeight: 8,
                    dotWidth: 8,
                    expansionFactor: 3,
                  ),
                ),
                const SizedBox(height: 28),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: isLast
                      ? Column(
                          key: const ValueKey('last'),
                          children: [
                            AppButton(
                              label: 'Get Started',
                              icon: Icons.arrow_forward_rounded,
                              onTap: () => Navigator.pushReplacementNamed(
                                  context, AppRoutes.home),
                            ),
                            const SizedBox(height: 12),
                            AppButton(
                              label: 'Login',
                              isOutlined: true,
                              onTap: () => Navigator.pushReplacementNamed(
                                  context, AppRoutes.auth),
                            ),
                          ],
                        )
                      : Row(
                          key: const ValueKey('steps'),
                          children: [
                            TextButton(
                              onPressed: () => Navigator.pushReplacementNamed(
                                  context, AppRoutes.auth),
                              child: const Text(
                                'Skip',
                                style: TextStyle(
                                    color: AppColors.textSecondaryLight),
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: _next,
                              child: Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  gradient: AppColors.primaryGradient,
                                  shape: BoxShape.circle,
                                  boxShadow: AppShadows.primary,
                                ),
                                child: const Icon(Icons.arrow_forward_rounded,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardPage {
  final IconData icon;
  final String emoji;
  final String title;
  final String body;
  final List<Color> gradient;

  const _OnboardPage({
    required this.icon,
    required this.emoji,
    required this.title,
    required this.body,
    required this.gradient,
  });
}

class _OnboardPageView extends StatelessWidget {
  final _OnboardPage page;
  const _OnboardPageView({required this.page});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 80, 28, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Illustration area
          Expanded(
            child: Center(
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      page.gradient[0].withOpacity(0.12),
                      page.gradient[1].withOpacity(0.06),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(page.emoji, style: const TextStyle(fontSize: 72)),
                      const SizedBox(height: 8),
                      Icon(page.icon,
                          size: 32, color: page.gradient[0].withOpacity(0.5)),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            page.title,
            style: theme.textTheme.displaySmall?.copyWith(height: 1.2),
          ),
          const SizedBox(height: 14),
          Text(
            page.body,
            style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
          ),
        ],
      ),
    );
  }
}
