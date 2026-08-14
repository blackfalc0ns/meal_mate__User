import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class SubscriptionSummaryButtonLoadingSkeleton extends StatelessWidget {
  const SubscriptionSummaryButtonLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Semantics(
      label: locale.subscription_details_subscribe_now,
      child: ShimmerWidget(
        baseColor: color.surfaceContainerHighest,
        highlightColor: color.surface,
        child: Container(
          width: double.infinity,
          height: Spacing.monthlyPlanSubscribeHeight,
          decoration: BoxDecoration(
            color: color.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(
              Spacing.monthlyPlanSubscribeRadius,
            ),
          ),
        ),
      ),
    );
  }
}
