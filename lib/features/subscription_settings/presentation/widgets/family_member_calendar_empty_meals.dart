import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class FamilyMemberCalendarEmptyMeals extends StatelessWidget {
  const FamilyMemberCalendarEmptyMeals({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.lg),
      child: Column(
        key: const ValueKey('family-calendar-empty-meals'),
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            Assets.calendarEmptyMealsIllustration,
            width: 220,
            height: 160,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: Spacing.sm),
          Text(
            locale.family_member_no_meals_selected,
            textAlign: TextAlign.center,
            style: getMediumStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size12,
              color: color.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
