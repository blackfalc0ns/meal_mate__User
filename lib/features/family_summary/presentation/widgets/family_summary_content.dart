import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/features/family_summary/presentation/manager/family_summary_state.dart';
import 'package:meal_meat_user/features/family_summary/presentation/widgets/family_member_restaurants_card.dart';
import 'package:meal_meat_user/features/family_summary/presentation/widgets/family_plan_summary_section.dart';
import 'package:meal_meat_user/features/family_summary/presentation/widgets/family_meal_overview_section.dart';
import 'package:meal_meat_user/features/family_summary/presentation/widgets/family_summary_members_section.dart';
import 'package:meal_meat_user/features/family_summary/presentation/widgets/family_payment_methods_actions_section.dart';
import 'package:meal_meat_user/features/family_summary/presentation/widgets/family_price_summary_section.dart';
import 'package:meal_meat_user/features/family_summary/presentation/widgets/family_subscription_schedule_section.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_program_stepper.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_setup_header_badge.dart';
import 'package:meal_meat_user/features/family_summary/presentation/widgets/family_coupon_card.dart';
import 'package:meal_meat_user/features/family_summary/presentation/widgets/family_delivery_address_section.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_flow_scope.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_member_content_loading_skeleton.dart';

class FamilySummaryContent extends StatelessWidget {
  const FamilySummaryContent({super.key, required this.state});

  final FamilyCheckoutState state;

  @override
  Widget build(BuildContext context) {
    final isInFamilyFlow = FamilyFlowScope.isActive(context);
    if (isInFamilyFlow) {
      FamilyFlowScope.updateFamilyName(context, state.currentFlow?.name);
    }

    return Column(
      children: [
        if (!isInFamilyFlow)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.familySetupHorizontalPadding,
            ),
            child: Column(
              children: [
                FamilySetupHeaderBadge(title: state.currentFlow?.name),
                const SizedBox(height: Spacing.familyProgramProgressTopGap),
                const FamilyProgramStepper(
                  currentStep: 5,
                  includeFamilyCreationStep: true,
                ),
                const SizedBox(height: Spacing.familyProgramMemberTopGap),
              ],
            ),
          ),
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
                    if (isInFamilyFlow)
                      const SizedBox(height: Spacing.familyProgramMemberTopGap),
                    FamilySummaryMembersSection(state: state),
                    const SizedBox(height: Spacing.md),
                    if (state.isSummaryLoading)
                      const FamilyMemberContentLoadingSkeleton()
                    else ...[
                      FamilyPlanSummarySection(state: state),
                      const SizedBox(height: Spacing.md),
                      const FamilyMemberRestaurantsCard(),
                      const SizedBox(height: Spacing.lg),
                      FamilyDeliveryAddressSection(state: state),
                      const SizedBox(height: Spacing.lg),
                      FamilySubscriptionScheduleSection(state: state),
                      const SizedBox(height: Spacing.lg),
                      const FamilyCouponCard(),
                      FamilyPriceSummarySection(summary: state.summary),
                      FamilyMealOverviewSection(
                        summary: state.summary,
                        flowMembers: state.members,
                      ),
                      FamilyPaymentMethodsActionsSection(state: state),
                    ],
                    const SizedBox(height: Spacing.xxxl),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

typedef FamilyPaymentContent = FamilySummaryContent;
