import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_cached_network_image.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';

class FamilyMealSelectionCard extends StatelessWidget {
  const FamilyMealSelectionCard({
    super.key,
    required this.meal,
    required this.onSelect,
  });

  final CalendarMealEntity meal;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      margin: const EdgeInsets.only(bottom: Spacing.md),
      padding: const EdgeInsets.all(Spacing.cardPadding),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
        border: Border.all(
          color: meal.selected
              ? color.primary.withValues(alpha: 0.5)
              : color.outlineVariant,
          width: meal.selected ? Spacing.border * 1.5 : Spacing.border,
        ),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.04),
            blurRadius: Spacing.xs,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(Spacing.radiusSm),
                child: meal.imageUrl != null && meal.imageUrl!.isNotEmpty
                    ? AppCachedNetworkImage(
                        imageUrl: meal.imageUrl!,
                        width: Spacing.avatarLg,
                        height: Spacing.avatarLg,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: Spacing.avatarLg,
                        height: Spacing.avatarLg,
                        color: color.surfaceContainerHighest,
                        child: Icon(
                          Icons.restaurant_rounded,
                          color: color.onSurfaceVariant,
                          size: Spacing.iconLg,
                        ),
                      ),
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meal.title,
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size13,
                        color: color.onSurface,
                      ),
                    ),
                    const SizedBox(height: Spacing.xs),
                    Text(
                      meal.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: getRegularStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size10,
                        color: color.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.sm,
              vertical: Spacing.xs,
            ),
            decoration: BoxDecoration(
              color: color.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(Spacing.radiusSm),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      locale.family_meal_calorie_unit(meal.calories),
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size10,
                        color: color.onSurface,
                      ),
                    ),
                    Text(
                      locale.family_meal_macros_calories,
                      style: getRegularStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size8,
                        color: color.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                Container(
                  height: Spacing.md,
                  width: Spacing.border,
                  color: color.outlineVariant,
                ),
                Column(
                  children: [
                    Text(
                      locale.family_meal_gram_unit(meal.carbs),
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size10,
                        color: color.onSurface,
                      ),
                    ),
                    Text(
                      locale.family_meal_macros_carbs,
                      style: getRegularStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size8,
                        color: color.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                Container(
                  height: Spacing.md,
                  width: Spacing.border,
                  color: color.outlineVariant,
                ),
                Column(
                  children: [
                    Text(
                      locale.family_meal_gram_unit(meal.protein),
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size10,
                        color: color.onSurface,
                      ),
                    ),
                    Text(
                      locale.family_meal_macros_protein,
                      style: getRegularStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size8,
                        color: color.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                Container(
                  height: Spacing.md,
                  width: Spacing.border,
                  color: color.outlineVariant,
                ),
                Column(
                  children: [
                    Text(
                      locale.family_meal_gram_unit(meal.fat),
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size10,
                        color: color.onSurface,
                      ),
                    ),
                    Text(
                      locale.family_meal_macros_fat,
                      style: getRegularStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size8,
                        color: color.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (meal.allergens.isNotEmpty) ...[
            const SizedBox(height: Spacing.sm),
            Wrap(
              spacing: Spacing.xs,
              runSpacing: Spacing.xs,
              children: meal.allergens.map((allergen) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.sm,
                    vertical: Spacing.xs / 2,
                  ),
                  decoration: BoxDecoration(
                    color: color.surfaceContainerHighest.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(Spacing.radiusPill),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_outline_rounded,
                        size: Spacing.iconSm * 0.75,
                        color: color.onSurfaceVariant,
                      ),
                      const SizedBox(width: Spacing.xs / 2),
                      Text(
                        allergen.label,
                        style: getRegularStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size9,
                          color: color.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
          const SizedBox(height: Spacing.md),
          SizedBox(
            width: double.infinity,
            height: Spacing.buttonSmallHeight,
            child: meal.selected
                ? Container(
                    decoration: BoxDecoration(
                      color: color.primary,
                      borderRadius: BorderRadius.circular(Spacing.radiusPill),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_rounded,
                          size: Spacing.iconSm,
                          color: color.onPrimary,
                        ),
                        const SizedBox(width: Spacing.xs),
                        Text(
                          locale.family_meal_status_selected,
                          style: getBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size12,
                            color: color.onPrimary,
                          ),
                        ),
                      ],
                    ),
                  )
                : OutlinedButton(
                    onPressed: onSelect,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: color.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Spacing.radiusPill),
                      ),
                    ),
                    child: Text(
                      locale.family_meal_button_select,
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size12,
                        color: color.primary,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
