import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/meal_details/domain/entities/meal_details_entity.dart';

class MealDetailsIngredientItem extends StatelessWidget {
  const MealDetailsIngredientItem({super.key, required this.ingredient});

  final MealDetailsIngredientEntity ingredient;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return SizedBox(
      width: Spacing.iconXl,
      child: Column(
        children: [
          Container(
            width: Spacing.iconXl,
            height: Spacing.iconXl,
            padding: const EdgeInsets.all(Spacing.xs),
            decoration: BoxDecoration(
              color: color.surface,
              border: Border.all(color: color.outline),
              borderRadius: BorderRadius.circular(Spacing.radiusSm),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Spacing.radiusXs),
              child: Image.asset(ingredient.asset, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            ingredient.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: getSemiBoldStyle(
              fontFamily: FontConstant.ibmPlexSansArabic,
              fontSize: FontSize.size7,
              color: color.onSurfaceVariant,
            ).copyWith(height: locale.localeName == 'ar' ? 1.45 : 1.2),
          ),
        ],
      ),
    );
  }
}
