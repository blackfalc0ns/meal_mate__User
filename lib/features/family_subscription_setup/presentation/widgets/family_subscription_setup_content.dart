import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_program_stepper.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/manager/family_subscription_setup_state.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/widgets/family_setup_members_section.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/widgets/family_setup_name_section.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/widgets/family_setup_next_action_section.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/widgets/family_setup_package_banner.dart';

class FamilySubscriptionSetupContent extends StatelessWidget {
  const FamilySubscriptionSetupContent({
    super.key,
    required this.state,
    required this.familyNameController,
    required this.onSaveFamilyName,
  });

  final FamilyPlanState state;
  final TextEditingController familyNameController;
  final VoidCallback onSaveFamilyName;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    color.surface;
    locale.localeName;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: Spacing.md),
          const FamilyProgramStepper(
            currentStep: 0,
            completedSteps: 1,
            includeFamilyCreationStep: true,
          ),
          const SizedBox(height: Spacing.lg),
          FamilySetupPackageBanner(state: state),
          const SizedBox(height: Spacing.md),
          FamilySetupNameSection(
            controller: familyNameController,
            onSubmitted: onSaveFamilyName,
          ),
          const SizedBox(height: Spacing.lg),
          FamilySetupMembersSection(state: state),
          const SizedBox(height: Spacing.xl),
          FamilySetupNextActionSection(onSave: onSaveFamilyName),
          const SizedBox(height: Spacing.xl),
        ],
      ),
    );
  }
}
