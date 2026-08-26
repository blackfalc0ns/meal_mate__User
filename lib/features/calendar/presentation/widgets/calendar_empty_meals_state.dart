import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';

class CalendarEmptyMealsState extends StatelessWidget {
  const CalendarEmptyMealsState({super.key, required this.onAddMeals});

  final VoidCallback? onAddMeals;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Opacity(
          opacity: Spacing.calendarEmptyMealsIllustrationOpacity,
          child: Image.asset(
            Assets.calendarEmptyMealsIllustration,
            width: Spacing.calendarEmptyMealsIllustrationWidth,
            height: Spacing.calendarEmptyMealsIllustrationHeight,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: Spacing.calendarEmptyMealsContentGap),
        Text(
          locale.calendar_empty_meals_title,
          textAlign: TextAlign.center,
          style: getBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size22,
            color: color.onSurface,
          ),
        ),
        const SizedBox(height: Spacing.calendarEmptyMealsContentGap),
        Text(
          locale.calendar_empty_meals_description,
          textAlign: TextAlign.center,
          style:
              getRegularStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size15,
                color: color.onSurfaceVariant,
              ).copyWith(
                height:
                    Spacing.calendarEmptyMealsDescriptionLineHeight /
                    FontSize.size20,
              ),
        ),
        const SizedBox(height: Spacing.xxl),
        SizedBox(
          width: Spacing.calendarEmptyMealsButtonWidth,
          child: AppButton(
            text: locale.calendar_empty_meals_button,
            onPressed: onAddMeals,
            icon: Icons.add_rounded,
            height: Spacing.calendarEmptyMealsButtonHeight,
            borderRadius: Spacing.calendarEmptyMealsButtonRadius,
            fontSize: FontSize.size20,
          
          ),
        ),
      ],
    );
  }
}
