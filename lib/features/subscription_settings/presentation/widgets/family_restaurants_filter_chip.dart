import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_settings/data/family_restaurants_fake_data_source.dart';

class FamilyRestaurantsFilterChip extends StatelessWidget {
  const FamilyRestaurantsFilterChip({super.key, required this.filter});

  final FamilyRestaurantsFilterData filter;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      height: Spacing.familyRestaurantsFilterHeight,
      padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(
          Spacing.familyRestaurantsFilterRadius,
        ),
        border: Border.all(
          color: filter.isSelected ? color.primary : color.outlineVariant,
          width: filter.isSelected ? Spacing.familySelectedBorderWidth : Spacing.border,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (filter.icon != null) ...[
            Icon(
              filter.icon,
              size: Spacing.iconSm,
              color: filter.isSelected ? color.primary : color.onSurfaceVariant,
            ),
            const SizedBox(width: Spacing.xs),
          ],
          Text(
            filter.label,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size11,
              color: filter.isSelected ? color.primary : color.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
