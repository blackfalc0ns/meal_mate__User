import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscriptions/data/monthly_plan_details_fake_data_source.dart';
import 'package:meal_meat_user/features/subscriptions/domain/entities/monthly_plan_details_entity.dart';
import 'package:meal_meat_user/features/subscriptions/presentation/widgets/monthly_plan_filter_strip.dart';
import 'package:meal_meat_user/features/subscriptions/presentation/widgets/monthly_plan_hero_section.dart';
import 'package:meal_meat_user/features/subscriptions/presentation/widgets/monthly_plan_overview_section.dart';
import 'package:meal_meat_user/features/subscriptions/presentation/widgets/monthly_plan_packages_section.dart';
import 'package:meal_meat_user/features/subscriptions/presentation/widgets/monthly_plan_restaurants_section.dart';
import 'package:meal_meat_user/features/subscriptions/presentation/widgets/monthly_plan_subscribe_bar.dart';
import 'package:meal_meat_user/features/subscriptions/presentation/widgets/monthly_plan_view_mode_header.dart';

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

  late final PageController _pageController;
  SubscriptionPlanViewMode _viewMode = SubscriptionPlanViewMode.grid;
  int _selectedFilter = 0;
  late int _currentPage;

  @override
  void initState() {
    super.initState();
    final plans = _dataSource.getPlans();
    _currentPage = widget.initialPage.clamp(0, plans.length - 1);
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final plans = _dataSource.getPlans();
    final currentPlan = plans[_currentPage];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Stack(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 260),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              child: MonthlyPlanHeroBackground(
                key: ValueKey(currentPlan.heroImageAsset),
                imageAsset: currentPlan.heroImageAsset,
                onBack: _pop,
                showBackButton: false,
              ),
            ),
            PageView.builder(
              controller: _pageController,
              itemCount: plans.length,
              onPageChanged: _changePage,
              itemBuilder: (context, index) => _MonthlyPlanDetailsPage(
                plan: plans[index],
                viewMode: _viewMode,
                selectedFilter: _selectedFilter,
                onFilterSelected: _selectFilter,
                onViewModeChanged: _changeViewMode,
              ),
            ),
            Positioned(
              left: Spacing.lg,
              right: Spacing.lg,
              bottom: Spacing.lg,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                child: MonthlyPlanSubscribeBar(
                  key: ValueKey(currentPlan.titleHighlight),
                  plan: currentPlan,
                  onPressed: _subscribe,
                ),
              ),
            ),
            MonthlyPlanHeroBackButton(scale: _heroScale(context), onBack: _pop),
          ],
        ),
      ),
    );
  }

  void _selectFilter(int index) {
    setState(() => _selectedFilter = index);
  }

  void _changePage(int index) {
    setState(() => _currentPage = index);
  }

  void _changeViewMode(SubscriptionPlanViewMode mode) {
    if (_viewMode == mode) return;
    setState(() => _viewMode = mode);
  }

  void _subscribe() {}

  void _pop() {
    Navigator.maybePop(context);
  }

  double _heroScale(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return (width / MonthlyPlanHeroBackground.designWidth).clamp(0.88, 1.0);
  }
}

class _MonthlyPlanDetailsPage extends StatelessWidget {
  const _MonthlyPlanDetailsPage({
    required this.plan,
    required this.viewMode,
    required this.selectedFilter,
    required this.onFilterSelected,
    required this.onViewModeChanged,
  });

  final MonthlyPlanDetailsEntity plan;
  final SubscriptionPlanViewMode viewMode;
  final int selectedFilter;
  final ValueChanged<int> onFilterSelected;
  final ValueChanged<SubscriptionPlanViewMode> onViewModeChanged;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: SizedBox(height: _summaryTopOffset(context))),
        SliverToBoxAdapter(child: MonthlyPlanHeroSummary(plan: plan)),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(Spacing.lg, 8, Spacing.lg, 132),
          sliver: SliverList(
            delegate: SliverChildListDelegate.fixed([
              MonthlyPlanFilterStrip(
                filters: plan.filters,
                selectedIndex: selectedFilter,
                onSelected: onFilterSelected,
              ),
              const SizedBox(height: Spacing.base),
              _MonthlyPlanSelectedContent(
                plan: plan,
                selectedFilter: selectedFilter,
                viewMode: viewMode,
                onViewModeChanged: onViewModeChanged,
              ),
            ]),
          ),
        ),
      ],
    );
  }

  double _summaryTopOffset(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final scale = (width / MonthlyPlanHeroBackground.designWidth).clamp(
      0.88,
      1.0,
    );
    return MonthlyPlanHeroBackground.summaryTop * scale;
  }
}

class _MonthlyPlanSelectedContent extends StatelessWidget {
  const _MonthlyPlanSelectedContent({
    required this.plan,
    required this.selectedFilter,
    required this.viewMode,
    required this.onViewModeChanged,
  });

  final MonthlyPlanDetailsEntity plan;
  final int selectedFilter;
  final SubscriptionPlanViewMode viewMode;
  final ValueChanged<SubscriptionPlanViewMode> onViewModeChanged;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 260),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      child: switch (selectedFilter) {
        0 => MonthlyPlanPackagesSection(
          key: const ValueKey('packages'),
          packages: plan.packageTiers,
        ),
        1 => _RestaurantsViewModeSection(
          key: const ValueKey('restaurants'),
          plan: plan,
          viewMode: viewMode,
          onViewModeChanged: onViewModeChanged,
        ),
        2 => _MealsExploreSection(key: const ValueKey('meals'), plan: plan),
        _ => MonthlyPlanOverviewSection(
          key: const ValueKey('overview'),
          plan: plan,
        ),
      },
    );
  }
}

class _MealsExploreSection extends StatelessWidget {
  const _MealsExploreSection({super.key, required this.plan});

  final MonthlyPlanDetailsEntity plan;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;

    return Column(
      children: [
        Row(
          children: [
            const Icon(
              Icons.explore_rounded,
              size: 18,
              color: AppColors.primary,
            ),
            const SizedBox(width: Spacing.xs),
            Text(
              locale.subscription_details_explore_meals,
              style: getSemiBoldStyle(
                fontFamily: FontConstant.ibmPlexSansArabic,
                fontSize: FontSize.size14,
                color: color.onSurface,
              ),
            ),
            const Spacer(),
            Text(
              locale.subscription_details_meals_count,
              style: getRegularStyle(
                fontFamily: FontConstant.ibmPlexSansArabic,
                fontSize: FontSize.size10,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: Spacing.sm),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.local_fire_department, size: 17),
              const SizedBox(width: Spacing.xs),
              Text(
                locale.subscription_details_popular_meals,
                style: getBoldStyle(
                  fontFamily: FontConstant.ibmPlexSansArabic,
                  fontSize: FontSize.size14,
                  color: color.onSurface,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: Spacing.sm),
        SizedBox(
          height: 194,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            reverse: true,
            itemCount: plan.meals.length,
            separatorBuilder: (_, _) => const SizedBox(width: Spacing.sm),
            itemBuilder: (context, index) {
              return _MealExploreCard(meal: plan.meals[index]);
            },
          ),
        ),
        const SizedBox(height: Spacing.lg),
        _HealthyMealsNote(),
      ],
    );
  }
}

class _MealExploreCard extends StatelessWidget {
  const _MealExploreCard({required this.meal});

  final MonthlyMealEntity meal;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      width: 94,
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFEDEEEF)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipOval(
            child: Image.asset(
              meal.imageAsset,
              width: 72,
              height: 72,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            meal.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: getBoldStyle(
              fontFamily: FontConstant.ibmPlexSansArabic,
              fontSize: FontSize.size10,
              color: color.onSurface,
            ),
          ),
          Text(
            meal.subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: getRegularStyle(
              fontFamily: FontConstant.ibmPlexSansArabic,
              fontSize: FontSize.size8,
              color: AppColors.textSecondary,
            ),
          ),
          const Spacer(),
          Text(
            meal.calories,
            style: getRegularStyle(
              fontFamily: FontConstant.ibmPlexSansArabic,
              fontSize: FontSize.size8,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            meal.protein,
            style: getRegularStyle(
              fontFamily: FontConstant.ibmPlexSansArabic,
              fontSize: FontSize.size8,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _RestaurantsViewModeSection extends StatelessWidget {
  const _RestaurantsViewModeSection({
    super.key,
    required this.plan,
    required this.viewMode,
    required this.onViewModeChanged,
  });

  final MonthlyPlanDetailsEntity plan;
  final SubscriptionPlanViewMode viewMode;
  final ValueChanged<SubscriptionPlanViewMode> onViewModeChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MonthlyPlanViewModeHeader(
          mode: viewMode,
          onModeChanged: onViewModeChanged,
        ),
        const SizedBox(height: Spacing.sm),
        MonthlyPlanRestaurantsSection(
          mode: viewMode,
          restaurants: plan.restaurants,
        ),
      ],
    );
  }
}

class _HealthyMealsNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;

    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F7F3),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.restaurant_rounded,
              size: 18,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  locale.subscription_healthy_balanced,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.ibmPlexSansArabic,
                    fontSize: FontSize.size12,
                    color: color.onSurface,
                  ),
                ),
                Text(
                  locale.subscription_hero_subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getRegularStyle(
                    fontFamily: FontConstant.ibmPlexSansArabic,
                    fontSize: FontSize.size9,
                    color: AppColors.textSecondary,
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
