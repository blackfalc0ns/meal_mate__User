import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/meal_details/domain/entities/meal_details_entity.dart';
import 'package:meal_meat_user/features/meal_details/presentation/widgets/meal_details_restaurant_logo.dart';

class MealDetailsTitleSection extends StatelessWidget {
  const MealDetailsTitleSection({super.key, required this.meal});

  final MealDetailsEntity meal;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MealDetailsRestaurantLogo(
          label: meal.restaurantLogo,
          size: 65,
          logoUrl: meal.restaurantLogoUrl,
        ),
        const SizedBox(width: Spacing.base),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                meal.title,

                style: getSemiBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size18,
                  color: color.onSurface,
                ),
              ),
              const SizedBox(height: Spacing.xs),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    meal.restaurantName,
                    textAlign: TextAlign.right,
                    style: getSemiBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size13,
                      color: color.primary,
                    ).copyWith(height: locale.localeName == 'ar' ? 1.3 : 1.1),
                  ),
                  const SizedBox(width: Spacing.xs),
                  Icon(
                    Icons.verified_rounded,
                    color: color.primary,
                    size: Spacing.iconSm,
                  ),
                ],
              ),
              const SizedBox(height: Spacing.xs),
              Text(
                meal.description,
                textAlign: TextAlign.right,
                style: getMediumStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size11,
                  color: color.onSurfaceVariant,
                ).copyWith(height: locale.localeName == 'ar' ? 1.6 : 1.35),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
