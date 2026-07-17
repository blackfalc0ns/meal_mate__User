import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_subscription_button.dart';
import 'package:meal_meat_user/features/subscriptions/data/monthly_plan_details_fake_data_source.dart';
import 'package:meal_meat_user/features/subscriptions/domain/entities/monthly_plan_details_entity.dart';
import 'package:meal_meat_user/features/subscriptions/presentation/widgets/monthly_plan_duration_selector.dart';
import 'package:meal_meat_user/features/subscriptions/presentation/widgets/monthly_plan_hero_section.dart';
import 'package:meal_meat_user/features/subscriptions/presentation/widgets/monthly_plan_packages_section.dart';
import 'package:meal_meat_user/features/subscriptions/presentation/widgets/monthly_plan_restaurants_section.dart';

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
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.monthlyPlanContentHorizontalPadding,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: Transform.translate(
                        offset: const Offset(0, -Spacing.xxxl - Spacing.sm),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 360),
                          reverseDuration: const Duration(milliseconds: 220),
                          switchInCurve: Curves.easeOutCubic,
                          switchOutCurve: Curves.easeInCubic,
                          transitionBuilder: (child, animation) {
                            final slideAnimation = Tween<Offset>(
                              begin: const Offset(0, 0.08),
                              end: Offset.zero,
                            ).animate(animation);

                            return FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: slideAnimation,
                                child: RepaintBoundary(child: child),
                              ),
                            );
                          },
                          child: _isRestaurantsView
                              ? Column(
                                  key: const ValueKey('restaurants-view'),
                                  children: [
                                    Align(
                                      alignment:
                                          AlignmentDirectional.centerStart,
                                      child: IconButton(
                                        onPressed: () => setState(
                                          () => _isRestaurantsView = false,
                                        ),
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
                                  ],
                                )
                              : Column(
                                  key: const ValueKey('packages-view'),
                                  children: [
                                    MonthlyPlanDurationSelector(
                                      selectedIndex: _selectedDurationIndex,
                                      onSelected: (index) => setState(
                                        () => _selectedDurationIndex = index,
                                      ),
                                      includesFriday: _includesFriday,
                                      onFridayChanged: (value) => setState(
                                        () => _includesFriday = value,
                                      ),
                                    ),
                                    const SizedBox(height: Spacing.md),
                                    MonthlyPlanPackagesSection(
                                      packages: plan.packageTiers,
                                      onBrowseRestaurants: () => setState(
                                        () => _isRestaurantsView = true,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
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
                child: AppSubscriptionButton(
                  price: plan.price,
                  currency: plan.currency,
                  onPressed: () => context.pushNamed(
                    AppRoutes.subscriptionSummary,
                    arguments: plan,
                  ),
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
