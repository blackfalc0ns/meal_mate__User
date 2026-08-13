import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class SubscriptionPackagesLoadingSkeleton extends StatelessWidget {
  const SubscriptionPackagesLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Semantics(
      label: locale.nav_subscription,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.lg,
              vertical: Spacing.xl,
            ),
            sliver: SliverList.separated(
              itemCount: 5,
              separatorBuilder: (_, _) => const SizedBox(height: Spacing.md),
              itemBuilder: (context, index) {
                if (index == 1) {
                  return const ShimmerPlaceholder.rect(
                    width: Spacing.xxxl * 3,
                    height: Spacing.lg,
                    borderRadius: Spacing.radiusSm,
                  );
                }

                return Container(
                  height: index == 0
                      ? Spacing.subscriptionProgramCardHeight + Spacing.xs
                      : Spacing.subscriptionPackageChoiceFigmaHeight,
                  padding: const EdgeInsets.all(Spacing.md),
                  decoration: BoxDecoration(
                    color: color.surface,
                    borderRadius: BorderRadius.circular(
                      Spacing.subscriptionProgramCardRadius,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: color.shadow.withValues(alpha: 0.05),
                        blurRadius: Spacing.lg,
                        offset: const Offset(0, Spacing.xss),
                      ),
                    ],
                  ),
                  child: const Row(
                    children: [
                      ShimmerPlaceholder.rect(
                        width: Spacing.xxxl * 2,
                        height: Spacing.xxxl * 1.5,
                        borderRadius: Spacing.radiusMd,
                      ),
                      SizedBox(width: Spacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShimmerPlaceholder.rect(
                              width: double.infinity,
                              height: Spacing.md,
                              borderRadius: Spacing.radiusSm,
                            ),
                            SizedBox(height: Spacing.sm),
                            ShimmerPlaceholder.rect(
                              width: Spacing.xxxl * 2.5,
                              height: Spacing.sm,
                              borderRadius: Spacing.radiusSm,
                            ),
                            Spacer(),
                            ShimmerPlaceholder.rect(
                              width: Spacing.xxxl * 2,
                              height: Spacing.lg,
                              borderRadius: Spacing.radiusPill,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
