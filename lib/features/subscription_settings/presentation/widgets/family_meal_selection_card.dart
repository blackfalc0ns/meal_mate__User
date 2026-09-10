import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
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
          width: Spacing.border,
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
          _buildImageAndButtonStack(context, color, locale),
        ],
      ),
    );
  }

  Widget _buildImageAndButtonStack(
    BuildContext context,
    ColorScheme color,
    AppLocalizations locale,
  ) {
    const stackWidth = Spacing.familyMealSelectionImageWidth;
    const stackHeight = 118.0;
    const imageHeight = 102.0;
    const buttonHeight = 28.0;

    return SizedBox(
      width: stackWidth,
      height: stackHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: imageHeight,
            child: GestureDetector(
              onTap: onSelect,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Spacing.radiusSm),
                child: meal.imageUrl != null && meal.imageUrl!.isNotEmpty
                    ? AppCachedNetworkImage(
                        imageUrl: meal.imageUrl!,
                        width: stackWidth,
                        height: imageHeight,
                        fit: BoxFit.cover,
                      )
                    : (meal.imageAsset.isNotEmpty
                          ? Image.asset(
                              meal.imageAsset,
                              width: stackWidth,
                              height: imageHeight,
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
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: buttonHeight,
            child: GestureDetector(
              onTap: onSelect,
              behavior: HitTestBehavior.opaque,
              child: Container(
                height: buttonHeight,
                decoration: BoxDecoration(
                  color: meal.selected
                      ? color.primary
                      : color.onSurface.withValues(alpha: 0.75),
                  borderRadius: BorderRadius.circular(Spacing.radiusPill),
                  border: Border.all(color: color.surface, width: Spacing.xxs),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Spacing.xs),
                    child: meal.selected
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 15.0,
                                height: 15.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: color.surface,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.check_rounded,
                                    size: 11.0,
                                    color: color.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: Spacing.sm),
                              Flexible(
                                child: Text(
                                  locale.family_meal_status_selected,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: getBoldStyle(
                                    fontFamily: FontConstant.alexandria,
                                    fontSize: FontSize.size10,
                                    color: color.onPrimary,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Text(
                            locale.family_meal_button_select,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: getBoldStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size10,
                              color: color.surface,
                            ),
                          ),
                  ),
                ),
              ),
            ),
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
