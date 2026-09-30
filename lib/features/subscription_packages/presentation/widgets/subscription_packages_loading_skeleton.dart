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
      label: locale.subscription_choose_plan_title,
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
                    width: Spacing.subscriptionProgramsHeaderWidth,
                    height: Spacing.lg,
                    borderRadius: Spacing.radiusSm,
                  );
                }

                if (index == 0) {
                  return Container(
                    height: Spacing.subscriptionProgramCardHeight,
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
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ShimmerPlaceholder.rect(
                                width: Spacing.subscriptionChooseButtonWidth,
                                height: Spacing.md,
                                borderRadius: Spacing.radiusSm,
                              ),
                              SizedBox(height: Spacing.sm),
                              ShimmerPlaceholder.rect(
                                width: double.infinity,
                                height: Spacing.sm,
                                borderRadius: Spacing.radiusSm,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: Spacing.md),
                        ShimmerPlaceholder.circle(
                          size: Spacing.avatarLg,
                        ),
                      ],
                    ),
                  );
                }

                return Container(
                  height: Spacing.subscriptionPackageChoiceFigmaHeight,
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                ShimmerPlaceholder.circle(size: Spacing.xl),
                                SizedBox(width: Spacing.xs),
                                Expanded(
                                  child: ShimmerPlaceholder.rect(
                                    width: double.infinity,
                                    height: Spacing.md,
                                    borderRadius: Spacing.radiusSm,
                                  ),
                                ),
                              ],
                            ),
                            ShimmerPlaceholder.rect(
                              width: Spacing.subscriptionChooseButtonWidth,
                              height: Spacing.sm,
                              borderRadius: Spacing.radiusSm,
                            ),
                            ShimmerPlaceholder.rect(
                              width: Spacing.avatarLg,
                              height: Spacing.lg,
                              borderRadius: Spacing.radiusPill,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: Spacing.sm),
                      ShimmerPlaceholder.rect(
                        width: Spacing.subscriptionPackageChoiceImageWidth,
                        height: Spacing.subscriptionPackageChoiceImageHeight,
                        borderRadius: Spacing.radiusMd,
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
