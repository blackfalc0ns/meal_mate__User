import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class SubscriptionBillingLoadingSkeleton extends StatelessWidget {
  const SubscriptionBillingLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.profileBillingHorizontalPadding,
          vertical: Spacing.md,
        ),
        child: Semantics(
          label: locale.profile_billing,
          child: Column(
            children: [
              const ShimmerPlaceholder.rect(
                height: Spacing.profileBillingPlanHeight,
                borderRadius: Spacing.profileBillingCardRadius,
              ),
              const SizedBox(height: Spacing.md),
              const ShimmerPlaceholder.rect(
                height: Spacing.profileBillingPaymentHeight,
                borderRadius: Spacing.profileBillingCardRadius,
              ),
              const SizedBox(height: Spacing.md),
              const ShimmerPlaceholder.rect(
                height: Spacing.profileBillingInvoicesHeight,
                borderRadius: Spacing.profileBillingCardRadius,
              ),
              const SizedBox(height: Spacing.md),
              Container(
                height: Spacing.profileBillingNoticeHeight,
                decoration: BoxDecoration(
                  color: color.surface,
                  borderRadius: BorderRadius.circular(Spacing.radiusMd),
                  border: Border.all(color: color.outlineVariant),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: Spacing.sm),
                  child: Row(
                    children: [
                      ShimmerPlaceholder.circle(size: Spacing.iconSm),
                      SizedBox(width: Spacing.sm),
                      Expanded(
                        child: ShimmerPlaceholder.rect(
                          height: Spacing.md,
                          borderRadius: Spacing.radiusSm,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: Spacing.lg),
              const ShimmerPlaceholder.rect(
                height: Spacing.profileBillingButtonHeight,
                borderRadius: Spacing.radiusPill,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
