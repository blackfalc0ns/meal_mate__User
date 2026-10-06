import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class RestaurantTierDetailRow extends StatelessWidget {
  const RestaurantTierDetailRow({
    super.key,
    required this.label,
    required this.value,
    this.isStrong = false,
  });

  final String label;
  final String value;
  final bool isStrong;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final textColor = isStrong ? color.primary : color.onSurface;
    final style = isStrong
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
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: style,
            ),
          ),
          const SizedBox(width: Spacing.xs),
          Text(
            value,
            maxLines: 1,
            style: style,
            semanticsLabel: locale.subscription_summary_restaurant_tier_label,
          ),
        ],
      ),
    );
  }
}
