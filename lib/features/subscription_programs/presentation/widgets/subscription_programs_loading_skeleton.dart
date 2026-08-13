import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';
import 'package:meal_meat_user/features/subscription_programs/presentation/widgets/subscription_program_hero.dart';

class SubscriptionProgramsLoadingSkeleton extends StatelessWidget {
  const SubscriptionProgramsLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Semantics(
      label: locale.nav_subscription,
      child: ColoredBox(
        color: color.surface,
        child: Stack(
          children: [
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: Spacing.subscriptionProgramsHeroHeight,
              child: SubscriptionProgramHero(),
            ),
            Positioned.fill(
              top: Spacing.subscriptionProgramsContentTop,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: color.surface,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(Spacing.radiusXl),
                  ),
                ),
                child: CustomScrollView(
                  slivers: [
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: Spacing.base,
                          left: Spacing.subscriptionProgramsHorizontalPadding,
                          right: Spacing.subscriptionProgramsHorizontalPadding,
                        ),
                        child: Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: ShimmerPlaceholder.rect(
                            width: Spacing.subscriptionProgramsHeaderWidth,
                            height: Spacing.xxl,
                            borderRadius: Spacing.radiusSm,
                          ),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.only(
                        top: Spacing.base,
                        left: Spacing.subscriptionProgramsHorizontalPadding,
                        right: Spacing.subscriptionProgramsHorizontalPadding,
                        bottom: Spacing.subscriptionProgramsBottomSpace,
                      ),
                      sliver: SliverList.separated(
                        itemCount: 4,
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: Spacing.sm),
                        itemBuilder: (context, index) {
                          return const ShimmerPlaceholder.rect(
                            height: Spacing.subscriptionProgramCardHeight,
                            borderRadius: Spacing.subscriptionProgramCardRadius,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
