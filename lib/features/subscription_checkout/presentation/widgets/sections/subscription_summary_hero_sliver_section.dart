import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/widgets/monthly_plan_hero_section.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_args.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/manager/subscription_summary_state.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/manager/subscription_summary_view_model.dart';

/// Top hero sliver section of the subscription checkout summary screen.
class SubscriptionSummaryHeroSliverSection extends StatelessWidget {
  const SubscriptionSummaryHeroSliverSection({
    super.key,
    required this.summaryArgs,
  });

  final SubscriptionSummaryArgs summaryArgs;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return BlocBuilder<SubscriptionSummaryViewModel, SubscriptionSummaryState>(
      buildWhen: (previous, current) =>
          previous.summary?.programNameAr != current.summary?.programNameAr ||
          previous.summary?.bundleNameAr != current.summary?.bundleNameAr ||
          previous.summary?.imageUrl != current.summary?.imageUrl ||
          previous.summary?.programImageUrl != current.summary?.programImageUrl,
      builder: (context, state) {
        final summary = state.summary;
        final hasSummary = summary != null;

        final titlePrefix = hasSummary
            ? summary.programName(locale.localeName)
            : summaryArgs.initialPlan.titlePrefix;
        final titleHighlight = hasSummary
            ? summary.bundleName(locale.localeName)
            : summaryArgs.initialPlan.titleHighlight;
        final heroImageAsset = summaryArgs.initialPlan.heroImageAsset.isNotEmpty
            ? summaryArgs.initialPlan.heroImageAsset
            : Assets.monthlyPlanHero;

        return SliverToBoxAdapter(
          child: MonthlyPlanHeroSection(
            titlePrefix: titlePrefix,
            titleHighlight: titleHighlight,
            imageAsset: heroImageAsset,
            imageUrl: summary?.imageUrl ?? summary?.programImageUrl,
            onBack: () => Navigator.maybePop(context),
          ),
        );
      },
    );
  }
}
