import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_plan_details_args.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/manager/subscription_plan_state.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/manager/subscription_plan_view_model.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/widgets/monthly_plan_details_content.dart';

class MonthlyPlanContentSliverSection extends StatelessWidget {
  const MonthlyPlanContentSliverSection({
    super.key,
    required this.detailsArgs,
  });

  final SubscriptionPlanDetailsArgs detailsArgs;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.screenH,
      ).copyWith(top: Spacing.xs, bottom: Spacing.screenV),
      sliver: SliverToBoxAdapter(
        child: BlocBuilder<SubscriptionPlanViewModel, SubscriptionPlanState>(
          buildWhen: (previous, current) =>
              previous.tiers != current.tiers ||
              previous.selectedTierIndex != current.selectedTierIndex ||
              previous.browseRestaurants != current.browseRestaurants ||
              previous.browsedTierIndex != current.browsedTierIndex ||
              previous.isTiersLoading != current.isTiersLoading ||
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
              subscribeLabel: locale.subscription_details_subscribe_now,
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
    );
  }
}
