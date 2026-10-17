import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class CalendarDeliveryBoxBadge extends StatelessWidget {
  const CalendarDeliveryBoxBadge({
    super.key,
    this.isDarkBackground = true,
  });

  final bool isDarkBackground;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.sm,
        vertical: Spacing.xxs,
      ),
      decoration: BoxDecoration(
        color: isDarkBackground
            ? color.surface
            : color.primaryContainer.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(Spacing.radiusLg),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            Assets.homeDeliveryBox,
            width: Spacing.iconSm,
            height: Spacing.iconSm,
          ),
          const SizedBox(width: Spacing.xs),
          Text(
            locale.calendar_delivery_badge_todays_box,
            style: getSemiBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size10,
              color: color.primary,
            ),
          ),
        ],
      ),
    );
  }
}
