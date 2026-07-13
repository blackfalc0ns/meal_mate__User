import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/meal_details/domain/entities/meal_details_entity.dart';
import 'package:meal_meat_user/features/meal_details/presentation/widgets/meal_details_macro_item.dart';

class MealDetailsMacroDistributionCard extends StatelessWidget {
  const MealDetailsMacroDistributionCard({super.key, required this.meal});

  final MealDetailsEntity meal;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final calories = meal.nutritionItems.last;

    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: color.surface,
        border: Border.all(color: color.outlineVariant),
        borderRadius: BorderRadius.circular(Spacing.radiusSm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            meal.macroDistributionTitle,
            textAlign: TextAlign.right,
            style: getMediumStyle(
              fontFamily: FontConstant.ibmPlexSansArabic,
              fontSize: FontSize.size9,
              color: color.onSurface,
            ).copyWith(height: locale.localeName == 'ar' ? 1.4 : 1.15),
          ),
          const SizedBox(height: Spacing.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final item in meal.macroItems) ...[
                MealDetailsMacroItem(item: item),
                if (item != meal.macroItems.last)
                  SizedBox(
                    height: Spacing.avatarLg,
                    child: VerticalDivider(color: color.outlineVariant),
                  ),
              ],
              SizedBox(
                height: Spacing.avatarLg,
                child: VerticalDivider(color: color.outlineVariant),
              ),
              Expanded(
                child: Column(
                  children: [
                    Icon(
                      Icons.local_fire_department_rounded,
                      color: color.primary,
                      size: Spacing.iconMd,
                    ),
                    const SizedBox(height: Spacing.xs),
                    Text(
                      calories.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: getMediumStyle(
                        fontFamily: FontConstant.ibmPlexSansArabic,
                        fontSize: FontSize.size8,
                        color: color.onSurface,
                      ).copyWith(height: locale.localeName == 'ar' ? 1.4 : 1.1),
                    ),
                    Text(
                      calories.value,
                      style: getBoldStyle(
                        fontFamily: FontConstant.ibmPlexSansArabic,
                        fontSize: FontSize.size18,
                        color: color.onSurface,
                      ).copyWith(height: 1),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
