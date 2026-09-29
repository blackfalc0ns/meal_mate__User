import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_program_stepper.dart';

class AddressChooseLocationStepperSection extends StatelessWidget {
  const AddressChooseLocationStepperSection({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return PositionedDirectional(
      top: Spacing.familySetupContentTop,
      start: Spacing.familySetupHorizontalPadding,
      end: Spacing.familySetupHorizontalPadding,
      child: ColoredBox(
        color: color.surface,
        child: const FamilyProgramStepper(
          currentStep: 2,
          includeFamilyCreationStep: true,
        ),
      ),
    );
  }
}
