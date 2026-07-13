import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/meal_details/domain/entities/meal_details_entity.dart';
import 'package:meal_meat_user/features/meal_details/presentation/widgets/meal_details_nutrition_card.dart';
import 'package:meal_meat_user/features/meal_details/presentation/widgets/meal_details_section_title.dart';

class MealDetailsNutritionSection extends StatelessWidget {
  const MealDetailsNutritionSection({
    super.key,
    required this.title,
    required this.items,
  });

  final String title;
  final List<MealDetailsNutritionEntity> items;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MealDetailsSectionTitle(title: title),
        const SizedBox(height: Spacing.xs),
        Row(
          children: [
            for (final item in items) ...[
              MealDetailsNutritionCard(item: item),
              if (item != items.last) const SizedBox(width: Spacing.sm),
            ],
          ],
        ),
        SizedBox(height: locale.localeName == 'ar' ? 0 : Spacing.xs),
        Divider(color: color.outlineVariant),
      ],
    );
  }
}
