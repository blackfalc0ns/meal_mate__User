import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/family_plans/data/family_plan_fake_data_source.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_add_member_dialog.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_meals_table.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_members_strip.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_plan_hero_card.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_plan_price_card.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_plan_summary_card.dart';

class FamilyPlanDetailsScreen extends StatelessWidget {
  const FamilyPlanDetailsScreen({super.key, this.showBottomSpace = false});

  final bool showBottomSpace;
  static const _dataSource = FamilyPlanFakeDataSource();

  @override
  Widget build(BuildContext context) {
    final l10n = context.localization;
    final plan = _dataSource.getPlan();

    return SafeArea(
      child: Column(
        children: [
          CustomAppBar(
            title: l10n.family_details_title,
            titleFontSize: FontSize.size18,
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    Spacing.lg,
                    Spacing.xss,
                    Spacing.lg,
                    showBottomSpace ? 104 : Spacing.lg,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate.fixed([
                      FamilyPlanHeroCard(plan: plan),
                      const SizedBox(height: Spacing.xs),
                      FamilyMembersStrip(
                        members: plan.members,
                        onAddTap: () => FamilyAddMemberDialog.show(context),
                      ),
                      const SizedBox(height: Spacing.md),
                      FamilyPlanSummaryCard(stats: plan.summaryStats),
                      const SizedBox(height: Spacing.md),
                      FamilyMealsTable(members: plan.members),
                      const SizedBox(height: Spacing.md),
                      FamilyPlanPriceCard(plan: plan),
                      const SizedBox(height: Spacing.lg),
                      AppButton(
                        text: l10n.family_confirm_plan,
                        onPressed: () {},
                        height: Spacing.compactButtonHeight,
                        borderRadius: Spacing.buttonSmallRadius,
                        gradient: AppColors.primaryGradient,
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
    );
  }
}
