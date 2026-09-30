import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_subscription_button.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_plan_details_args.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/manager/subscription_plan_event.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/manager/subscription_plan_state.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/manager/subscription_plan_view_model.dart';

class MonthlyPlanBottomBarSection extends StatelessWidget {
  const MonthlyPlanBottomBarSection({
    super.key,
    required this.detailsArgs,
  });

  final SubscriptionPlanDetailsArgs detailsArgs;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return PositionedDirectional(
      start: Spacing.monthlyPlanContentHorizontalPadding,
      end: Spacing.monthlyPlanContentHorizontalPadding,
      bottom: Spacing.monthlyPlanContentHorizontalPadding,
      child: BlocBuilder<SubscriptionPlanViewModel, SubscriptionPlanState>(
        buildWhen: (previous, current) =>
            previous.selectedTier != current.selectedTier ||
            previous.isTiersLoading != current.isTiersLoading ||
            previous.isSelectedDurationValid !=
                current.isSelectedDurationValid ||
            previous.isReadinessLoading != current.isReadinessLoading,
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
                    context.read<SubscriptionPlanViewModel>().doIntent(
                          CheckSubscriptionReadinessEvent(
                            programId: detailsArgs.program.programId,
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
    );
  }
}
