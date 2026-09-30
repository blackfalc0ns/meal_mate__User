import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/errors/error_widgets/empty_state_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/monthly_plan_details_entity.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/manager/subscription_plan_event.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/manager/subscription_plan_state.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/manager/subscription_plan_view_model.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/widgets/monthly_plan_packages_loading_skeleton.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/widgets/monthly_plan_packages_view.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/widgets/monthly_plan_restaurants_view.dart';

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

    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 320),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      child: _isRestaurantsView
          ? MonthlyPlanRestaurantsView(
              key: const ValueKey('restaurants-view'),
              state: state,
              plan: plan,
              onClose: () => setState(() => _isRestaurantsView = false),
              onRetry: _onRetryBrowseRestaurants,
            )
              .animate(key: const ValueKey('restaurants-view-anim'))
              .fadeIn(duration: 320.ms, curve: Curves.easeOut)
              .slideX(
                begin: isRtl ? -0.15 : 0.15,
                end: 0,
                duration: 320.ms,
                curve: Curves.easeOutCubic,
              )
          : MonthlyPlanPackagesView(
              key: const ValueKey('packages-view'),
              state: state,
              plan: plan,
              fridayUnavailableMessage: fridayUnavailableMessage,
              onBrowseRestaurants: _onBrowseRestaurants,
            )
              .animate(key: const ValueKey('packages-view-anim'))
              .fadeIn(duration: 320.ms, curve: Curves.easeOut)
              .slideX(
                begin: isRtl ? 0.15 : -0.15,
                end: 0,
                duration: 320.ms,
                curve: Curves.easeOutCubic,
              ),
    );
  }
}
