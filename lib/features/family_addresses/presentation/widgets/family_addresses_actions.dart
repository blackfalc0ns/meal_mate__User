import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_addresses/presentation/manager/family_addresses_state.dart';
import 'package:meal_meat_user/features/family_addresses/presentation/manager/family_addresses_view_model.dart';
import 'package:meal_meat_user/features/family_programs/presentation/widgets/family_program_actions.dart';

class FamilyAddressesActions extends StatelessWidget {
  const FamilyAddressesActions({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<FamilyAddressesViewModel, FamilyAddressesState, bool>(
      selector: (state) =>
          state.completed ||
          (state.members.isNotEmpty &&
              state.completedMemberIds.length == state.members.length),
      builder: (context, isVisible) {
        if (!isVisible) {
          return const SizedBox.shrink();
        }

        final color = context.colorScheme;
        final locale = context.localization;

        return ColoredBox(
          color: color.surface,
          child: Padding(
            padding: const EdgeInsetsDirectional.only(
              start: Spacing.familySetupHorizontalPadding,
              end: Spacing.familySetupHorizontalPadding,
              top: Spacing.xs,
              bottom: Spacing.sm,
            ),
            child: FamilyProgramActions(
              nextText: locale.family_step_allergies,
              nextIcon: Icons.arrow_forward_ios_rounded,
              onNextPressed: context
                  .read<FamilyAddressesViewModel>()
                  .proceedToNextStep,
            ),
          ),
        );
      },
    );
  }
}
