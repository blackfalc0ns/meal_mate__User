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
import 'package:meal_meat_user/features/monthly_plans/presentation/widgets/monthly_plan_hero_section.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_args.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_args.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/manager/subscription_summary_event.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/manager/subscription_summary_state.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/manager/subscription_summary_view_model.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/widgets/subscription_summary_button_loading_skeleton.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/widgets/subscription_summary_details_card.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/widgets/subscription_summary_details_loading_skeleton.dart';

class SubscriptionSummaryScreen extends StatelessWidget {
  const SubscriptionSummaryScreen({super.key, required this.args});

  final SubscriptionSummaryArgs? args;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final summaryArgs = args;

    if (summaryArgs == null) {
      return Scaffold(
        backgroundColor: color.surface,
        body: EmptyStateWidget(
          title: locale.subscription_summary_title,
          description: locale.subscription_program_subtitle,
          icon: Icons.receipt_long_rounded,
        ),
      );
    }

    return BlocProvider<SubscriptionSummaryViewModel>(
      create: (_) =>
          getIt<SubscriptionSummaryViewModel>()
            ..doIntent(GetSubscriptionSummaryEvent(summaryArgs.request)),
      child:
          BlocBuilder<SubscriptionSummaryViewModel, SubscriptionSummaryState>(
            builder: (context, state) {
              final summary = state.summary;
              final plan = summary == null
                  ? summaryArgs.initialPlan
                  : summary.toPlanDetails(
                      localeName: locale.localeName,
                      dayLabel: locale.subscription_day,
                      primaryColor: color.primary,
                      initialPlan: summaryArgs.initialPlan,
                    );
              final hasSummary = summary != null;

              return Scaffold(
                backgroundColor: color.surface,
                body: Semantics(
                  label: locale.subscription_summary_title,
                  child: Stack(
                    children: [
                      CustomScrollView(
                        physics: const BouncingScrollPhysics(),
                        slivers: [
                          SliverToBoxAdapter(
                            child: Center(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: Spacing.monthlyPlanDesignWidth,
                                ),
                                child: Column(
                                  children: [
                                    MonthlyPlanHeroSection(
                                      plan: plan,
                                      imageAsset: plan.heroImageAsset.isNotEmpty
                                          ? plan.heroImageAsset
                                          : Assets.monthlyPlanHero,
                                      imageUrl: summary?.imageUrl ??
                                          summary?.programImageUrl,
                                      onBack: () => Navigator.maybePop(context),
                                    ),
                                    const SizedBox(height: Spacing.xl),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: Spacing.md,
                                      ),
                                      child: state.isLoading && !hasSummary
                                          ? const SubscriptionSummaryDetailsLoadingSkeleton()
                                          : state.failure != null && !hasSummary
                                              ? ApiErrorWidget(
                                                  exception: state
                                                      .failure!
                                                      .exception,
                                                  onRetry: () => context
                                                      .read<
                                                        SubscriptionSummaryViewModel
                                                      >()
                                                      .doIntent(
                                                        GetSubscriptionSummaryEvent(
                                                          summaryArgs.request,
                                                        ),
                                                      ),
                                                )
                                              : SubscriptionSummaryDetailsCard(
                                                  plan: plan,
                                                  summary: summary,
                                                ),
                                    ),
                                    const SizedBox(
                                      height:
                                          Spacing.monthlyPlanSubscribeHeight +
                                          Spacing.xxxl,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      PositionedDirectional(
                        start: Spacing.monthlyPlanContentHorizontalPadding,
                        end: Spacing.monthlyPlanContentHorizontalPadding,
                        bottom: Spacing.monthlyPlanContentHorizontalPadding,
                        child: state.isLoading && !hasSummary
                            ? const SubscriptionSummaryButtonLoadingSkeleton()
                            : AppSubscriptionButton(
                                price: hasSummary ? plan.price : '',
                                currency: hasSummary ? plan.currency : '',
                                onPressed: hasSummary && summary.canCheckout
                                    ? () => context.pushNamed(
                                        AppRoutes.payment,
                                        arguments: PaymentArgs(
                                          summary: summary,
                                          summaryRequest: summaryArgs.request,
                                          restaurantId:
                                              summary.firstRestaurantId ??
                                              summaryArgs.restaurantId,
                                        ),
                                      )
                                    : null,
                              ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
    );
  }
}
