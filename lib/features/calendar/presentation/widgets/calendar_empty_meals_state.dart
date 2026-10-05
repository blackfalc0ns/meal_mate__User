import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
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
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final slideBegin = isRtl ? 0.08 : -0.08;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
      child:
          Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    Assets.calendarEmptyMealsIllustration,
                    width: 220,
                    height: 160,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: Spacing.md),
                  Text(
                    isNoSubscription
                        ? locale.calendar_no_subscription_title
                        : locale.calendar_empty_meals_title,
                    textAlign: TextAlign.center,
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size20,
                      color: color.onSurface,
                    ).copyWith(height: 1.3),
                  ),
                  const SizedBox(height: Spacing.xs),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
                    child: Text(
                      isNoSubscription
                          ? locale.calendar_no_subscription_description
                          : locale.calendar_empty_meals_description,
                      textAlign: TextAlign.center,
                      style: getRegularStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size14,
                        color: color.onSurfaceVariant,
                      ).copyWith(height: 1.6),
                    ),
                  ),
                  const SizedBox(height: Spacing.xl),
                  SizedBox(
                    width: Spacing.calendarEmptyMealsButtonWidth,
                    child: AppButton(
                      text: isNoSubscription
                          ? locale.calendar_no_subscription_button
                          : locale.calendar_empty_meals_button,
                      onPressed: onAddMeals,
                      icon: isNoSubscription
                          ? Icons.arrow_forward_rounded
                          : Icons.add_rounded,
                      iconBeforeText: false,
                      gradient: color.calendarNoSubscriptionGradient,
                      height: Spacing.calendarEmptyMealsButtonHeight,
                      borderRadius: Spacing.calendarEmptyMealsButtonRadius,
                      fontSize: FontSize.size17,
                    ),
                  ),
                ],
              )
              .animate()
              .fadeIn(duration: 200.ms)
              .slideX(
                begin: slideBegin,
                end: 0,
                duration: 220.ms,
                curve: Curves.easeOutCubic,
              ),
    );
  }
}
