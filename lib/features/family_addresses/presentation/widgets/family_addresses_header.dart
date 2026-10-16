import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/features/family_addresses/presentation/manager/family_addresses_state.dart';
import 'package:meal_meat_user/features/family_addresses/presentation/manager/family_addresses_view_model.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_flow_scope.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_program_stepper.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_setup_header_badge.dart';

class FamilyAddressesHeader extends StatelessWidget {
  const FamilyAddressesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isInFamilyFlow = FamilyFlowScope.isActive(context);
    if (isInFamilyFlow) {
      return const SizedBox.shrink();
    }

    return BlocSelector<
      FamilyAddressesViewModel,
      FamilyAddressesState,
      String?
    >(
      selector: (state) => state.familyName,
      builder: (context, familyName) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FamilySetupHeaderBadge(title: familyName),
            const SizedBox(height: Spacing.md),
            const FamilyProgramStepper(
              currentStep: 2,
              includeFamilyCreationStep: true,
            ),
          ],
        );
      },
    );
  }
}
