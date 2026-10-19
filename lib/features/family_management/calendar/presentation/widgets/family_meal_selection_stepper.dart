import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class FamilyMealSelectionStepper extends StatelessWidget {
  const FamilyMealSelectionStepper({super.key, this.currentStep = 2});

  final int currentStep;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final steps = [
      (title: locale.family_meal_stepper_restaurant, stepNumber: 1),
      (title: locale.family_meal_stepper_meal, stepNumber: 2),
      (title: locale.family_meal_stepper_review, stepNumber: 3),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i < steps.length; i++) ...[
            if (i > 0)
              Expanded(
                child: Container(
                  height: Spacing.border * 2,
                  margin: const EdgeInsets.symmetric(horizontal: Spacing.xs),
                  color: i < currentStep ? color.primary : color.outlineVariant,
                ),
              ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: Spacing.xl,
                  height: Spacing.xl,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: i + 1 < currentStep
                        ? color.primary
                        : (i + 1 == currentStep
                              ? color.primary
                              : color.surface),
                    border: Border.all(
                      color: i + 1 <= currentStep
                          ? color.primary
                          : color.outlineVariant,
                      width: Spacing.border * 1.5,
                    ),
                  ),
                  child: Center(
                    child: i + 1 < currentStep
                        ? Icon(
                            Icons.check_rounded,
                            size: Spacing.iconSm,
                            color: color.onPrimary,
                          )
                        : Text(
                            '${steps[i].stepNumber}',
                            style: getBoldStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size11,
                              color: i + 1 == currentStep
                                  ? color.onPrimary
                                  : color.onSurfaceVariant,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: Spacing.xs),
                Text(
                  steps[i].title,
                  style: i + 1 == currentStep
                      ? getBoldStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size10,
                          color: color.primary,
                        )
                      : getRegularStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size10,
                          color: color.onSurfaceVariant,
                        ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
