import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/manager/family_package_days_state.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/widgets/family_package_days_duration_section.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/widgets/family_package_days_member_section.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/widgets/family_package_days_package_section.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/widgets/family_package_days_plan_section.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_program_stepper.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_setup_header_badge.dart';

class FamilyPackageDaysContent extends StatelessWidget {
  const FamilyPackageDaysContent({
    super.key,
    required this.state,
    required this.onNextPressed,
    this.programId,
  });

  final FamilyPlanState state;
  final VoidCallback onNextPressed;
  final String? programId;

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
                currentStep: 2,
                includeFamilyCreationStep: true,
              ),
              const SizedBox(height: Spacing.familyProgramMemberTopGap),
              FamilyPackageDaysMemberSection(state: state),
              FamilyPackageDaysPackageSection(state: state),
              const SizedBox(height: Spacing.md),
              const FamilyPackageDaysDurationSection(),
              const SizedBox(height: Spacing.md),
              FamilyPackageDaysPlanSection(
                state: state,
                programId: programId,
                onNextPressed: onNextPressed,
              ),
              const SizedBox(height: Spacing.xxxl),
            ]),
          ),
        ),
      ],
    );
  }
}
