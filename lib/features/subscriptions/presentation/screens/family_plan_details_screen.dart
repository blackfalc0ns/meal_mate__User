import 'package:flutter/material.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
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
    final plan = _dataSource.getPlan(l10n);

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (Navigator.canPop(context)) Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                  const Spacer(),
                  Text(
                    l10n.family_details_title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 48),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: FamilyPlanHeroCard(plan: plan),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 13, 20, 0),
              child: FamilyMembersStrip(
                members: plan.members,
                onAddTap: () => FamilyAddMemberDialog.show(context),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 13, 20, 0),
              child: FamilyPlanSummaryCard(stats: plan.summaryStats),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: FamilyMealsTable(members: plan.members),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 11, 20, 0),
              child: FamilyPlanPriceCard(plan: plan),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                21,
                20,
                showBottomSpace ? 112 : 24,
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
    return SizedBox(
      height: 39,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          gradient: const LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Color(0xFF006D40), Color(0xFF04B86E)],
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
