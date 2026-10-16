import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/manager/family_package_days_state.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/widgets/family_package_days_duration_section.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/widgets/family_package_days_member_section.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/widgets/family_package_days_package_section.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/widgets/family_package_days_plan_section.dart';
import 'package:meal_meat_user/features/family_programs/presentation/widgets/family_program_actions.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_program_stepper.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_setup_header_badge.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_flow_scope.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_member_content_loading_skeleton.dart';

class FamilyPackageDaysContent extends StatelessWidget {
  const FamilyPackageDaysContent({
    super.key,
    required this.state,
    required this.onNextPressed,
    this.programId,
  });

  final FamilyPackageDaysState state;
  final VoidCallback onNextPressed;
  final String? programId;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final isInFamilyFlow = FamilyFlowScope.isActive(context);
    if (isInFamilyFlow) {
      FamilyFlowScope.updateFamilyName(context, state.currentFlow?.name);
    }
    final isMemberSwitchLoading =
        state.isBundlesLoading ||
        state.isDurationsLoading ||
        state.isTiersLoading;

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
                const SizedBox(height: Spacing.familyProgramProgressTopGap),
                const FamilyProgramStepper(
                  currentStep: 4,
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
          child: FamilyPackageDaysMemberSection(
            state: state,
            isLoading: isMemberSwitchLoading,
          ),
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
                    if (isMemberSwitchLoading)
                      const FamilyMemberContentLoadingSkeleton()
                    else ...[
                      FamilyPackageDaysPackageSection(state: state),
                      const SizedBox(height: Spacing.md),
                      const FamilyPackageDaysDurationSection(),
                      const SizedBox(height: Spacing.md),
                      FamilyPackageDaysPlanSection(
                        state: state,
                        programId: programId,
                        showActions: false,
                        onNextPressed: onNextPressed,
                      ),
                    ],
                    const SizedBox(height: Spacing.md),
                  ]),
                ),
              ),
            ],
          ),
        ),
        if (!state.isRestaurantsView)
          Padding(
            padding: const EdgeInsetsDirectional.only(
              start: Spacing.familySetupHorizontalPadding,
              end: Spacing.familySetupHorizontalPadding,
              top: Spacing.sm,
              bottom: Spacing.md,
            ),
            child: FamilyProgramActions(
              nextText: locale.family_next_payment,
              nextIcon: Icons.credit_card_rounded,
              onNextPressed: onNextPressed,
            ),
          ),
      ],
    );
  }
}
