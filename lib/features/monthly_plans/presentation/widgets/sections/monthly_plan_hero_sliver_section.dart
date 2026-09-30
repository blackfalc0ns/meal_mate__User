import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/subscription_duration/subscription_duration_selector.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_plan_details_args.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/manager/subscription_plan_event.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/manager/subscription_plan_state.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/manager/subscription_plan_view_model.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/widgets/monthly_plan_hero_section.dart';

class MonthlyPlanHeroSliverSection extends StatelessWidget {
  const MonthlyPlanHeroSliverSection({
    super.key,
    required this.detailsArgs,
    this.onBack,
  });

  final SubscriptionPlanDetailsArgs detailsArgs;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return BlocBuilder<SubscriptionPlanViewModel, SubscriptionPlanState>(
      buildWhen: (previous, current) =>
          previous.browsedTierIndex != current.browsedTierIndex ||
          previous.durations != current.durations ||
          previous.selectedDurationIndex != current.selectedDurationIndex ||
          previous.includeFriday != current.includeFriday ||
          previous.customDurationDays != current.customDurationDays ||
          previous.canToggleFriday != current.canToggleFriday ||
          previous.isDurationsLoading != current.isDurationsLoading,
      builder: (context, state) {
        final isBrowsing = state.isBrowsingRestaurants;

        return SliverToBoxAdapter(
          child: MonthlyPlanHeroSection(
            titlePrefix: locale.drawer_month_package,
            titleHighlight: detailsArgs.program.name(locale.localeName),
            imageAsset: Assets.monthlyPlanHero,
            imageUrl: null,
            isBrowsingRestaurants: isBrowsing,
            durationSelector: isBrowsing
                ? null
                : SubscriptionDurationSelector(
                    selectedIndex: state.selectedDurationIndex,
                    onSelected: (index) =>
                        context.read<SubscriptionPlanViewModel>().doIntent(
                          SelectSubscriptionDurationEvent(
                            programId: detailsArgs.program.programId,
                            bundleId: detailsArgs.bundle.bundleId,
                            durationIndex: index,
                          ),
                        ),
                    includesFriday: state.includeFriday,
                    onFridayChanged: (value) =>
                        context.read<SubscriptionPlanViewModel>().doIntent(
                          ToggleSubscriptionFridayEvent(
                            programId: detailsArgs.program.programId,
                            bundleId: detailsArgs.bundle.bundleId,
                            includeFriday: value,
                          ),
                        ),
                    customDurationDays: state.customDurationDays,
                    onCustomDurationChanged: (value) =>
                        context.read<SubscriptionPlanViewModel>().doIntent(
                          UpdateCustomSubscriptionDurationEvent(
                            programId: detailsArgs.program.programId,
                            bundleId: detailsArgs.bundle.bundleId,
                            durationDays: value,
                          ),
                        ),
                    durations: state.durations,
                    isFridayEnabled: state.canToggleFriday,
                    isLoading:
                        state.isDurationsLoading && state.durations.isEmpty,
                  ),
            onBack: onBack ?? () => Navigator.maybePop(context),
          ),
        );
      },
    );
  }
}
