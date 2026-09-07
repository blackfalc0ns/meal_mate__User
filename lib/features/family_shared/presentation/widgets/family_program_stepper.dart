import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_program_stepper_item.dart';

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
    const itemWidth = Spacing.familyProgramStepItemWidth;
    const labelFontSize = FontSize.size10;
    final lineTopOffset =
        (Spacing.familyProgramStepCircleSize -
            Spacing.familyProgramStepLineHeight) /
        2;

    return LayoutBuilder(
      builder: (context, constraints) {
        final stepCount = includeFamilyCreationStep ? 6 : 5;
        final stepSectionWidth = constraints.maxWidth / stepCount;
        final lineInset = stepSectionWidth / 2;
        final lineWidth = constraints.maxWidth - (lineInset * 2);
        final activeStepIndex = includeFamilyCreationStep
            ? currentStep.clamp(0, stepCount - 1)
            : (currentStep - 1).clamp(0, stepCount - 1);
        final progressWidth = lineWidth * (activeStepIndex / (stepCount - 1));

        return Stack(
          children: [
            PositionedDirectional(
              top: lineTopOffset,
              start: lineInset,
              end: lineInset,
              child: Container(
                height: Spacing.familyProgramStepLineHeight,
                color: color.outline,
              ),
            ),
            PositionedDirectional(
              top: lineTopOffset,
              start: lineInset,
              child: Container(
                width: progressWidth,
                height: Spacing.familyProgramStepLineHeight,
                color: color.primary,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (includeFamilyCreationStep)
                  Expanded(
                    child: Center(
                      child: FamilyProgramStepperItem(
                        label: locale.family_step_create_family,
                        value: locale.family_step_create_family,
                        width: itemWidth,
                        labelFontSize: labelFontSize,
                        selected: currentStep == 0,
                        completed: completedSteps >= 1 || currentStep > 0,
                      ),
                    ),
                  ),
                Expanded(
                  child: Center(
                    child: FamilyProgramStepperItem(
                      label: locale.family_step_program,
                      value: locale.family_step_program,
                      width: itemWidth,
                      labelFontSize: labelFontSize,
                      selected: currentStep == 1,
                      completed: currentStep > 1,
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: FamilyProgramStepperItem(
                      label: locale.family_step_location,
                      value: locale.family_step_location,
                      number: locale.family_setup_step_two,
                      width: itemWidth,
                      labelFontSize: labelFontSize,
                      selected: currentStep == 2,
                      completed: currentStep > 2,
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: FamilyProgramStepperItem(
                      label: locale.family_step_allergies,
                      value: locale.family_step_allergies,
                      number: locale.family_setup_step_three,
                      width: itemWidth,
                      labelFontSize: labelFontSize,
                      selected: currentStep == 3,
                      completed: currentStep > 3,
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: FamilyProgramStepperItem(
                      label: locale.family_step_package_days,
                      value: locale.family_step_package_days,
                      number: locale.family_setup_step_four,
                      width: itemWidth,
                      labelFontSize: labelFontSize,
                      selected: currentStep == 4,
                      completed: currentStep > 4,
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: FamilyProgramStepperItem(
                      label: locale.family_step_payment,
                      value: locale.family_step_payment,
                      number: locale.family_setup_step_five,
                      width: itemWidth,
                      labelFontSize: labelFontSize,
                      selected: currentStep == 5,
                      completed: currentStep >= 5,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
