import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_checkout/presentation/manager/family_checkout_state.dart';
import 'package:meal_meat_user/features/family_checkout/presentation/widgets/family_payment_confirmation_section.dart';
import 'package:meal_meat_user/features/family_checkout/presentation/widgets/family_payment_meal_overview_section.dart';
import 'package:meal_meat_user/features/family_checkout/presentation/widgets/family_payment_members_section.dart';
import 'package:meal_meat_user/features/family_checkout/presentation/widgets/family_payment_methods_actions_section.dart';
import 'package:meal_meat_user/features/family_checkout/presentation/widgets/family_payment_price_section.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_program_stepper.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_setup_header_badge.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_flow_scope.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_member_content_loading_skeleton.dart';

class FamilyPaymentContent extends StatelessWidget {
  const FamilyPaymentContent({super.key, required this.state});

  final FamilyPlanState state;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    color.surface;
    locale.localeName;
    final isInFamilyFlow = FamilyFlowScope.isActive(context);
    if (isInFamilyFlow) {
      FamilyFlowScope.updateFamilyName(context, state.currentFlow?.name);
    }

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.familySetupHorizontalPadding,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate.fixed([
              if (!isInFamilyFlow) ...[
                FamilySetupHeaderBadge(title: state.currentFlow?.name),
                const SizedBox(height: Spacing.familyProgramProgressTopGap),
                const FamilyProgramStepper(
                  currentStep: 5,
                  includeFamilyCreationStep: true,
                ),
              ],
              const SizedBox(height: Spacing.familyProgramMemberTopGap),
              FamilyPaymentMembersSection(state: state),
              const SizedBox(height: Spacing.md),
              if (state.isSummaryLoading)
                const FamilyMemberContentLoadingSkeleton()
              else ...[
                FamilyPaymentConfirmationSection(state: state),
                FamilyPaymentPriceSection(summary: state.summary),
                FamilyPaymentMealOverviewSection(summary: state.summary),
                FamilyPaymentMethodsActionsSection(state: state),
              ],
              const SizedBox(height: Spacing.xxxl),
            ]),
          ),
        ),
      ],
    );
  }
}
