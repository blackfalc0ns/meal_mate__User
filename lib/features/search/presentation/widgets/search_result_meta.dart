import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class SearchResultMeta extends StatelessWidget {
  const SearchResultMeta({super.key, required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Semantics(
      label: locale.search_meal_title,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: Spacing.iconSm - Spacing.xs, color: color.primary),
          const SizedBox(width: Spacing.xs),
          Text(
            label,
            style: getMediumStyle(
              fontFamily: FontConstant.ibmPlexSansArabic,
              fontSize: FontSize.size7,
              color: color.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
