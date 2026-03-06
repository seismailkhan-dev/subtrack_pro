import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

Widget AppToggleRow({
  required BuildContext context,
  required String title,
   String? subtitle,
  required bool value,
  required ValueChanged<bool> onChanged,
  IconData? icon,
}){
  final theme = Theme.of(context);
  return Row(
    children: [
      if (icon != null) ...[
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: AppColors.primary),
        ),
        const SizedBox(width: 12),
      ],
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleSmall),
            if (subtitle != null)
              Text(subtitle!, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
      const SizedBox(width: 6),
      Switch(value: value, onChanged: onChanged),
    ],
  );
}