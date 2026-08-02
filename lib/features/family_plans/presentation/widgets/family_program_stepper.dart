import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_program_stepper_item.dart';

class FamilyProgramStepper extends StatelessWidget {
  const FamilyProgramStepper({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FamilyProgramStepperItem(
              label: locale.family_step_program,
              value: locale.family_step_program,
              selected: true,
            ),
            SizedBox(
              width: Spacing.familyProgramStepLineWidth,
              child: Divider(
                color: color.outline,
                thickness: Spacing.familyProgramStepLineHeight,
              ),
            ),
            FamilyProgramStepperItem(
              label: locale.family_step_package_days,
              value: locale.family_step_package_days,
              number: locale.family_setup_step_two,
            ),
            SizedBox(
              width: Spacing.familyProgramStepLineWidth,
              child: Divider(
                color: color.outline,
                thickness: Spacing.familyProgramStepLineHeight,
              ),
            ),
            FamilyProgramStepperItem(
              label: locale.family_step_payment,
              value: locale.family_step_payment,
              number: locale.family_setup_step_three,
            ),
          ],
        ),
      ],
    );
  }
}
