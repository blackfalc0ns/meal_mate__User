import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/manager/family_package_days_state.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/manager/family_package_days_view_model.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/widgets/family_package_days_duration_section.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/widgets/family_package_days_member_section.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/widgets/family_package_days_package_section.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/widgets/family_package_days_plan_section.dart';
import 'package:meal_meat_user/features/family_programs/presentation/widgets/family_program_actions.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_program_stepper.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_setup_header_badge.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_flow_scope.dart';

class FamilyPackageDaysContent extends StatelessWidget {
  const FamilyPackageDaysContent({
    super.key,
    this.state,
    required this.onNextPressed,
    this.programId,
  });

  final FamilyPackageDaysState? state;
  final VoidCallback onNextPressed;
  final String? programId;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final isInFamilyFlow = FamilyFlowScope.isActive(context);

    if (state != null) {
      if (isInFamilyFlow) {
        FamilyFlowScope.updateFamilyName(context, state!.currentFlow?.name);
      }
      return _buildStaticLayout(context, state!, locale, isInFamilyFlow);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!isInFamilyFlow) ...[
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.familySetupHorizontalPadding,
            ),
            child:
                BlocSelector<
                  FamilyPackageDaysViewModel,
                  FamilyPackageDaysState,
                  String?
                >(
                  selector: (s) => s.currentFlow?.name,
                  builder: (context, familyName) {
                    return Column(
                      children: [
                        FamilySetupHeaderBadge(title: familyName),
                        const SizedBox(
                          height: Spacing.familyProgramProgressTopGap,
                        ),
                        const FamilyProgramStepper(
                          currentStep: 4,
                          includeFamilyCreationStep: true,
                        ),
                      ],
                    );
                  },
                ),
          ),
        ],
        const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Spacing.familySetupHorizontalPadding,
          ),
          child: FamilyPackageDaysMemberSection(),
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
                    const FamilyPackageDaysPackageSection(),
                    const SizedBox(height: Spacing.md),
                    const FamilyPackageDaysDurationSection(),
                    const SizedBox(height: Spacing.md),
                    FamilyPackageDaysPlanSection(
                      programId: programId,
                      showActions: false,
                      onNextPressed: onNextPressed,
                    ),
                    const SizedBox(height: Spacing.md),
                  ]),
                ),
              ),
            ],
          ),
        ),
        BlocBuilder<FamilyPackageDaysViewModel, FamilyPackageDaysState>(
          buildWhen: (prev, curr) =>
              prev.plannedMembers != curr.plannedMembers ||
              prev.isRestaurantsView != curr.isRestaurantsView ||
              prev.selectedMemberIndex != curr.selectedMemberIndex ||
              prev.selectedBundleIndex != curr.selectedBundleIndex ||
              prev.selectedDurationIndex != curr.selectedDurationIndex ||
              prev.customDurationDays != curr.customDurationDays ||
              prev.selectedTierIndex != curr.selectedTierIndex,
          builder: (context, currentState) {
            if (currentState.isRestaurantsView) {
              return const SizedBox.shrink();
            }
            final totalMembers = currentState.plannedMembers.length;
            final completedMembers = currentState.completedMembersCount;

            return Padding(
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
                progress: totalMembers == 0
                    ? 0
                    : completedMembers / totalMembers,
                progressLabel: '$completedMembers/$totalMembers',
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildStaticLayout(
    BuildContext context,
    FamilyPackageDaysState s,
    dynamic locale,
    bool isInFamilyFlow,
  ) {
    final totalMembers = s.plannedMembers.length;
    final completedMembers = s.completedMembersCount;

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
                FamilySetupHeaderBadge(title: s.currentFlow?.name),
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
          child: FamilyPackageDaysMemberSection(state: s),
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
                    FamilyPackageDaysPackageSection(state: s),
                    const SizedBox(height: Spacing.md),
                    FamilyPackageDaysDurationSection(state: s),
                    const SizedBox(height: Spacing.md),
                    FamilyPackageDaysPlanSection(
                      state: s,
                      programId: programId,
                      showActions: false,
                      onNextPressed: onNextPressed,
                    ),
                    const SizedBox(height: Spacing.md),
                  ]),
                ),
              ),
            ],
          ),
        ),
        if (!s.isRestaurantsView)
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
              progress: totalMembers == 0 ? 0 : completedMembers / totalMembers,
              progressLabel: '$completedMembers/$totalMembers',
            ),
          ),
      ],
    );
  }
}
