import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class DietaryPreferencesAllergyNotice extends StatelessWidget {
  const DietaryPreferencesAllergyNotice({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      constraints: const BoxConstraints(minHeight: Spacing.dietaryNoticeHeight),
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.md,
        vertical: Spacing.sm,
      ),
      decoration: BoxDecoration(
        color: color.secondaryContainer,
        borderRadius: BorderRadius.circular(Spacing.dietaryCardRadius),
        border: Border.all(color: color.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_rounded, color: color.secondary, size: Spacing.xl),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  locale.dietary_preferences_allergy_notice_title,
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.ibmPlexSansArabic,
                    fontSize: FontSize.size12,
                    color: color.secondary,
                  ),
                ),
                const SizedBox(height: Spacing.xs),
                Text(
                  locale.dietary_preferences_allergy_notice_message,
                  style: getLightStyle(
                    fontFamily: FontConstant.ibmPlexSansArabic,
                    fontSize: FontSize.size11,
                    color: color.onSurfaceVariant,
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
