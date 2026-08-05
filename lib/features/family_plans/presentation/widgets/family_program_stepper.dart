import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_program_stepper_item.dart';

class FamilyProgramStepper extends StatelessWidget {
  const FamilyProgramStepper({
    super.key,
    this.currentStep = 2,
    this.completedSteps = 0,
    this.includeFamilyCreationStep = false,
  });

  final int currentStep;
  final int completedSteps;
  final bool includeFamilyCreationStep;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final itemWidth = includeFamilyCreationStep
        ? Spacing.familySetupProcessItemWidth
        : Spacing.familyProgramStepItemWidth;
    final lineWidth = includeFamilyCreationStep
        ? Spacing.familySetupProcessLineWidth
        : Spacing.familyProgramStepLineWidth;
    final labelFontSize = includeFamilyCreationStep
        ? FontSize.size8
        : FontSize.size10;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (includeFamilyCreationStep) ...[
              FamilyProgramStepperItem(
                label: locale.family_step_create_family,
                value: locale.family_step_create_family,
                width: itemWidth,
                labelFontSize: labelFontSize,
                selected: currentStep == 0,
                completed: completedSteps >= 1,
              ),
              SizedBox(
                width: lineWidth,
                child: Divider(
                  color: color.outline,
                  thickness: Spacing.familyProgramStepLineHeight,
                ),
              ),
            ],
            FamilyProgramStepperItem(
              label: locale.family_step_program,
              value: locale.family_step_program,
              width: itemWidth,
              labelFontSize: labelFontSize,
              selected: currentStep == 1,
              completed: currentStep > 1,
            ),
            SizedBox(
              width: lineWidth,
              child: Divider(
                color: color.outline,
                thickness: Spacing.familyProgramStepLineHeight,
              ),
            ),
            FamilyProgramStepperItem(
              label: locale.family_step_package_days,
              value: locale.family_step_package_days,
              number: locale.family_setup_step_two,
              width: itemWidth,
              labelFontSize: labelFontSize,
              selected: currentStep == 2,
              completed: currentStep > 2,
            ),
            SizedBox(
              width: lineWidth,
              child: Divider(
                color: color.outline,
                thickness: Spacing.familyProgramStepLineHeight,
              ),
            ),
            FamilyProgramStepperItem(
              label: locale.family_step_payment,
              value: locale.family_step_payment,
              number: locale.family_setup_step_three,
              width: itemWidth,
              labelFontSize: labelFontSize,
              selected: currentStep == 3,
              completed: currentStep >= 3,
            ),
          ],
        ),
      ],
    );
  }
}
