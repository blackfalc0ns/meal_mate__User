import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/meal_details/domain/entities/meal_details_entity.dart';
import 'package:meal_meat_user/features/meal_details/presentation/widgets/meal_details_nutrition_icon.dart';

class MealDetailsNutritionCard extends StatelessWidget {
  const MealDetailsNutritionCard({super.key, required this.item});

  final MealDetailsNutritionEntity item;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Expanded(
      child: Container(
        height: Spacing.avatarLg,
        padding: const EdgeInsets.symmetric(vertical: Spacing.xs),
        decoration: BoxDecoration(
          color: color.tertiaryContainer,
          border: Border.all(color: color.primary),
          borderRadius: BorderRadius.circular(Spacing.radiusMd),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MealDetailsNutritionIcon(type: item.type),
            const SizedBox(height: Spacing.xs),
            Text(
              item.value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: getSemiBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size10,
                color: color.onSurface,
              ).copyWith(height: 1),
            ),
            Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: getRegularStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size10,
                color: color.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
