import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_widgets/empty_state_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/network/failuer_mapper.dart';
import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/core/widget/app_subscription_button.dart';
import 'package:meal_meat_user/core/widget/subscription_duration/subscription_duration_selector.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/monthly_plan_details_entity.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_plan_details_args.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/manager/subscription_plan_event.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/manager/subscription_plan_state.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/manager/subscription_plan_view_model.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/widgets/monthly_plan_details_content.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/widgets/monthly_plan_hero_section.dart';
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

    final staticHeroPlan = MonthlyPlanDetailsEntity(
      titlePrefix: locale.drawer_month_package,
      titleHighlight: detailsArgs.program.name(locale.localeName),
      duration: '',
      mealsPerDay: detailsArgs.bundle.description(locale.localeName),
      discountLabel: '',
      subscribeLabel: locale.subscription_details_subscribe_now,
      price: '',
      currency: '',
      heroImageAsset: Assets.monthlyPlanHero,
      description: detailsArgs.program.description(locale.localeName),
      features: const [],
      packageTiers: const [],
      filters: const [],
      restaurants: const [],
      meals: const [],
    );

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
                current.hasFridayUnavailableFailure),
        listener: (context, state) {
          final failure = state.failure;
          if (state.hasFridayUnavailableFailure) {
            unawaited(_showFailureDialog(context, failure!));
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
            titlePrefix: locale.drawer_month_package,
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
        child: Scaffold(
          backgroundColor: color.surface,
          body: Stack(
            children: [
              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: MonthlyPlanHeroSection(
                      plan: staticHeroPlan,
                      imageAsset: Assets.monthlyPlanHero,
                      imageUrl: null,
                      durationSelector:
                          BlocBuilder<
                            SubscriptionPlanViewModel,
                            SubscriptionPlanState
                          >(
                            buildWhen: (previous, current) =>
                                previous.durations != current.durations ||
                                previous.selectedDurationIndex !=
                                    current.selectedDurationIndex ||
                                previous.includeFriday !=
                                    current.includeFriday ||
                                previous.customDurationDays !=
                                    current.customDurationDays ||
                                previous.canToggleFriday !=
                                    current.canToggleFriday ||
                                previous.isDurationsLoading !=
                                    current.isDurationsLoading,
                            builder: (context, state) {
                              return SubscriptionDurationSelector(
                                selectedIndex: state.selectedDurationIndex,
                                onSelected: (index) => context
                                    .read<SubscriptionPlanViewModel>()
                                    .doIntent(
                                      SelectSubscriptionDurationEvent(
                                        programId:
                                            detailsArgs.program.programId,
                                        bundleId: detailsArgs.bundle.bundleId,
                                        durationIndex: index,
                                      ),
                                    ),
                                includesFriday: state.includeFriday,
                                onFridayChanged: (value) => context
                                    .read<SubscriptionPlanViewModel>()
                                    .doIntent(
                                      ToggleSubscriptionFridayEvent(
                                        programId:
                                            detailsArgs.program.programId,
                                        bundleId: detailsArgs.bundle.bundleId,
                                        includeFriday: value,
                                      ),
                                    ),
                                customDurationDays: state.customDurationDays,
                                onCustomDurationChanged: (value) => context
                                    .read<SubscriptionPlanViewModel>()
                                    .doIntent(
                                      UpdateCustomSubscriptionDurationEvent(
                                        programId:
                                            detailsArgs.program.programId,
                                        bundleId: detailsArgs.bundle.bundleId,
                                        durationDays: value,
                                      ),
                                    ),
                                durations: state.durations,
                                isFridayEnabled: state.canToggleFriday,
                                isLoading:
                                    state.isDurationsLoading &&
                                    state.durations.isEmpty,
                              );
                            },
                          ),
                      onBack: () => Navigator.maybePop(context),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.screenH,
                    ).copyWith(top: Spacing.xs, bottom: Spacing.screenV),
                    sliver: SliverToBoxAdapter(
                      child:
                          BlocBuilder<
                            SubscriptionPlanViewModel,
                            SubscriptionPlanState
                          >(
                            buildWhen: (previous, current) =>
                                previous.tiers != current.tiers ||
                                previous.selectedTierIndex !=
                                    current.selectedTierIndex ||
                                previous.browseRestaurants !=
                                    current.browseRestaurants ||
                                previous.browsedTierIndex !=
                                    current.browsedTierIndex ||
                                previous.isTiersLoading !=
                                    current.isTiersLoading ||
                                previous.isBrowseRestaurantsLoading !=
                                    current.isBrowseRestaurantsLoading ||
                                previous.failure != current.failure ||
                                previous.browseRestaurantsFailure !=
                                    current.browseRestaurantsFailure ||
                                previous.includeFriday != current.includeFriday,
                            builder: (context, state) {
                              final plan = state.toPlanDetails(
                                program: detailsArgs.program,
                                bundle: detailsArgs.bundle,
                                localeName: locale.localeName,
                                titlePrefix: locale.drawer_month_package,
                                dayLabel: locale.subscription_day,
                                subscribeLabel:
                                    locale.subscription_details_subscribe_now,
                                primaryColor: color.primary,
                              );

                              return MonthlyPlanDetailsContent(
                                state: state,
                                plan: plan,
                                programId: detailsArgs.program.programId,
                                bundleId: detailsArgs.bundle.bundleId,
                              );
                            },
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
                child:
                    BlocBuilder<
                      SubscriptionPlanViewModel,
                      SubscriptionPlanState
                    >(
                      buildWhen: (previous, current) =>
                          previous.selectedTier != current.selectedTier ||
                          previous.isTiersLoading != current.isTiersLoading ||
                          previous.isSelectedDurationValid !=
                              current.isSelectedDurationValid ||
                          previous.isReadinessLoading !=
                              current.isReadinessLoading,
                      builder: (context, state) {
                        final selectedTier = state.selectedTier;
                        final canSubscribe =
                            !state.isTiersLoading &&
                            state.isSelectedDurationValid &&
                            selectedTier != null &&
                            selectedTier.totalPrice != null;

                        return AppSubscriptionButton.next(
                          text: locale.subscription_details_subscribe_now,
                          isLoading: state.isReadinessLoading,
                          onPressed: canSubscribe
                              ? () {
                                  final request = state.toSummaryRequest(
                                    programId: detailsArgs.program.programId,
                                    bundleId: detailsArgs.bundle.bundleId,
                                  );
                                  if (request == null) return;
                                  context
                                      .read<SubscriptionPlanViewModel>()
                                      .doIntent(
                                        CheckSubscriptionReadinessEvent(
                                          programId:
                                              detailsArgs.program.programId,
                                          bundleId: detailsArgs.bundle.bundleId,
                                          tier: request.tier,
                                          durationDays: request.durationDays,
                                          includeFriday: request.includeFriday,
                                        ),
                                      );
                                }
                              : null,
                        );
                      },
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showFailureDialog(BuildContext context, Failure failure) {
    final message = mapFailureMessage(context, failure.errorMessage);

    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(MaterialLocalizations.of(context).okButtonLabel),
            ),
          ],
        );
      },
    );
  }
}
