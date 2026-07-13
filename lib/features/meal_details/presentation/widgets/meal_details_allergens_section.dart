import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/meal_details/domain/entities/meal_details_entity.dart';
import 'package:meal_meat_user/features/meal_details/presentation/widgets/meal_details_allergen_chip.dart';
import 'package:meal_meat_user/features/meal_details/presentation/widgets/meal_details_section_title.dart';

class MealDetailsAllergensSection extends StatelessWidget {
  const MealDetailsAllergensSection({super.key, required this.meal});

  final MealDetailsEntity meal;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        MealDetailsSectionTitle(title: meal.allergensTitle),
        const SizedBox(height: Spacing.sm),
        Wrap(
          spacing: Spacing.sm,
          runSpacing: Spacing.sm,
          alignment: WrapAlignment.end,
          children: [
            for (final allergen in meal.allergens)
              IconTheme(
                data: IconThemeData(color: color.onSurface),
                child: MealDetailsAllergenChip(allergen: allergen),
              ),
          ],
        ),
        SizedBox(height: locale.localeName == 'ar' ? 0 : Spacing.xs),
      ],
    );
  }
}
