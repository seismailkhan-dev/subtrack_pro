import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../widgets/app_widgets.dart';

void showSuccessBottomSheet({required BuildContext context, required String title}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) => Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SheetHandle(),

          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              color: AppColors.accent,
              size: 32,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            'Success!',
            style: Theme.of(context).textTheme.headlineSmall,
          ),

          const SizedBox(height: 8),

          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 24),

          AppButton(
            label: 'Great!',
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    ),
  ).then((_) => Navigator.pop(context));
}


