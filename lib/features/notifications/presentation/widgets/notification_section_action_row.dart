import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/text_styles.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class NotificationSectionActionRow extends StatelessWidget {
  const NotificationSectionActionRow({
    super.key,
    required this.sectionTitle,
    required this.onMarkAllRead,
    this.showMarkAllRead = true,
  });

  final String sectionTitle;
  final VoidCallback onMarkAllRead;
  final bool showMarkAllRead;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.screenH,
        vertical: Spacing.xs,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            sectionTitle,
            style: AppTextStyles.labelMedium.copyWith(
              fontSize: 13,
              color: color.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (showMarkAllRead)
            InkWell(
              onTap: onMarkAllRead,
              borderRadius: BorderRadius.circular(Spacing.radiusSm),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.xs,
                  vertical: Spacing.xxs,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.done_all_rounded,
                      size: Spacing.iconSm - 2,
                      color: color.onSurfaceVariant,
                    ),
                    const SizedBox(width: Spacing.xxs),
                    Text(
                      locale.notifications_mark_all_read,
                      style: AppTextStyles.caption.copyWith(
                        fontSize: 10.5,
                        color: color.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
