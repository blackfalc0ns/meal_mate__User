import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';

class CalendarEmptyMealsState extends StatelessWidget {
  const CalendarEmptyMealsState({
    super.key,
    required this.onAddMeals,
    this.isNoSubscription = false,
  });

  final VoidCallback? onAddMeals;
  final bool isNoSubscription;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
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
          isNoSubscription
              ? locale.calendar_no_subscription_title
              : locale.calendar_empty_meals_title,
          textAlign: TextAlign.center,
          style: getBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size22,
            color: color.onSurface,
          ),
        ),
        const SizedBox(height: Spacing.calendarEmptyMealsContentGap),
        Text(
          isNoSubscription
              ? locale.calendar_no_subscription_description
              : locale.calendar_empty_meals_description,
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
        const SizedBox(height: Spacing.lg),
        SizedBox(
          width: Spacing.calendarEmptyMealsButtonWidth,
          child: AppButton(
            text: isNoSubscription
                ? locale.calendar_no_subscription_button
                : locale.calendar_empty_meals_button,
            onPressed: onAddMeals,
            icon: isNoSubscription
                ? Icons.arrow_forward_ios_rounded
                : Icons.add_rounded,
            gradient: isNoSubscription
                ? color.calendarNoSubscriptionGradient
                : null,
            height: Spacing.calendarEmptyMealsButtonHeight,
            borderRadius: Spacing.calendarEmptyMealsButtonRadius,
            fontSize: isNoSubscription ? FontSize.size17 : FontSize.size20,
          ),
        ),
      ],
    );
  }
}
