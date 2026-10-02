import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_subscription_button.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_args.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_args.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/manager/subscription_summary_state.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/manager/subscription_summary_view_model.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/widgets/subscription_summary_button_loading_skeleton.dart';

/// Pinned bottom bar section of the subscription checkout summary screen.
class SubscriptionSummaryBottomBarSection extends StatelessWidget {
  const SubscriptionSummaryBottomBarSection({
    super.key,
    required this.summaryArgs,
    required this.initialStartDate,
  });

  final SubscriptionSummaryArgs summaryArgs;
  final String initialStartDate;

  @override
  Widget build(BuildContext context) {
    return PositionedDirectional(
      start: Spacing.monthlyPlanContentHorizontalPadding,
      end: Spacing.monthlyPlanContentHorizontalPadding,
      bottom: Spacing.monthlyPlanContentHorizontalPadding,
      child: BlocBuilder<SubscriptionSummaryViewModel, SubscriptionSummaryState>(
        buildWhen: (previous, current) =>
            previous.isLoading != current.isLoading ||
            previous.summary != current.summary ||
            previous.selectedStartDate != current.selectedStartDate,
        builder: (context, state) {
          final summary = state.summary;
          final hasSummary = summary != null;
          final currentStartDate = summary?.startDate.trim().isNotEmpty == true
              ? summary!.startDate.trim()
              : (state.selectedStartDate.trim().isNotEmpty
                  ? state.selectedStartDate.trim()
                  : initialStartDate);

          final activeRequest = summaryArgs.request.copyWith(
            startDate: currentStartDate,
          );

          if (state.isLoading && !hasSummary) {
            return const SubscriptionSummaryButtonLoadingSkeleton();
          }

          return AppSubscriptionButton(
            price: hasSummary ? summary.finalPrice.formattedPrice : '',
            currency: hasSummary ? summary.currencyCode : '',
            onPressed: hasSummary && summary.canCheckout
                ? () => context.pushNamed(
                    AppRoutes.payment,
                    arguments: PaymentArgs(
                      summary: summary,
                      summaryRequest: activeRequest,
                      restaurantId:
                          summary.firstRestaurantId ??
                          summaryArgs.restaurantId,
                    ),
                  )
                : null,
          )
              .animate()
              .fadeIn(duration: 350.ms, curve: Curves.easeOut)
              .slideY(
                begin: 0.15,
                end: 0,
                duration: 350.ms,
                curve: Curves.easeOutCubic,
              );
        },
      ),
    );
  }
}
