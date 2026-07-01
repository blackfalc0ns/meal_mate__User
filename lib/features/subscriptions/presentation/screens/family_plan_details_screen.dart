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
          SliverToBoxAdapter(child: FamilyPlanHeroCard(plan: plan)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                Spacing.lg,
                Spacing.md,
                Spacing.lg,
                0,
              ),
              child: FamilyMembersStrip(
                members: plan.members,
                onAddTap: () => FamilyAddMemberDialog.show(context),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                Spacing.lg,
                Spacing.md,
                Spacing.lg,
                0,
              ),
              child: FamilyPlanSummaryCard(stats: plan.summaryStats),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                Spacing.lg,
                Spacing.sm,
                Spacing.lg,
                0,
              ),
              child: FamilyMealsTable(members: plan.members),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                Spacing.lg,
                Spacing.md,
                Spacing.lg,
                0,
              ),
              child: FamilyPlanPriceCard(plan: plan),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                Spacing.lg,
                Spacing.lg,
                Spacing.lg,
                showBottomSpace ? 112 : Spacing.xl,
              ),
              child: _ConfirmButton(label: l10n.family_confirm_plan),
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
