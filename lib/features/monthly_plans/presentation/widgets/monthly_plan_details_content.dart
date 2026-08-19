import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/errors/error_widgets/empty_state_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_warning_widget.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/monthly_plan_details_entity.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/manager/subscription_plan_event.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/manager/subscription_plan_state.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/manager/subscription_plan_view_model.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/widgets/monthly_plan_packages_loading_skeleton.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/widgets/monthly_plan_packages_section.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/widgets/monthly_plan_restaurants_loading_skeleton.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/widgets/monthly_plan_restaurants_section.dart';

class MonthlyPlanDetailsContent extends StatefulWidget {
  const MonthlyPlanDetailsContent({
    super.key,
    required this.state,
    required this.plan,
    required this.programId,
    required this.bundleId,
  });

  final SubscriptionPlanState state;
  final MonthlyPlanDetailsEntity plan;
  final String programId;
  final String bundleId;

  @override
  State<MonthlyPlanDetailsContent> createState() =>
      _MonthlyPlanDetailsContentState();
}

class _MonthlyPlanDetailsContentState extends State<MonthlyPlanDetailsContent> {
  bool _isRestaurantsView = false;

  void _onBrowseRestaurants(int tierIndex) {
    context.read<SubscriptionPlanViewModel>()
      ..doIntent(SelectSubscriptionTierEvent(tierIndex))
      ..doIntent(
        BrowseSubscriptionTierRestaurantsEvent(
          programId: widget.programId,
          bundleId: widget.bundleId,
          tierIndex: tierIndex,
        ),
      );
    setState(() => _isRestaurantsView = true);
  }

  void _onRetryDurations() {
    context.read<SubscriptionPlanViewModel>().doIntent(
      GetSubscriptionDurationsEvent(
        programId: widget.programId,
        bundleId: widget.bundleId,
        includeFriday: widget.state.includeFriday,
      ),
    );
  }

  void _onRetryTiers() {
    final durationIndex = widget.state.selectedDurationIndex;
    context.read<SubscriptionPlanViewModel>().doIntent(
      durationIndex == null
          ? GetSubscriptionDurationsEvent(
              programId: widget.programId,
              bundleId: widget.bundleId,
              includeFriday: widget.state.includeFriday,
            )
          : SelectSubscriptionDurationEvent(
              programId: widget.programId,
              bundleId: widget.bundleId,
              durationIndex: durationIndex,
            ),
    );
  }

  void _onRetryBrowseRestaurants() {
    final browsedTierIndex = widget.state.browsedTierIndex;
    if (browsedTierIndex == null) return;
    context.read<SubscriptionPlanViewModel>().doIntent(
      BrowseSubscriptionTierRestaurantsEvent(
        programId: widget.programId,
        bundleId: widget.bundleId,
        tierIndex: browsedTierIndex,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final state = widget.state;
    final plan = widget.plan;

    if (state.isDurationsLoading && state.durations.isEmpty) {
      return const MonthlyPlanPackagesLoadingSkeleton();
    }

    if (state.failure != null && state.durations.isEmpty) {
      return ApiErrorWidget(
        exception: state.failure!.exception,
        onRetry: _onRetryDurations,
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
        onRetry: _onRetryTiers,
      );
    }

    final fridayUnavailableMessage = state.fridayUnavailableMessage(
      locale.localeName,
    );

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
          ? _MonthlyPlanRestaurantsView(
              key: const ValueKey('restaurants-view'),
              state: state,
              plan: plan,
              onClose: () => setState(() => _isRestaurantsView = false),
              onRetry: _onRetryBrowseRestaurants,
            )
          : _MonthlyPlanPackagesView(
              key: const ValueKey('packages-view'),
              state: state,
              plan: plan,
              fridayUnavailableMessage: fridayUnavailableMessage,
              onBrowseRestaurants: _onBrowseRestaurants,
            ),
    );
  }
}

class _MonthlyPlanPackagesView extends StatelessWidget {
  const _MonthlyPlanPackagesView({
    super.key,
    required this.state,
    required this.plan,
    required this.fridayUnavailableMessage,
    required this.onBrowseRestaurants,
  });

  final SubscriptionPlanState state;
  final MonthlyPlanDetailsEntity plan;
  final String fridayUnavailableMessage;
  final ValueChanged<int> onBrowseRestaurants;

  @override
  Widget build(BuildContext context) {
    return Column(
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
          onBrowseRestaurants: onBrowseRestaurants,
        ),
      ],
    );
  }
}

class _MonthlyPlanRestaurantsView extends StatelessWidget {
  const _MonthlyPlanRestaurantsView({
    super.key,
    required this.state,
    required this.plan,
    required this.onClose,
    required this.onRetry,
  });

  final SubscriptionPlanState state;
  final MonthlyPlanDetailsEntity plan;
  final VoidCallback onClose;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Column(
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: IconButton(
            onPressed: onClose,
            icon: Icon(
              Icons.close_rounded,
              color: color.onSurface,
              size: Spacing.iconLg,
              semanticLabel: locale.go_back,
            ),
          ),
        ),
        if (state.isBrowseRestaurantsLoading && state.browseRestaurants.isEmpty)
          const MonthlyPlanRestaurantsLoadingSkeleton()
        else if (state.browseRestaurantsFailure != null &&
            state.browseRestaurants.isEmpty)
          ApiErrorWidget(
            exception: state.browseRestaurantsFailure!.exception,
            onRetry: onRetry,
          )
        else if (state.browseRestaurants.isEmpty)
          EmptyStateWidget(
            title: locale.subscription_restaurant_categories_title,
            description: locale.subscription_restaurant_categories_subtitle,
            icon: Icons.restaurant_rounded,
          )
        else
          MonthlyPlanRestaurantsSection(
            mode: SubscriptionPlanViewMode.grid,
            restaurants: plan.restaurants,
          ),
      ],
    );
  }
}
