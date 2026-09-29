import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/text_styles.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class NotificationEmptyView extends StatelessWidget {
  const NotificationEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: Spacing.avatarLg * 1.3,
              height: Spacing.avatarLg * 1.3,
              decoration: BoxDecoration(
                color: color.primaryContainer.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.notifications_none_rounded,
                  size: Spacing.iconXl,
                  color: color.primary,
                ),
              ),
            ),
            const SizedBox(height: Spacing.lg),
            Text(
              locale.notifications_empty_title,
              textAlign: TextAlign.center,
              style: AppTextStyles.h4.copyWith(
                color: color.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: Spacing.sm),
            Text(
              locale.notifications_empty_subtitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: color.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
