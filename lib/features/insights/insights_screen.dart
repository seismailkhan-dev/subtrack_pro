import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/app_widgets.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Insights'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Score Card
            _SpendScoreCard(isDark: isDark),
            const SizedBox(height: 24),

            // Insight Pills
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: const [
                  _FilterChip(label: 'All', isSelected: true),
                  SizedBox(width: 8),
                  _FilterChip(label: '⚠️ Alerts'),
                  SizedBox(width: 8),
                  _FilterChip(label: '💰 Savings'),
                  SizedBox(width: 8),
                  _FilterChip(label: '📊 Trends'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Insight Cards
            ...AppConstants.insightCards.map(
              (card) => InsightCard(
                title: card['title'] as String,
                body: card['body'] as String,
                icon: card['icon'] as IconData,
                color: card['color'] as Color,
                actionLabel: card['action'] as String,
                onAction: () {},
              ),
            ),

            const SizedBox(height: 8),

            // Unused Subscriptions
            Text('Unused Services', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 4),
            Text("Services you haven't engaged with recently",
                style: theme.textTheme.bodySmall),
            const SizedBox(height: 14),
            _UnusedCard(
              name: 'Netflix',
              logoLetter: 'N',
              color: const Color(0xFFE50914),
              price: 15.99,
              daysUnused: 30,
              isDark: isDark,
            ),
            _UnusedCard(
              name: 'Adobe CC',
              logoLetter: 'A',
              color: const Color(0xFFFF0000),
              price: 54.99,
              daysUnused: 12,
              isDark: isDark,
            ),

            const SizedBox(height: 24),

            // Pro Upsell
            _ProUpsellCard(),
          ],
        ),
      ),
    );
  }
}

class _SpendScoreCard extends StatelessWidget {
  final bool isDark;
  const _SpendScoreCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: AppShadows.primary,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Spend Score',
                    style: TextStyle(color: Colors.white70, fontSize: 13)),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text('72',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 48,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -2)),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text('/100',
                          style: TextStyle(
                              color: Colors.white60,
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                const Text('Good — a few improvements possible',
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 72,
            height: 72,
            child: Stack(
              children: [
                CircularProgressIndicator(
                  value: 1,
                  strokeWidth: 8,
                  backgroundColor: Colors.white.withOpacity(0.15),
                  color: Colors.transparent,
                ),
                CircularProgressIndicator(
                  value: 0.72,
                  strokeWidth: 8,
                  backgroundColor: Colors.white.withOpacity(0.15),
                  color: Colors.white,
                ),
                const Center(
                  child: Icon(Icons.trending_up_rounded,
                      color: Colors.white, size: 28),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  const _FilterChip({required this.label, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primary
            : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(
            color: isSelected
                ? AppColors.primary
                : (isDark ? AppColors.borderDark : AppColors.borderLight)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected
              ? Colors.white
              : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _UnusedCard extends StatelessWidget {
  final String name;
  final String logoLetter;
  final Color color;
  final double price;
  final int daysUnused;
  final bool isDark;

  const _UnusedCard({
    required this.name,
    required this.logoLetter,
    required this.color,
    required this.price,
    required this.daysUnused,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
            child: Center(child: Text(logoLetter, style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 18))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(name, style: theme.textTheme.titleSmall),
              Text('Not used in $daysUnused days', style: theme.textTheme.bodySmall),
            ]),
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('\$$price/mo', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: AppColors.danger.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                child: const Text('Cancel', style: TextStyle(color: AppColors.danger, fontSize: 11, fontWeight: FontWeight.w600)),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}

class _ProUpsellCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.premiumGradient,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: const Text('✨ Pro Feature',
                    style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text('Unlock Advanced AI Insights',
              style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          const Text(
            'Get personalized savings tips, price alerts, and spending predictions powered by AI.',
            style: TextStyle(color: Colors.white60, fontSize: 13, height: 1.4),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/premium'),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: const Center(
                child: Text('Upgrade to Pro',
                    style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w800,
                        fontSize: 14)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
