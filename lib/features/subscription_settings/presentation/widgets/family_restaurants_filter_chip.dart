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
    final locale = context.localization;
    locale.localeName;

    return Container(
      height: Spacing.familyRestaurantsFilterHeight,
      padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
      decoration: BoxDecoration(
        color: filter.isSelected ? color.surfaceContainerLowest : color.surface,
        borderRadius: BorderRadius.circular(
          Spacing.familyRestaurantsFilterRadius,
        ),
        border: Border.all(
          color: filter.isSelected ? color.primary : color.outlineVariant,
        ),
        boxShadow: filter.isSelected
            ? null
            : [
                BoxShadow(
                  color: color.shadow.withValues(alpha: 0.08),
                  offset: const Offset(0, Spacing.xs),
                  blurRadius: Spacing.xs,
                ),
              ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            filter.label,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size9,
              color: filter.isSelected ? color.primary : color.onSurface,
            ),
          ),
          if (filter.icon != null) ...[
            const SizedBox(width: Spacing.xs),
            Icon(
              filter.icon,
              size: Spacing.iconSm,
              color: filter.isSelected ? color.primary : color.primary,
            ),
          ],
        ],
      ),
    );
  }
}
