import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class SubscriptionTypesLoadingSkeleton extends StatelessWidget {
  const SubscriptionTypesLoadingSkeleton({
    super.key,
    required this.showBottomSpace,
  });

  final bool showBottomSpace;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return Semantics(
      label: locale.nav_subscription,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              Assets.subscriptionTypeBackground,
              fit: BoxFit.cover,
              semanticLabel: locale.nav_subscription,
            ),
          ),
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: EdgeInsets.only(
                  top: Spacing.lg,
                  bottom: showBottomSpace
                      ? Spacing.subscriptionProgramsBottomSpace
                      : Spacing.xl,
                ).add(const EdgeInsets.symmetric(horizontal: Spacing.screenH)),
                sliver: SliverList(
                  delegate: SliverChildListDelegate.fixed([
                    const Center(
                      child: FractionallySizedBox(
                        widthFactor: 0.38,
                        child: ShimmerPlaceholder.rect(
                          height: Spacing.subscriptionTypeLogoHeight,
                          borderRadius: Spacing.radiusSm,
                        ),
                      ),
                    ),
                    const SizedBox(height: Spacing.sm),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                        Spacing.subscriptionProgramCardRadius,
                      ),
                      child: const AspectRatio(
                        aspectRatio:
                            Spacing.subscriptionTypeHeroWidth /
                            Spacing.subscriptionTypeHeroHeight,
                        child: ShimmerPlaceholder.rect(
                          borderRadius: Spacing.subscriptionProgramCardRadius,
                        ),
                      ),
                    ),
                    const SizedBox(height: Spacing.sm),
                    const Center(
                      child: FractionallySizedBox(
                        widthFactor: 0.5,
                        child: ShimmerPlaceholder.rect(
                          height: Spacing.xl,
                          borderRadius: Spacing.radiusSm,
                        ),
                      ),
                    ),
                    const SizedBox(height: Spacing.sm),
                    const Center(
                      child: FractionallySizedBox(
                        widthFactor: 0.75,
                        child: ShimmerPlaceholder.rect(
                          height: Spacing.base,
                          borderRadius: Spacing.radiusSm,
                        ),
                      ),
                    ),
                    const SizedBox(height: Spacing.sm),
                    ...List.generate(2, (index) {
                      return const Padding(
                        padding: EdgeInsets.only(bottom: Spacing.sm),
                        child: ShimmerPlaceholder.rect(
                          height: Spacing.subscriptionTypeMobileCardHeight,
                          borderRadius: Spacing.subscriptionProgramCardRadius,
                        ),
                      );
                    }),
                    const SizedBox(height: Spacing.base),
                    const ShimmerPlaceholder.rect(
                      height: Spacing.subscriptionInfoHeight,
                      borderRadius: Spacing.subscriptionProgramCardRadius,
                    ),
                    const SizedBox(height: Spacing.md),
                    const ShimmerPlaceholder.rect(
                      height: Spacing.buttonHeight,
                      borderRadius: Spacing.radiusPill,
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
