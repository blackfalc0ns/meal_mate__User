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
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.radiusLg),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size13,
                    color: color.onSurface,
                  ),
                ),
                const SizedBox(height: Spacing.xs / 2),
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
                const SizedBox(height: Spacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatItem(
                      icon: Icons.local_fire_department_rounded,
                      iconColor: color.primary,
                      value: meal.calories,
                      unit: locale.family_meal_macros_calories,
                      color: color,
                    ),
                    _buildStatDivider(color),
                    _buildStatItem(
                      icon: Icons.grain_rounded,
                      iconColor: color.tertiary,
                      value: meal.carbs,
                      unit: locale.family_meal_macros_carbs,
                      color: color,
                    ),
                    _buildStatDivider(color),
                    _buildStatItem(
                      icon: Icons.fitness_center_rounded,
                      iconColor: color.secondary,
                      value: meal.protein,
                      unit: locale.family_meal_macros_protein,
                      color: color,
                    ),
                    _buildStatDivider(color),
                    _buildStatItem(
                      icon: Icons.water_drop_rounded,
                      iconColor: color.error,
                      value: meal.fat,
                      unit: locale.family_meal_macros_fat,
                      color: color,
                    ),
                  ],
                ),
                if (meal.allergens.isNotEmpty) ...[
                  const SizedBox(height: Spacing.sm),
                  Wrap(
                    spacing: Spacing.xs,
                    runSpacing: Spacing.xs / 2,
                    children: meal.allergens.map((allergen) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.xs,
                          vertical: Spacing.xs / 4,
                        ),
                        decoration: BoxDecoration(
                          color: color.surfaceContainerHighest.withValues(
                            alpha: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(Spacing.radiusXs),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.eco_rounded,
                              size: Spacing.iconXs * 0.75,
                              color: color.primary,
                            ),
                            const SizedBox(width: Spacing.xs / 2),
                            Text(
                              allergen.label,
                              style: getRegularStyle(
                                fontFamily: FontConstant.alexandria,
                                fontSize: FontSize.size8,
                                color: color.onSurface,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: Spacing.md),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(Spacing.radiusSm),
                child: SizedBox(
                  width: Spacing.familyMealSelectionImageWidth,
                  height: Spacing.familyMealSelectionImageHeight - 20.0,
                  child: meal.imageUrl != null && meal.imageUrl!.isNotEmpty
                      ? AppCachedNetworkImage(
                          imageUrl: meal.imageUrl!,
                          width: Spacing.familyMealSelectionImageWidth,
                          height: Spacing.familyMealSelectionImageHeight - 20.0,
                          fit: BoxFit.cover,
                        )
                      : (meal.imageAsset.isNotEmpty
                            ? Image.asset(
                                meal.imageAsset,
                                width: Spacing.familyMealSelectionImageWidth,
                                height:
                                    Spacing.familyMealSelectionImageHeight -
                                    20.0,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                color: color.surfaceContainerHighest,
                                child: Icon(
                                  Icons.restaurant_rounded,
                                  color: color.onSurfaceVariant,
                                  size: Spacing.iconLg,
                                ),
                              )),
                ),
              ),
              const SizedBox(height: Spacing.xs),
              InkWell(
                onTap: onSelect,
                borderRadius: BorderRadius.circular(Spacing.radiusPill),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: Spacing.familyMealSelectionImageWidth,
                  height: Spacing.buttonSmallHeight * 0.72,
                  decoration: BoxDecoration(
                    color: meal.selected
                        ? color.primary
                        : color.onSurface.withValues(alpha: 0.75),
                    borderRadius: BorderRadius.circular(Spacing.radiusPill),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Spacing.xs),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (meal.selected) ...[
                            Icon(
                              Icons.check_rounded,
                              size: Spacing.iconXs,
                              color: color.onPrimary,
                            ),
                            const SizedBox(width: Spacing.xs / 2),
                          ],
                          Flexible(
                            child: Text(
                              meal.selected
                                  ? locale.family_meal_status_selected
                                  : locale.family_meal_button_select,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: getBoldStyle(
                                fontFamily: FontConstant.alexandria,
                                fontSize: FontSize.size10,
                                color: meal.selected ? color.onPrimary : color.surface,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatDivider(ColorScheme color) {
    return Container(
      width: Spacing.border,
      height: Spacing.md,
      color: color.outlineVariant,
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String unit,
    required ColorScheme color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: Spacing.iconXs, color: iconColor),
        const SizedBox(height: Spacing.xs / 2),
        Text(
          value,
          style: getBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size10,
            color: color.onSurface,
          ),
        ),
        Text(
          unit,
          style: getRegularStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size8,
            color: color.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
