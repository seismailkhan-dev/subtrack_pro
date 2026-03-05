import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class CustomDropdown extends StatelessWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const CustomDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark2.withOpacity(0.5)
            : AppColors.surfaceLight2,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          items: items
              .map((i) => DropdownMenuItem(value: i, child: Text(i, style: const TextStyle(fontSize: 13))))
              .toList(),
          onChanged: onChanged,
          style: TextStyle(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            fontSize: 14,
          ),
          dropdownColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
        ),
      ),
    );
  }
}
