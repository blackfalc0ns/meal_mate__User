import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/text_styles.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class NotificationPreferencesInfoBanner extends StatelessWidget {
  const NotificationPreferencesInfoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.screenH,
        vertical: Spacing.base,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: color.surfaceContainerHighest.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(Spacing.cardRadius),
          border: Border.all(
            color: color.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.cardPadding,
          vertical: Spacing.md,
        ),
        child: Row(
          children: [
            Icon(
              Icons.info_outline_rounded,
              size: Spacing.iconMd,
              color: color.onSurfaceVariant,
            ),
            const SizedBox(width: Spacing.md),
            Expanded(
              child: Text(
                locale.notifications_prefs_footer_info,
                style: AppTextStyles.bodySmall.copyWith(
                  color: color.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
