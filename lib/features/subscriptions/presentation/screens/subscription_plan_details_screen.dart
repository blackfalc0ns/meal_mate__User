import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscriptions/data/monthly_plan_details_fake_data_source.dart';
import 'package:meal_meat_user/features/subscriptions/domain/entities/monthly_plan_details_entity.dart';
import 'package:meal_meat_user/features/subscriptions/presentation/widgets/monthly_plan_duration_selector.dart';
import 'package:meal_meat_user/features/subscriptions/presentation/widgets/monthly_plan_hero_section.dart';
import 'package:meal_meat_user/features/subscriptions/presentation/widgets/monthly_plan_packages_section.dart';
import 'package:meal_meat_user/features/subscriptions/presentation/widgets/monthly_plan_restaurants_section.dart';
import 'package:meal_meat_user/features/subscriptions/presentation/widgets/monthly_plan_subscribe_bar.dart';

class SubscriptionPlanDetailsScreen extends StatefulWidget {
  const SubscriptionPlanDetailsScreen({super.key, this.initialPage = 0});

  final int initialPage;

  @override
  State<SubscriptionPlanDetailsScreen> createState() =>
      _SubscriptionPlanDetailsScreenState();
}

class _SubscriptionPlanDetailsScreenState
    extends State<SubscriptionPlanDetailsScreen> {
  static const _dataSource = MonthlyPlanDetailsFakeDataSource();

  late int _selectedDurationIndex;
  bool _includesFriday = false;
  bool _isRestaurantsView = false;

  @override
  void initState() {
    super.initState();
    _selectedDurationIndex = widget.initialPage.clamp(0, 2);
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final plans = _dataSource.getPlans();
    final plan = plans[_selectedDurationIndex.clamp(0, plans.length - 1)];

    return Semantics(
      label: locale.nav_subscription,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: color.surface,
          body: Stack(
            children: [
              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: MonthlyPlanHeroSection(
                      plan: plan,
                      imageAsset: Assets.monthlyPlanHero,
                      onBack: _pop,
                    ),
                  ),
                  if (_isRestaurantsView)
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.monthlyPlanContentHorizontalPadding,
                      ),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate.fixed([
                          Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: IconButton(
                              onPressed: () =>
                                  setState(() => _isRestaurantsView = false),
                              icon: Icon(
                                Icons.close_rounded,
                                color: color.onSurface,
                                size: Spacing.iconLg,
                                semanticLabel: locale.go_back,
                              ),
                            ),
                          ),
                          MonthlyPlanRestaurantsSection(
                            mode: SubscriptionPlanViewMode.grid,
                            restaurants: plan.restaurants,
                          ),
                        ]),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.monthlyPlanContentHorizontalPadding,
                      ),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate.fixed([
                          MonthlyPlanDurationSelector(
                            selectedIndex: _selectedDurationIndex,
                            onSelected: (index) =>
                                setState(() => _selectedDurationIndex = index),
                            includesFriday: _includesFriday,
                            onFridayChanged: (value) =>
                                setState(() => _includesFriday = value),
                          ),
                          const SizedBox(height: Spacing.md),
                          MonthlyPlanPackagesSection(
                            packages: plan.packageTiers,
                            onBrowseRestaurants: () =>
                                setState(() => _isRestaurantsView = true),
                          ),
                        ]),
                      ),
                    ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: Spacing.xxxl * 2),
                  ),
                ],
              ),
              PositionedDirectional(
                start: Spacing.monthlyPlanContentHorizontalPadding,
                end: Spacing.monthlyPlanContentHorizontalPadding,
                bottom: Spacing.monthlyPlanContentHorizontalPadding,
                child: MonthlyPlanSubscribeBar(
                  plan: plan,
                  onPressed: () => context.pushNamed(AppRoutes.payment),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _pop() {
    Navigator.maybePop(context);
  }
}
