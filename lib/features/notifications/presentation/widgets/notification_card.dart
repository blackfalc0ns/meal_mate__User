import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/text_styles.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/notifications/domain/entities/notification_item_entity.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
  });

  final NotificationItemEntity notification;
  final VoidCallback onTap;

  IconData _iconFor(NotificationCardIcon iconType) {
    switch (iconType) {
      case NotificationCardIcon.mealCloche:
        return Icons.dinner_dining_rounded;
      case NotificationCardIcon.mealCheck:
        return Icons.check_circle_rounded;
      case NotificationCardIcon.packageCard:
        return Icons.credit_card_rounded;
      case NotificationCardIcon.deliveryTruck:
        return Icons.local_shipping_rounded;
      case NotificationCardIcon.offerGift:
        return Icons.card_giftcard_rounded;
      case NotificationCardIcon.systemRefresh:
        return Icons.sync_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.screenH,
        vertical: Spacing.xxs,
      ),
      child: Material(
        color: color.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Spacing.cardRadius),
          side: BorderSide(color: color.outlineVariant.withValues(alpha: 0.5)),
        ),
        elevation: 0,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(Spacing.cardRadius),
          child: Padding(
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
                      _iconFor(notification.iconType),
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
                        notification.title,
                        style: AppTextStyles.labelMedium.copyWith(
                          fontSize: 12.5,
                          color: color.onSurface,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: Spacing.xxs),
                      Text(
                        notification.body,
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 11,
                          color: color.onSurfaceVariant,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: Spacing.xxs),
                      Text(
                        notification.timeText,
                        style: AppTextStyles.caption.copyWith(
                          fontSize: 10,
                          color: color.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!notification.isRead) ...[
                  const SizedBox(width: Spacing.xs),
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: color.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
