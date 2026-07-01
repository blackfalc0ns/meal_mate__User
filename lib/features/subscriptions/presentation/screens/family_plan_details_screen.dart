import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/subscriptions/data/family_plan_fake_data_source.dart';
import 'package:meal_meat_user/features/subscriptions/presentation/widgets/family_add_member_dialog.dart';
import 'package:meal_meat_user/features/subscriptions/presentation/widgets/family_meals_table.dart';
import 'package:meal_meat_user/features/subscriptions/presentation/widgets/family_members_strip.dart';
import 'package:meal_meat_user/features/subscriptions/presentation/widgets/family_plan_hero_card.dart';
import 'package:meal_meat_user/features/subscriptions/presentation/widgets/family_plan_price_card.dart';
import 'package:meal_meat_user/features/subscriptions/presentation/widgets/family_plan_summary_card.dart';

class FamilyPlanDetailsScreen extends StatelessWidget {
  const FamilyPlanDetailsScreen({super.key, this.showBottomSpace = false});

  final bool showBottomSpace;
  static const _dataSource = FamilyPlanFakeDataSource();

  @override
  Widget build(BuildContext context) {
    final l10n = context.localization;
    final plan = _dataSource.getPlan();

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: CustomAppBar(title: l10n.family_details_title),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: Spacing.screenH,
              vertical: showBottomSpace ? Spacing.screenV : 0,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate.fixed([
                FamilyPlanHeroCard(plan: plan),
                const SizedBox(height: Spacing.md),
                FamilyMembersStrip(
                  members: plan.members,
                  onAddTap: () => FamilyAddMemberDialog.show(context),
                ),
                const SizedBox(height: Spacing.md),
                FamilyPlanSummaryCard(stats: plan.summaryStats),
                const SizedBox(height: Spacing.sm),
                FamilyMealsTable(members: plan.members),
                const SizedBox(height: Spacing.md),
                FamilyPlanPriceCard(plan: plan),
                const SizedBox(height: Spacing.lg),
                _ConfirmButton(label: l10n.family_confirm_plan),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfirmButton extends StatelessWidget {
  const _ConfirmButton({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return SizedBox(
      height: Spacing.compactButtonHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Spacing.buttonSmallRadius),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [color.primary, color.primary.withValues(alpha: 0.86)],
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: getSemiBoldStyle(
              fontFamily: FontConstant.ibmPlexSansArabic,
              color: color.onPrimary,
              fontSize: FontSize.size17,
            ),
          ),
        ),
      ),
    );
  }
}
