import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/shared/widgets/app_logo.dart';

/// Top bar with leading notification button, centered MealMate logo, and trailing spacer.
class SubscriptionSuccessTopBar extends StatelessWidget {
  const SubscriptionSuccessTopBar({
    super.key,
    this.onNotificationPressed,
    this.onClosePressed,
  });

  final VoidCallback? onNotificationPressed;
  final VoidCallback? onClosePressed;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.screenH,
        vertical: Spacing.sm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: Spacing.avatarSm + Spacing.unit,
            height: Spacing.avatarSm + Spacing.unit,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.surface,
              border: Border.all(color: color.outlineVariant),
            ),
            child: IconButton(
              icon: Icon(
                Icons.notifications_none_rounded,
                size: Spacing.iconSm,
                color: color.onSurface,
              ),
              padding: EdgeInsets.zero,
              onPressed: onNotificationPressed,
            ),
          ),
          const AppLogo(size: Spacing.xl, alignment: CrossAxisAlignment.center),
          Container(
            width: Spacing.avatarSm + Spacing.unit,
            height: Spacing.avatarSm + Spacing.unit,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.surface,
              border: Border.all(color: color.outlineVariant),
            ),
            child: IconButton(
              icon: Icon(
                Icons.close_rounded,
                size: Spacing.iconSm,
                color: color.onSurface,
              ),
              padding: EdgeInsets.zero,
              onPressed: onClosePressed,
            ),
          ),
        ],
      ),
    );
  }
}
