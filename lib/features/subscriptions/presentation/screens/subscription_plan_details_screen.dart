import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/features/subscriptions/data/monthly_plan_details_fake_data_source.dart';
import 'package:meal_meat_user/features/subscriptions/domain/entities/monthly_plan_details_entity.dart';
import 'package:meal_meat_user/features/subscriptions/presentation/widgets/monthly_plan_filter_strip.dart';
import 'package:meal_meat_user/features/subscriptions/presentation/widgets/monthly_plan_hero_section.dart';
import 'package:meal_meat_user/features/subscriptions/presentation/widgets/monthly_plan_restaurants_section.dart';
import 'package:meal_meat_user/features/subscriptions/presentation/widgets/monthly_plan_subscribe_bar.dart';
import 'package:meal_meat_user/features/subscriptions/presentation/widgets/monthly_plan_summary_section.dart';
import 'package:meal_meat_user/features/subscriptions/presentation/widgets/monthly_plan_view_mode_header.dart';

class SubscriptionPlanDetailsScreen extends StatefulWidget {
  const SubscriptionPlanDetailsScreen({super.key});

  @override
  State<SubscriptionPlanDetailsScreen> createState() =>
      _SubscriptionPlanDetailsScreenState();
}

class _SubscriptionPlanDetailsScreenState
    extends State<SubscriptionPlanDetailsScreen> {
  static const _dataSource = MonthlyPlanDetailsFakeDataSource();

  SubscriptionPlanViewMode _viewMode = SubscriptionPlanViewMode.grid;
  int _selectedFilter = 1;

  @override
  Widget build(BuildContext context) {
    final plan = _dataSource.getPlanDetails();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: MonthlyPlanHeroSection(onBack: _pop)),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    Spacing.lg,
                    0,
                    Spacing.lg,
                    104,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate.fixed([
                      MonthlyPlanSummarySection(plan: plan),
                      const SizedBox(height: Spacing.md),
                      MonthlyPlanFilterStrip(
                        filters: plan.filters,
                        selectedIndex: _selectedFilter,
                        onSelected: _selectFilter,
                      ),
                      const SizedBox(height: Spacing.lg),
                      MonthlyPlanViewModeHeader(
                        mode: _viewMode,
                        onModeChanged: _changeViewMode,
                      ),
                      const SizedBox(height: Spacing.sm),
                      MonthlyPlanRestaurantsSection(
                        mode: _viewMode,
                        restaurants: plan.restaurants,
                      ),
                    ]),
                  ),
                ),
              ],
            ),
            Positioned(
              left: Spacing.lg,
              right: Spacing.lg,
              bottom: Spacing.lg,
              child: MonthlyPlanSubscribeBar(plan: plan, onPressed: _subscribe),
            ),
          ],
        ),
      ),
    );
  }

  void _selectFilter(int index) {
    setState(() => _selectedFilter = index);
  }

  void _changeViewMode(SubscriptionPlanViewMode mode) {
    if (_viewMode == mode) return;
    setState(() => _viewMode = mode);
  }

  void _subscribe() {}

  void _pop() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }
}
