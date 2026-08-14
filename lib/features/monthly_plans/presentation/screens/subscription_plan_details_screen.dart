import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/errors/error_widgets/empty_state_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_subscription_button.dart';
import 'package:meal_meat_user/core/widget/custom_warning_widget.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/monthly_plan_details_entity.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_plan_details_args.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_tier_entity.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/manager/subscription_plan_event.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/manager/subscription_plan_state.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/manager/subscription_plan_view_model.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/widgets/monthly_plan_duration_selector.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/widgets/monthly_plan_hero_section.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/widgets/monthly_plan_packages_loading_skeleton.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/widgets/monthly_plan_packages_section.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/widgets/monthly_plan_restaurants_section.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_args.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_request_entity.dart';

class SubscriptionPlanDetailsScreen extends StatefulWidget {
  const SubscriptionPlanDetailsScreen({super.key, this.args});

  final SubscriptionPlanDetailsArgs? args;

  @override
  State<SubscriptionPlanDetailsScreen> createState() =>
      _SubscriptionPlanDetailsScreenState();
}

class _SubscriptionPlanDetailsScreenState
    extends State<SubscriptionPlanDetailsScreen> {
  bool _isRestaurantsView = false;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final args = widget.args;

    if (args == null) {
      return Scaffold(
        backgroundColor: color.surface,
        body: EmptyStateWidget(
          title: locale.subscription_program_title,
          description: locale.subscription_program_subtitle,
          icon: Icons.restaurant_menu_rounded,
        ),
      );
    }

    return BlocProvider<SubscriptionPlanViewModel>(
      create: (_) => getIt<SubscriptionPlanViewModel>()
        ..doIntent(
          GetSubscriptionDurationsEvent(
            programId: args.program.programId,
            bundleId: args.bundle.bundleId,
            includeFriday: false,
          ),
        ),
      child: BlocBuilder<SubscriptionPlanViewModel, SubscriptionPlanState>(
        builder: (context, state) {
          final plan = _buildPlan(context, state);
          final selectedTier = state.selectedTier;
          final canSubscribe =
              state.isSelectedDurationValid &&
              selectedTier != null &&
              selectedTier.totalPrice != null;

          return Scaffold(
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
                        durationSelector: MonthlyPlanDurationSelector(
                          selectedIndex: state.selectedDurationIndex,
                          onSelected: (index) => context
                              .read<SubscriptionPlanViewModel>()
                              .doIntent(
                                SelectSubscriptionDurationEvent(
                                  programId: args.program.programId,
                                  bundleId: args.bundle.bundleId,
                                  durationIndex: index,
                                ),
                              ),
                          includesFriday: state.includeFriday,
                          onFridayChanged: (value) => context
                              .read<SubscriptionPlanViewModel>()
                              .doIntent(
                                ToggleSubscriptionFridayEvent(
                                  programId: args.program.programId,
                                  bundleId: args.bundle.bundleId,
                                  includeFriday: value,
                                ),
                              ),
                          customDurationDays: state.customDurationDays,
                          onCustomDurationChanged: (value) => context
                              .read<SubscriptionPlanViewModel>()
                              .doIntent(
                                UpdateCustomSubscriptionDurationEvent(
                                  programId: args.program.programId,
                                  bundleId: args.bundle.bundleId,
                                  durationDays: value,
                                ),
                              ),
                          durations: state.durations,
                          isFridayEnabled: state.canToggleFriday,
                          isLoading:
                              state.isDurationsLoading &&
                              state.durations.isEmpty,
                        ),
                        onBack: _pop,
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.screenH,
                        vertical: Spacing.screenV,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: _buildContent(context, state, plan),
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
                    price: canSubscribe
                        ? _formatPrice(selectedTier.totalPrice!)
                        : '',
                    currency: canSubscribe ? selectedTier.currencyCode : '',
                    onPressed: canSubscribe
                        ? () => _openSubscriptionSummary(context, state, plan)
                        : null,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    SubscriptionPlanState state,
    MonthlyPlanDetailsEntity plan,
  ) {
    final color = context.colorScheme;
    final locale = context.localization;
    final fridayUnavailableMessage = state.fridayUnavailableMessage(
      locale.localeName,
    );

    if (state.isDurationsLoading && state.durations.isEmpty) {
      return const MonthlyPlanPackagesLoadingSkeleton();
    }

    if (state.failure != null && state.durations.isEmpty) {
      return ApiErrorWidget(
        exception: state.failure!.exception,
        onRetry: () {
          final args = widget.args;
          if (args == null) return;
          context.read<SubscriptionPlanViewModel>().doIntent(
            GetSubscriptionDurationsEvent(
              programId: args.program.programId,
              bundleId: args.bundle.bundleId,
              includeFriday: state.includeFriday,
            ),
          );
        },
      );
    }

    if (state.isSuccess && state.durations.isEmpty) {
      return EmptyStateWidget(
        title: locale.subscription_duration_title,
        description: locale.subscription_packages_empty_description,
        icon: Icons.calendar_month_rounded,
      );
    }

    if (state.isTiersLoading && state.tiers.isEmpty) {
      return const MonthlyPlanPackagesLoadingSkeleton();
    }

    if (state.failure != null && state.tiers.isEmpty) {
      return ApiErrorWidget(
        exception: state.failure!.exception,
        onRetry: () {
          final args = widget.args;
          final durationIndex = state.selectedDurationIndex;
          if (args == null) return;
          context.read<SubscriptionPlanViewModel>().doIntent(
            durationIndex == null
                ? GetSubscriptionDurationsEvent(
                    programId: args.program.programId,
                    bundleId: args.bundle.bundleId,
                    includeFriday: state.includeFriday,
                  )
                : SelectSubscriptionDurationEvent(
                    programId: args.program.programId,
                    bundleId: args.bundle.bundleId,
                    durationIndex: durationIndex,
                  ),
          );
        },
      );
    }

    return AnimatedSwitcher(
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
                  alignment: AlignmentDirectional.centerStart,
                  child: IconButton(
                    onPressed: () => setState(() => _isRestaurantsView = false),
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
                if (fridayUnavailableMessage.isNotEmpty) ...[
                  CustomWarningWidget(
                    icon: Icons.warning_rounded,
                    message: fridayUnavailableMessage,
                    isWarning: true,
                    maxMessageLines: 3,
                  ),
                  const SizedBox(height: Spacing.md),
                ],
                MonthlyPlanPackagesSection(
                  packages: plan.packageTiers,
                  selectedIndex: state.selectedTierIndex,
                  onSelected: (index) => context
                      .read<SubscriptionPlanViewModel>()
                      .doIntent(SelectSubscriptionTierEvent(index)),
                  onBrowseRestaurants: () =>
                      setState(() => _isRestaurantsView = true),
                ),
              ],
            ),
    );
  }

  void _openSubscriptionSummary(
    BuildContext context,
    SubscriptionPlanState state,
    MonthlyPlanDetailsEntity plan,
  ) {
    final args = widget.args!;
    final durationDays = state.selectedDurationDays;
    final selectedTier = state.selectedTier;

    if (durationDays == null || selectedTier == null) return;

    context.pushNamed(
      AppRoutes.subscriptionSummary,
      arguments: SubscriptionSummaryArgs(
        initialPlan: plan,
        request: SubscriptionSummaryRequestEntity(
          includeFriday: state.includeFriday,
          durationDays: durationDays,
          tier: selectedTier.tier,
          bundleId: args.bundle.bundleId,
          programId: args.program.programId,
        ),
      ),
    );
  }

  MonthlyPlanDetailsEntity _buildPlan(
    BuildContext context,
    SubscriptionPlanState state,
  ) {
    final locale = context.localization;
    final color = context.colorScheme;
    final args = widget.args!;
    final duration = state.selectedDuration;
    final selectedTier = state.selectedTier;

    return MonthlyPlanDetailsEntity(
      titlePrefix: locale.subscription_month_package_prefix,
      titleHighlight: locale.subscription_month_package_highlight,
      duration: duration == null
          ? ''
          : state.selectedDurationDays == null
          ? duration.name(locale.localeName)
          : '${state.selectedDurationDays} ${locale.subscription_day}',
      mealsPerDay: args.bundle.description(locale.localeName),
      discountLabel: selectedTier?.name(locale.localeName) ?? '',
      subscribeLabel: locale.subscription_details_subscribe_now,
      price: selectedTier?.totalPrice == null
          ? ''
          : _formatPrice(selectedTier!.totalPrice!),
      currency: selectedTier?.currencyCode ?? '',
      heroImageAsset: Assets.monthlyPlanHero,
      description: args.program.description(locale.localeName),
      features: const [],
      packageTiers: state.tiers
          .map((tier) => tier.toPackageTier(locale.localeName))
          .toList(),
      filters: const [],
      restaurants: selectedTier?.toRestaurants(color.primary) ?? const [],
      meals: const [],
    );
  }

  String _formatPrice(double price) {
    final fixed = price.toStringAsFixed(3);
    return fixed.replaceFirst(RegExp(r'\.?0+$'), '');
  }

  void _pop() {
    Navigator.maybePop(context);
  }
}

extension on SubscriptionTierEntity {
  MonthlyPackageTierEntity toPackageTier(String localeName) {
    return MonthlyPackageTierEntity(
      title: name(localeName),
      subtitle: description(localeName),
      price: totalPrice == null ? '' : totalPrice!.toStringAsFixed(3),
      currency: currencyCode,
      period: '',
      bullets: const [],
      iconName: switch (tier.toLowerCase()) {
        'elite' => 'crown',
        'platinum' => 'star',
        _ => 'leaf',
      },
      isPopular: isRecommended,
    );
  }

  List<MonthlyRestaurantPlanEntity> toRestaurants(Color brandColor) {
    return restaurants
        .map(
          (restaurant) => MonthlyRestaurantPlanEntity(
            name: restaurant.restaurantId,
            subtitle: '',
            meals: '',
            rating: '',
            brandColor: brandColor,
            initials: restaurant.restaurantId.isEmpty
                ? null
                : restaurant.restaurantId.substring(0, 2).toUpperCase(),
          ),
        )
        .toList();
  }
}
