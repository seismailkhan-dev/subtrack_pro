import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/widgets/app_widgets.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  bool _isYearly = false;

  double get _monthlyPrice => 4.99;
  double get _yearlyPrice => 39.99;
  double get _yearlyMonthly => _yearlyPrice / 12;
  int get _savingsPct => ((_monthlyPrice * 12 - _yearlyPrice) / (_monthlyPrice * 12) * 100).round();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(gradient: AppColors.premiumGradient),
          ),
          // Decorative circles
          Positioned(
            top: -100,
            right: -80,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.04),
              ),
            ),
          ),
          Positioned(
            bottom: 200,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.03),
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Column(
              children: [
                // Close button
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close_rounded, color: Colors.white70),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(AppRadius.full),
                        ),
                        child: const Text('✨ SubTrack Pro',
                            style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        // Header
                        const Text(
                          'Unlock Full Power',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Everything you need to master your subscriptions',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.65),
                            fontSize: 15,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),

                        // Billing Toggle
                        _BillingToggle(
                          isYearly: _isYearly,
                          onChanged: (v) => setState(() => _isYearly = v),
                          savingsPct: _savingsPct,
                        ),
                        const SizedBox(height: 24),

                        // Pricing Cards
                        Row(
                          children: [
                            Expanded(
                              child: _PlanCard(
                                title: 'Free',
                                price: '0',
                                period: 'forever',
                                isSelected: false,
                                onTap: () {},
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _PlanCard(
                                title: 'Pro',
                                price: _isYearly
                                    ? _yearlyMonthly.toStringAsFixed(2)
                                    : _monthlyPrice.toStringAsFixed(2),
                                period: '/month',
                                isSelected: true,
                                badge: _isYearly ? 'Best Value' : null,
                                onTap: () {},
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Feature Comparison
                        _FeatureTable(),
                        const SizedBox(height: 24),

                        // Testimonials
                        _TestimonialCard(),
                        const SizedBox(height: 24),

                        // CTA
                        _PremiumCTA(
                          isYearly: _isYearly,
                          monthlyPrice: _monthlyPrice,
                          yearlyPrice: _yearlyPrice,
                        ),
                        const SizedBox(height: 16),

                        // Fine print
                        Text(
                          'Cancel anytime. Billed ${_isYearly ? 'annually at \$$_yearlyPrice' : 'monthly'}. Secure payment.',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.45),
                            fontSize: 11,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
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

class _BillingToggle extends StatelessWidget {
  final bool isYearly;
  final ValueChanged<bool> onChanged;
  final int savingsPct;

  const _BillingToggle({
    required this.isYearly,
    required this.onChanged,
    required this.savingsPct,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          _Tab(label: 'Monthly', isSelected: !isYearly, onTap: () => onChanged(false)),
          _Tab(
            label: 'Yearly',
            isSelected: isYearly,
            onTap: () => onChanged(true),
            badge: 'Save $savingsPct%',
          ),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final String? badge;

  const _Tab({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? AppColors.primary : Colors.white70,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              if (badge != null) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Text(badge!,
                      style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String title;
  final String price;
  final String period;
  final bool isSelected;
  final String? badge;
  final VoidCallback onTap;

  const _PlanCard({
    required this.title,
    required this.price,
    required this.period,
    required this.isSelected,
    this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (badge != null)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  gradient: AppColors.greenGradient,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(badge!,
                    style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)),
              ),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? AppColors.primary : Colors.white70,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 6),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '\$$price',
                    style: TextStyle(
                      color: isSelected ? AppColors.textPrimaryLight : Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(
                    text: '\n$period',
                    style: TextStyle(
                      color: isSelected ? AppColors.textSecondaryLight : Colors.white60,
                      fontSize: 11,
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

class _FeatureTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.07),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: const [
                Expanded(flex: 3, child: SizedBox()),
                Expanded(
                  child: Center(
                    child: Text('Free', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600, fontSize: 12)),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text('Pro ✨', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.white.withOpacity(0.1)),
          ...AppConstants.premiumFeatures.asMap().entries.map((e) {
            final i = e.key;
            final f = e.value;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                  child: Row(
                    children: [
                      Icon(f['icon'] as IconData, size: 16, color: Colors.white54),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 2,
                        child: Text(
                          f['title'] as String,
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Icon(
                            (f['free'] as bool) ? Icons.check_rounded : Icons.close_rounded,
                            size: 16,
                            color: (f['free'] as bool) ? AppColors.accent : Colors.white24,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Icon(
                            (f['pro'] as bool) ? Icons.check_rounded : Icons.close_rounded,
                            size: 16,
                            color: (f['pro'] as bool) ? AppColors.accent : Colors.white24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (i < AppConstants.premiumFeatures.length - 1)
                  Divider(height: 1, color: Colors.white.withOpacity(0.06)),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _TestimonialCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.07),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
      ),
      child: Column(
        children: [
          Row(children: const [
            Text('⭐⭐⭐⭐⭐', style: TextStyle(fontSize: 14)),
            SizedBox(width: 8),
            Text('100K+ Users', style: TextStyle(color: Colors.white70, fontSize: 12)),
          ]),
          const SizedBox(height: 10),
          const Text(
            '"SubTrack Pro helped me identify \$84/month in subscriptions I completely forgot about. Worth every penny!"',
            style: TextStyle(color: Colors.white, fontSize: 13, height: 1.5, fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 10),
          Row(children: [
            Container(width: 32, height: 32,
              decoration: BoxDecoration(gradient: AppColors.greenGradient, shape: BoxShape.circle),
              child: const Center(child: Text('S', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800))),
            ),
            const SizedBox(width: 10),
            const Text('Sarah K., Freelancer', style: TextStyle(color: Colors.white70, fontSize: 12)),
          ]),
        ],
      ),
    );
  }
}

class _PremiumCTA extends StatelessWidget {
  final bool isYearly;
  final double monthlyPrice;
  final double yearlyPrice;

  const _PremiumCTA({
    required this.isYearly,
    required this.monthlyPrice,
    required this.yearlyPrice,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            const Text('Upgrade Now ✨',
                style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 17,
                    fontWeight: FontWeight.w900)),
            const SizedBox(height: 4),
            Text(
              isYearly
                  ? 'Just \$${(yearlyPrice / 12).toStringAsFixed(2)}/month, billed yearly'
                  : '\$${monthlyPrice.toStringAsFixed(2)}/month',
              style: const TextStyle(
                  color: AppColors.textSecondaryLight, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
