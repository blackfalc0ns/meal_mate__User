import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/text_styles.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class NotificationPreferenceCard extends StatelessWidget {
  const NotificationPreferenceCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isEnabled,
    required this.onChanged,
    this.tagBadge,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool isEnabled;
  final ValueChanged<bool> onChanged;
  final String? tagBadge;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.screenH,
        vertical: Spacing.xxs,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: color.surface,
          borderRadius: BorderRadius.circular(Spacing.cardRadius),
          border: Border.all(
            color: color.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.md,
          vertical: Spacing.sm,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: Spacing.avatarSm + 4,
              height: Spacing.avatarSm + 4,
              decoration: BoxDecoration(
                color: color.primaryContainer.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(Spacing.radiusSm),
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: Spacing.iconSm + 2,
                  color: color.primary,
                ),
              ),
            ),
            const SizedBox(width: Spacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.labelMedium.copyWith(
                      fontSize: 13,
                      color: color.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: Spacing.xxs),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: 11,
                      color: color.onSurfaceVariant,
                      height: 1.25,
                    ),
                  ),
                  if (tagBadge != null) ...[
                    const SizedBox(height: Spacing.xxs),
                    Text(
                      tagBadge!,
                      style: AppTextStyles.caption.copyWith(
                        fontSize: 10,
                        color: color.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: Spacing.xs),
            Transform.scale(
              scale: 0.85,
              child: Switch.adaptive(
                value: isEnabled,
                activeThumbColor: color.primary,
                activeTrackColor: color.primary.withValues(alpha: 0.5),
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
