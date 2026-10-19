import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/models/family_restaurants_view_data.dart';

class FamilyRestaurantTag extends StatelessWidget {
  const FamilyRestaurantTag({super.key, required this.tag});

  final FamilyRestaurantsFilterData tag;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      height: Spacing.familyRestaurantsTagHeight,
      padding: const EdgeInsets.symmetric(horizontal: Spacing.xs),
      decoration: BoxDecoration(
        color: color.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(
          Spacing.familyRestaurantsFilterRadius,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (tag.icon != null) ...[
            Icon(
              tag.icon,
              color: tag.iconColor ?? color.primary,
              size: Spacing.iconXs,
            ),
            const SizedBox(width: Spacing.xxs),
          ],
          Flexible(
            child: Text(
              tag.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: getBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size8,
                color: color.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
