import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/features/family_programs/presentation/manager/family_programs_state.dart';
import 'package:meal_meat_user/features/family_programs/presentation/widgets/family_program_actions_section.dart';
import 'package:meal_meat_user/features/family_programs/presentation/widgets/family_program_member_section.dart';
import 'package:meal_meat_user/features/family_programs/presentation/widgets/family_program_selection_section.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_program_stepper.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_setup_header_badge.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_flow_scope.dart';

class FamilyProgramContent extends StatelessWidget {
  const FamilyProgramContent({super.key, required this.state});

  final FamilyPlanState state;

  @override
  Widget build(BuildContext context) {
    final isInFamilyFlow = FamilyFlowScope.isActive(context);
    if (isInFamilyFlow) {
      FamilyFlowScope.updateFamilyName(context, state.currentFlow?.name);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!isInFamilyFlow) ...[
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.familySetupHorizontalPadding,
            ),
            child: Column(
              children: [
                FamilySetupHeaderBadge(title: state.currentFlow?.name),
                const SizedBox(
                  height: Spacing.familyProgramProgressTopGap,
                ),
                const FamilyProgramStepper(
                  currentStep: 1,
                  includeFamilyCreationStep: true,
                ),
              ],
            ),
          ),
        ],
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.familySetupHorizontalPadding,
          ),
          child: FamilyProgramMemberSection(state: state),
        ),
        const SizedBox(height: Spacing.sm),
        Expanded(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.familySetupHorizontalPadding,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate.fixed([
                    FamilyProgramSelectionSection(state: state),
                    const SizedBox(height: Spacing.md),
                  ]),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(
            start: Spacing.familySetupHorizontalPadding,
            end: Spacing.familySetupHorizontalPadding,
            top: Spacing.sm,
            bottom: Spacing.md,
          ),
          child: FamilyProgramActionsSection(state: state),
        ),
      ],
    );
  }
}
