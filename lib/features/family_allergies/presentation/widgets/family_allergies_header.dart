import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_flow_scope.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_program_stepper.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_setup_header_badge.dart';

class FamilyAllergiesHeader extends StatelessWidget {
  const FamilyAllergiesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    if (FamilyFlowScope.isActive(context)) return const SizedBox.shrink();
    return const Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.familySetupHorizontalPadding,
      ),
      child: Column(
        children: [
          FamilySetupHeaderBadge(),
          SizedBox(height: Spacing.md),
          FamilyProgramStepper(currentStep: 3, includeFamilyCreationStep: true),
        ],
      ),
    );
  }
}
