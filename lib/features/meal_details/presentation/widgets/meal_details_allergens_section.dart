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

    final isAr = context.localization.localeName == 'ar';
    final allergens = meal.allergens.isNotEmpty
        ? meal.allergens
        : [
            MealDetailsAllergenEntity(
              label: isAr ? 'جلوتين' : 'Gluten',
              type: MealDetailsAllergenType.gluten,
            ),
            MealDetailsAllergenEntity(
              label: isAr ? 'لاكتوز' : 'Lactose',
              type: MealDetailsAllergenType.lactose,
            ),
            MealDetailsAllergenEntity(
              label: isAr ? 'مكسرات' : 'Nuts',
              type: MealDetailsAllergenType.nuts,
            ),
          ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MealDetailsSectionTitle(title: meal.allergensTitle),
        const SizedBox(height: Spacing.sm),
        Wrap(
          spacing: Spacing.sm,
          runSpacing: Spacing.sm,
          alignment: WrapAlignment.start,
          children: [
            for (final allergen in allergens)
              IconTheme(
                data: IconThemeData(color: color.secondary),
                child: MealDetailsAllergenChip(allergen: allergen),
              ),
          ],
        ),
      ],
    );
  }
}
