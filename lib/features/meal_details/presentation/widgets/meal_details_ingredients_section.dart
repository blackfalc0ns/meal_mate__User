import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/meal_details/domain/entities/meal_details_entity.dart';
import 'package:meal_meat_user/features/meal_details/presentation/widgets/meal_details_ingredient_item.dart';
import 'package:meal_meat_user/features/meal_details/presentation/widgets/meal_details_section_title.dart';

class MealDetailsIngredientsSection extends StatelessWidget {
  const MealDetailsIngredientsSection({super.key, required this.meal});

  final MealDetailsEntity meal;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MealDetailsSectionTitle(title: meal.ingredientsTitle),
        const SizedBox(height: Spacing.xs),
        DecoratedBox(
          decoration: BoxDecoration(
            border: Border.symmetric(
              horizontal: BorderSide(color: color.outlineVariant),
            ),
          ),
          child: SizedBox(
            height: Spacing.avatarLg + Spacing.md,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final itemsWidth =
                    meal.ingredients.length * Spacing.iconXl +
                    (meal.ingredients.length - 1) * Spacing.md +
                    Spacing.xl +
                    Spacing.xl;
                final needsScroll = itemsWidth > constraints.maxWidth;

                return Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsetsDirectional.only(
                        start: Spacing.xl,
                        end: Spacing.xl,
                        top: Spacing.xs,
                        bottom: Spacing.xs,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (final ingredient in meal.ingredients) ...[
                            MealDetailsIngredientItem(ingredient: ingredient),
                            if (ingredient != meal.ingredients.last)
                              const SizedBox(width: Spacing.md),
                          ],
                        ],
                      ),
                    ),
                    if (needsScroll)
                      Positioned(
                        left: 0,
                        child: IgnorePointer(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: color.surface.withValues(alpha: 0.92),
                              shape: BoxShape.circle,
                              border: Border.all(color: color.outlineVariant),
                            ),
                            child: Icon(
                              Icons.chevron_left_rounded,
                              semanticLabel: locale.calendar_ingredients,
                              size: Spacing.iconMd,
                              color: color.onSurface,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
        SizedBox(height: locale.localeName == 'ar' ? 0 : Spacing.xs),
      ],
    );
  }
}
