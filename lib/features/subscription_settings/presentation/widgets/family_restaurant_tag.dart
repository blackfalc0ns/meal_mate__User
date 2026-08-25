import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_settings/data/family_restaurants_fake_data_source.dart';

class FamilyRestaurantTag extends StatelessWidget {
  const FamilyRestaurantTag({super.key, required this.tag});

  final FamilyRestaurantsFilterData tag;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    locale.localeName;

    return Container(
      height: Spacing.familyRestaurantsTagHeight,
      padding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
      decoration: BoxDecoration(
        color: color.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(
          Spacing.familyRestaurantsFilterRadius,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
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
          if (tag.icon != null) ...[
            const SizedBox(width: Spacing.xs),
            Icon(tag.icon, color: color.primary, size: Spacing.iconSm),
          ],
        ],
      ),
    );
  }
}
