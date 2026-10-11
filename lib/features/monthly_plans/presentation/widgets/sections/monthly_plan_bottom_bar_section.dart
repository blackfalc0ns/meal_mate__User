import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_subscription_button.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_plan_details_args.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/manager/subscription_plan_state.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/manager/subscription_plan_view_model.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_args.dart';

class MonthlyPlanBottomBarSection extends StatelessWidget {
  const MonthlyPlanBottomBarSection({super.key, required this.detailsArgs});

  final SubscriptionPlanDetailsArgs detailsArgs;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;

    return PositionedDirectional(
      start: Spacing.monthlyPlanContentHorizontalPadding,
      end: Spacing.monthlyPlanContentHorizontalPadding,
      bottom: Spacing.monthlyPlanContentHorizontalPadding,
      child: BlocBuilder<SubscriptionPlanViewModel, SubscriptionPlanState>(
        buildWhen: (previous, current) =>
            previous.browsedTierIndex != current.browsedTierIndex ||
            previous.selectedTier != current.selectedTier ||
            previous.isTiersLoading != current.isTiersLoading ||
            previous.isSelectedDurationValid != current.isSelectedDurationValid,
        builder: (context, state) {
          if (state.isBrowsingRestaurants) {
            return const SizedBox.shrink();
          }

          final selectedTier = state.selectedTier;
          final canSubscribe =
              !state.isTiersLoading &&
              state.isSelectedDurationValid &&
              selectedTier != null &&
              selectedTier.totalPrice != null &&
              selectedTier.effectiveCanSelect;

          return AppSubscriptionButton.next(
            text: locale.subscription_details_subscribe_now,
            isLoading: false,
            onPressed: canSubscribe
                ? () {
                    final request = state.toSummaryRequest(
                      programId: detailsArgs.program.programId,
                      bundleId: detailsArgs.bundle.bundleId,
                    );
                    if (request == null) return;

                    final plan = state.toPlanDetails(
                      program: detailsArgs.program,
                      bundle: detailsArgs.bundle,
                      localeName: locale.localeName,
                      titlePrefix: detailsArgs.program.name(locale.localeName),
                      dayLabel: locale.subscription_day,
                      subscribeLabel: locale.subscription_details_subscribe_now,
                      primaryColor: color.primary,
                    );

                    unawaited(
                      context.pushNamed(
                        AppRoutes.subscriptionSummary,
                        arguments: SubscriptionSummaryArgs(
                          initialPlan: plan,
                          restaurantId: selectedTier.restaurants.isEmpty
                              ? ''
                              : selectedTier.restaurants.first.restaurantId,
                          request: request,
                        ),
                      ),
                    );
                  }
                : null,
          );
        },
      ),
    );
  }
}
