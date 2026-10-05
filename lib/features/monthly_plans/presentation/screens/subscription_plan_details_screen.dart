import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_message_presenter.dart';
import 'package:meal_meat_user/core/errors/error_widgets/empty_state_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_plan_details_args.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/manager/subscription_plan_event.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/manager/subscription_plan_state.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/manager/subscription_plan_view_model.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/widgets/sections/monthly_plan_bottom_bar_section.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/widgets/sections/monthly_plan_content_sliver_section.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/widgets/sections/monthly_plan_hero_sliver_section.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_args.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/widgets/subscription_readiness_bottom_sheet.dart';

class SubscriptionPlanDetailsScreen extends StatelessWidget {
  const SubscriptionPlanDetailsScreen({super.key, this.args});

  final SubscriptionPlanDetailsArgs? args;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final detailsArgs = args;

    if (detailsArgs == null) {
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
            programId: detailsArgs.program.programId,
            bundleId: detailsArgs.bundle.bundleId,
            includeFriday: false,
          ),
        ),
      child: BlocListener<SubscriptionPlanViewModel, SubscriptionPlanState>(
        listenWhen: (previous, current) =>
            previous.readiness != current.readiness ||
            (previous.failure != current.failure &&
                current.hasFridayUnavailableFailure) ||
            (previous.readinessFailure != current.readinessFailure &&
                current.readinessFailure != null),
        listener: (context, state) {
          if (state.hasFridayUnavailableFailure && state.failure != null) {
            CustomSnackbar.showError(
              context: context,
              message: ErrorMessagePresenter.fromFailure(
                context,
                state.failure!,
              ),
            );
            return;
          }

          if (state.readinessFailure != null) {
            CustomSnackbar.showError(
              context: context,
              message: ErrorMessagePresenter.fromFailure(
                context,
                state.readinessFailure!,
              ),
            );
            return;
          }

          final readiness = state.readiness;
          if (readiness == null) return;

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

          if (readiness.shouldOpenSummary &&
              !readiness.hasRestaurantCoverageBlock) {
            final selectedTier = state.selectedTier;
            unawaited(
              context.pushNamed(
                AppRoutes.subscriptionSummary,
                arguments: SubscriptionSummaryArgs(
                  initialPlan: plan,
                  restaurantId:
                      selectedTier == null || selectedTier.restaurants.isEmpty
                      ? ''
                      : selectedTier.restaurants.first.restaurantId,
                  request: request,
                ),
              ),
            );
            return;
          }

          unawaited(
            SubscriptionReadinessBottomSheet.show(
              context: context,
              readiness: readiness,
              request: request,
              onRequirementFulfilled: () =>
                  context.read<SubscriptionPlanViewModel>().doIntent(
                    CheckSubscriptionReadinessEvent(
                      programId: request.programId,
                      bundleId: request.bundleId,
                      tier: request.tier,
                      durationDays: request.durationDays,
                      includeFriday: request.includeFriday,
                    ),
                  ),
            ),
          );
        },
        child:
            BlocSelector<
              SubscriptionPlanViewModel,
              SubscriptionPlanState,
              bool
            >(
              selector: (state) => state.isBrowsingRestaurants,
              builder: (context, isBrowsing) {
                return PopScope(
                  canPop: !isBrowsing,
                  onPopInvokedWithResult: (didPop, _) {
                    if (didPop) return;
                    context.read<SubscriptionPlanViewModel>().doIntent(
                      const CloseSubscriptionTierRestaurantsEvent(),
                    );
                  },
                  child: Scaffold(
                    backgroundColor: color.surface,
                    body: Stack(
                      children: [
                        NotificationListener<ScrollNotification>(
                          onNotification: (notification) {
                            if (notification.metrics.pixels >=
                                notification.metrics.maxScrollExtent - 240) {
                              final vm =
                                  context.read<SubscriptionPlanViewModel>();
                              if (vm.state.isBrowsingRestaurants) {
                                vm.doIntent(
                                  const LoadMoreSubscriptionTierRestaurantsEvent(),
                                );
                              }
                            }
                            return false;
                          },
                          child: CustomScrollView(
                            physics: const BouncingScrollPhysics(),
                            slivers: [
                              MonthlyPlanHeroSliverSection(
                                detailsArgs: detailsArgs,
                              ),
                              MonthlyPlanContentSliverSection(
                                detailsArgs: detailsArgs,
                              ),
                              const SliverToBoxAdapter(
                                child: SizedBox(height: Spacing.xxxl * 2),
                              ),
                            ],
                          ),
                        ),

                        MonthlyPlanBottomBarSection(detailsArgs: detailsArgs),
                      ],
                    ),
                  ),
                );
              },
            ),
      ),
    );
  }
}
