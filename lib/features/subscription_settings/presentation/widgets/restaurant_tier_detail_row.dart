import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/restaurant_tier_upgrade_entity.dart';

class RestaurantTierDetailRow extends StatelessWidget {
  const RestaurantTierDetailRow({super.key, required this.row});

  final RestaurantTierDetailRowEntity row;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final textColor = row.isStrong ? color.primary : color.onSurface;
    final style = row.isStrong
        ? getSemiBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size13,
            color: textColor,
          )
        : getMediumStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size11,
            color: textColor,
          );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.xs),
      child: Row(
        children: [
          Expanded(
            child: Text(
              row.label,
              textAlign: TextAlign.start,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: style,
            ),
          ),
          const SizedBox(width: Spacing.sm),
          Flexible(
            child: Text(
              row.value,
              textAlign: TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: style,
              semanticsLabel: locale.subscription_summary_restaurant_tier_label,
            ),
          ),
        ],
      ),
    );
  }
}
