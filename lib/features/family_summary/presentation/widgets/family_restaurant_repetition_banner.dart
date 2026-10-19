import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class FamilyRestaurantRepetitionBanner extends StatelessWidget {
  const FamilyRestaurantRepetitionBanner({
    super.key,
    required this.limit,
    this.durationDays = 0,
  });

  final int limit;
  final int durationDays;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final message = durationDays > 0
        ? locale.upgrade_summary_repetition(limit, durationDays)
        : locale.family_restaurant_repetition_summary(limit);

    return Row(
      children: [
        Container(
          width: Spacing.avatarSm,
          height: Spacing.avatarSm,
          decoration: BoxDecoration(
            color: color.primaryContainer,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Icon(
            Icons.sync_rounded,
            color: color.primary,
            size: Spacing.iconSm,
          ),
        ),
        const SizedBox(width: Spacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                locale.family_restaurant_repetition_title,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size11,
                  color: color.onSurface,
                ),
              ),
              const SizedBox(height: Spacing.xxs),
              Text(
                message,
                style: getMediumStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size10,
                  color: color.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
