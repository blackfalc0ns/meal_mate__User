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
import 'package:meal_meat_user/features/monthly_plans/domain/entities/monthly_plan_details_entity.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/widgets/monthly_plan_hero_section.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_args.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_args.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_entity.dart';
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
                  : _buildSummaryPlan(
                      context,
                      summary,
                      summaryArgs.initialPlan,
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
                                      imageAsset: Assets.monthlyPlanHero,
                                      onBack: () => Navigator.maybePop(context),
                                    ),
                                    const SizedBox(height: Spacing.xl),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: Spacing.md,
                                      ),
                                      child: _buildDetailsContent(
                                        context,
                                        state,
                                        summaryArgs,
                                        plan,
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
                                onPressed: hasSummary
                                    ? () => context.pushNamed(
                                        AppRoutes.payment,
                                        arguments: PaymentArgs(
                                          summary: summary,
                                          summaryRequest: summaryArgs.request,
                                          restaurantId:
                                              summary.restaurantId ??
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

  Widget _buildDetailsContent(
    BuildContext context,
    SubscriptionSummaryState state,
    SubscriptionSummaryArgs summaryArgs,
    MonthlyPlanDetailsEntity plan,
  ) {
    if (state.isLoading && state.summary == null) {
      return const SubscriptionSummaryDetailsLoadingSkeleton();
    }

    if (state.failure != null && state.summary == null) {
      return ApiErrorWidget(
        exception: state.failure!.exception,
        onRetry: () => context.read<SubscriptionSummaryViewModel>().doIntent(
          GetSubscriptionSummaryEvent(summaryArgs.request),
        ),
      );
    }

    return SubscriptionSummaryDetailsCard(plan: plan, summary: state.summary);
  }

  MonthlyPlanDetailsEntity _buildSummaryPlan(
    BuildContext context,
    SubscriptionSummaryEntity summary,
    MonthlyPlanDetailsEntity initialPlan,
  ) {
    final locale = context.localization;

    return MonthlyPlanDetailsEntity(
      titlePrefix: initialPlan.titlePrefix,
      titleHighlight: initialPlan.titleHighlight,
      duration: '${summary.durationDays} ${locale.subscription_day}',
      mealsPerDay: initialPlan.mealsPerDay,
      discountLabel: summary.tierName(locale.localeName),
      subscribeLabel: initialPlan.subscribeLabel,
      price: _formatPrice(summary.finalPrice),
      currency: summary.currencyCode,
      heroImageAsset: initialPlan.heroImageAsset,
      description: initialPlan.description,
      features: initialPlan.features,
      packageTiers: [
        MonthlyPackageTierEntity(
          title: summary.bundleName(locale.localeName),
          subtitle: summary.programName(locale.localeName),
          price: _formatPrice(summary.finalPrice),
          currency: summary.currencyCode,
          period: '',
          bullets: const [],
          iconName: switch (summary.tier.toLowerCase()) {
            'elite' => 'crown',
            'platinum' => 'star',
            _ => 'leaf',
          },
          logoUrl: _selectedTierLogoUrl(initialPlan),
          restaurantCount: summary.restaurantCount,
          restaurantLogoUrls: const [],
        ),
      ],
      filters: initialPlan.filters,
      restaurants: initialPlan.restaurants,
      meals: initialPlan.meals,
    );
  }

  String _formatPrice(double price) {
    final fixed = price.toStringAsFixed(3);
    return fixed.replaceFirst(RegExp(r'\.?0+$'), '');
  }

  String? _selectedTierLogoUrl(MonthlyPlanDetailsEntity initialPlan) {
    for (final tier in initialPlan.packageTiers) {
      if (tier.title == initialPlan.discountLabel) return tier.logoUrl;
    }

    return null;
  }
}
