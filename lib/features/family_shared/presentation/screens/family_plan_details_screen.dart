import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/family_shared/presentation/models/family_ui_models.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/widgets/family_add_member_dialog.dart';
import 'package:meal_meat_user/features/family_checkout/presentation/widgets/family_meals_table.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_members_strip.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_plan_hero_card.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_plan_price_card.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_plan_summary_card.dart';

class FamilyPlanDetailsScreen extends StatelessWidget {
  const FamilyPlanDetailsScreen({
    super.key,
    this.plan,
    this.showBottomSpace = false,
  });

  final FamilyPlanDetailsUiModel? plan;
  final bool showBottomSpace;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final currentPlan = plan;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: locale.family_details_title,
              titleFontSize: FontSize.size18,
            ),
            Expanded(
              child: currentPlan == null
                  ? const SizedBox.shrink()
                  : CustomScrollView(
                      slivers: [
                        SliverPadding(
                          padding: EdgeInsets.only(
                            top: Spacing.xss,
                            right: Spacing.lg,
                            bottom: showBottomSpace ? 104 : Spacing.lg,
                            left: Spacing.lg,
                          ),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate.fixed([
                              FamilyPlanHeroCard(plan: currentPlan),
                              const SizedBox(height: Spacing.xs),
                              FamilyMembersStrip(
                                members: currentPlan.members,
                                onAddTap: () => FamilyAddMemberDialog.show(
                                  context: context,
                                ),
                              ),
                              const SizedBox(height: Spacing.md),
                              FamilyPlanSummaryCard(
                                stats: currentPlan.summaryStats,
                              ),
                              const SizedBox(height: Spacing.md),
                              FamilyMealsTable(members: currentPlan.members),
                              const SizedBox(height: Spacing.md),
                              FamilyPlanPriceCard(plan: currentPlan),
                              const SizedBox(height: Spacing.lg),
                              AppButton(
                                text: locale.family_confirm_plan,
                                onPressed: () {},
                                height: Spacing.compactButtonHeight,
                                borderRadius: Spacing.buttonSmallRadius,
                                color: color.primary,
                                fontSize: FontSize.size17,
                                fontWeight: FontWeight.w600,
                              ),
                            ]),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
