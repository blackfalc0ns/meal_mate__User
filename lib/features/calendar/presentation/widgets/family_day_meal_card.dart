import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/family_day_details_entity.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/family_day_meal_icon.dart';

class FamilyDayMealCard extends StatelessWidget {
  const FamilyDayMealCard({super.key, required this.meal});

  final FamilyDayMealEntity meal;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return SizedBox(
      height: Spacing.familyDayMealCardHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color.surface,
          border: Border.all(
            color: color.outlineVariant,
            width: Spacing.familyDayMealCardBorderWidth,
          ),
          borderRadius: BorderRadius.circular(Spacing.familyDayMealCardRadius),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: Spacing.familyDayMealImageWidth,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FamilyDayMealIcon(type: meal.iconType),
                        const SizedBox(width: Spacing.sm),
                        Text(
                          meal.mealType,
                          locale: Locale(locale.localeName),
                          style: getBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size12,
                            color: color.onSurface,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Spacing.sm),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                        Spacing.familyDayMealImageRadius,
                      ),
                      child: Image.asset(
                        meal.imageAsset,
                        width: Spacing.familyDayMealImageWidth,
                        height: Spacing.familyDayMealImageHeight,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meal.restaurantName,
                      locale: Locale(locale.localeName),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size12,
                        color: color.onSurface,
                      ),
                    ),
                    const SizedBox(height: Spacing.sm),
                    Text(
                      meal.mealName,
                      locale: Locale(locale.localeName),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: getRegularStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size12,
                        color: color.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: Spacing.md),
              Center(
                child: SizedBox(
                  width: Spacing.familyDayMealButtonWidth,
                  height: Spacing.familyDayMealButtonHeight,
                  child: AppButton.outlined(
                    text: meal.actionLabel,
                    isExpanded: true,
                    height: Spacing.familyDayMealButtonHeight,
                    borderRadius: Spacing.familyDayMealButtonRadius,
                    color: color.primary,
                    textColor: color.primary,
                    fontSize: FontSize.size11,
                    fontWeight: FontWeightManger.bold,
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
