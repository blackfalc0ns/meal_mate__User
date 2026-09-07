import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_programs/presentation/manager/family_programs_state.dart';
import 'package:meal_meat_user/features/family_programs/presentation/widgets/family_program_actions_section.dart';
import 'package:meal_meat_user/features/family_programs/presentation/widgets/family_program_member_section.dart';
import 'package:meal_meat_user/features/family_programs/presentation/widgets/family_program_selection_section.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_program_stepper.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_setup_header_badge.dart';

class FamilyProgramContent extends StatelessWidget {
  const FamilyProgramContent({super.key, required this.state});

  final FamilyPlanState state;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    color.surface;
    locale.localeName;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.familySetupHorizontalPadding,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate.fixed([
              FamilySetupHeaderBadge(title: state.currentFlow?.name),
              const SizedBox(height: Spacing.familyProgramProgressTopGap),
              const FamilyProgramStepper(
                currentStep: 1,
                includeFamilyCreationStep: true,
              ),
              const SizedBox(height: Spacing.familyProgramMemberTopGap),
              FamilyProgramMemberSection(state: state),
              FamilyProgramSelectionSection(state: state),
              FamilyProgramActionsSection(state: state),
              const SizedBox(height: Spacing.xxxl),
            ]),
          ),
        ),
      ],
    );
  }
}
