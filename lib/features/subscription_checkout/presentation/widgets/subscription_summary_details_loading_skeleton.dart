import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/widgets/subscription_summary_skeleton_card.dart';

class SubscriptionSummaryDetailsLoadingSkeleton extends StatelessWidget {
  const SubscriptionSummaryDetailsLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return Semantics(
      label: locale.subscription_summary_title,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: Spacing.subscriptionSummaryDetailsWidth,
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SubscriptionSummarySkeletonCard(height: 280),
            SizedBox(height: Spacing.md),
            SubscriptionSummarySkeletonCard(height: 110),
            SizedBox(height: Spacing.md),
            SubscriptionSummarySkeletonCard(height: 60),
            SizedBox(height: Spacing.md),
            SubscriptionSummarySkeletonCard(height: 60),
            SizedBox(height: Spacing.md),
            SubscriptionSummarySkeletonCard(height: 60),
            SizedBox(height: Spacing.md),
            Row(
              children: [
                Expanded(child: SubscriptionSummarySkeletonCard(height: 64)),
                SizedBox(width: Spacing.xss),
                Expanded(child: SubscriptionSummarySkeletonCard(height: 64)),
                SizedBox(width: Spacing.xss),
                Expanded(child: SubscriptionSummarySkeletonCard(height: 64)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
