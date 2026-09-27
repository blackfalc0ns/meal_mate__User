import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class MealDetailsLoadingSkeleton extends StatelessWidget {
  const MealDetailsLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    const overlap =
        Spacing.restaurantDetailsHeroHeight - Spacing.restaurantDetailsSheetTop;
    const imageHeight = Spacing.xxxl * 4 + Spacing.xxl;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Stack(
        children: [
          Positioned(
            top: Spacing.zero,
            left: Spacing.zero,
            right: Spacing.zero,
            child: Stack(
              children: [
                const ShimmerPlaceholder.rect(
                  height: imageHeight,
                  borderRadius: Spacing.zero,
                ),
                Positioned(
                  left: Spacing.xl,
                  bottom: Spacing.xxl + overlap,
                  child: const ShimmerPlaceholder.rect(
                    width: 100,
                    height: 28,
                    borderRadius: Spacing.radiusSm,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: imageHeight - overlap),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(Spacing.restaurantDetailsSheetRadius),
              ),
              child: ColoredBox(
                color: color.surface,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: Spacing.screenV,
                    horizontal: Spacing.screenH,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerPlaceholder.circle(size: 65),
                          SizedBox(width: Spacing.base),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ShimmerPlaceholder.rect(
                                  width: 200,
                                  height: Spacing.lg,
                                  borderRadius: Spacing.radiusXs,
                                ),
                                SizedBox(height: Spacing.sm),
                                ShimmerPlaceholder.rect(
                                  width: 110,
                                  height: Spacing.md,
                                  borderRadius: Spacing.radiusXs,
                                ),
                                SizedBox(height: Spacing.sm),
                                ShimmerPlaceholder.rect(
                                  height: Spacing.md,
                                  borderRadius: Spacing.radiusXs,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Spacing.md),
                      Row(
                        children: [
                          const Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ShimmerPlaceholder.circle(size: Spacing.iconLg),
                                SizedBox(width: Spacing.sm),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ShimmerPlaceholder.rect(
                                      width: 60,
                                      height: 10,
                                      borderRadius: Spacing.radiusXs,
                                    ),
                                    SizedBox(height: Spacing.xs),
                                    ShimmerPlaceholder.rect(
                                      width: 50,
                                      height: 10,
                                      borderRadius: Spacing.radiusXs,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: Spacing.iconLg,
                            child: VerticalDivider(color: color.outlineVariant),
                          ),
                          const Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ShimmerPlaceholder.circle(size: Spacing.iconLg),
                                SizedBox(width: Spacing.sm),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ShimmerPlaceholder.rect(
                                      width: 70,
                                      height: 10,
                                      borderRadius: Spacing.radiusXs,
                                    ),
                                    SizedBox(height: Spacing.xs),
                                    ShimmerPlaceholder.rect(
                                      width: 45,
                                      height: 10,
                                      borderRadius: Spacing.radiusXs,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Spacing.md),
                      const Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: ShimmerPlaceholder.rect(
                          width: 90,
                          height: Spacing.base,
                          borderRadius: Spacing.radiusXs,
                        ),
                      ),
                      const SizedBox(height: Spacing.xs),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border.symmetric(
                            horizontal: BorderSide(color: color.outlineVariant),
                          ),
                        ),
                        child: const SizedBox(
                          height: Spacing.avatarLg + Spacing.md,
                          child: Padding(
                            padding: EdgeInsetsDirectional.only(
                              top: Spacing.xss,
                            ),
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    ShimmerPlaceholder.rect(
                                      width: Spacing.iconXl,
                                      height: Spacing.iconXl,
                                      borderRadius: Spacing.radiusSm,
                                    ),
                                    SizedBox(height: Spacing.xs),
                                    ShimmerPlaceholder.rect(
                                      width: Spacing.iconXl,
                                      height: 10,
                                      borderRadius: Spacing.radiusXs,
                                    ),
                                  ],
                                ),
                                SizedBox(width: Spacing.md),
                                Column(
                                  children: [
                                    ShimmerPlaceholder.rect(
                                      width: Spacing.iconXl,
                                      height: Spacing.iconXl,
                                      borderRadius: Spacing.radiusSm,
                                    ),
                                    SizedBox(height: Spacing.xs),
                                    ShimmerPlaceholder.rect(
                                      width: Spacing.iconXl,
                                      height: 10,
                                      borderRadius: Spacing.radiusXs,
                                    ),
                                  ],
                                ),
                                SizedBox(width: Spacing.md),
                                Column(
                                  children: [
                                    ShimmerPlaceholder.rect(
                                      width: Spacing.iconXl,
                                      height: Spacing.iconXl,
                                      borderRadius: Spacing.radiusSm,
                                    ),
                                    SizedBox(height: Spacing.xs),
                                    ShimmerPlaceholder.rect(
                                      width: Spacing.iconXl,
                                      height: 10,
                                      borderRadius: Spacing.radiusXs,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: Spacing.base),
                      const Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: ShimmerPlaceholder.rect(
                          width: 110,
                          height: Spacing.base,
                          borderRadius: Spacing.radiusXs,
                        ),
                      ),
                      const SizedBox(height: Spacing.xs),
                      Row(
                        children: [
                          for (var i = 0; i < 5; i++) ...[
                            Expanded(
                              child: Container(
                                height: Spacing.avatarLg,
                                padding: const EdgeInsets.symmetric(
                                  vertical: Spacing.xs,
                                ),
                                decoration: BoxDecoration(
                                  color: color.tertiaryContainer,
                                  border: Border.all(
                                    color: color.outlineVariant,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    Spacing.radiusMd,
                                  ),
                                ),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ShimmerPlaceholder.circle(
                                      size: Spacing.iconSm,
                                    ),
                                    SizedBox(height: Spacing.xs),
                                    ShimmerPlaceholder.rect(
                                      width: 24,
                                      height: 10,
                                      borderRadius: Spacing.radiusXs,
                                    ),
                                    SizedBox(height: Spacing.xs),
                                    ShimmerPlaceholder.rect(
                                      width: 32,
                                      height: 10,
                                      borderRadius: Spacing.radiusXs,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (i < 4) const SizedBox(width: Spacing.sm),
                          ],
                        ],
                      ),
                      const SizedBox(height: Spacing.xs),
                      Divider(color: color.outlineVariant),
                      const SizedBox(height: Spacing.base),
                      Container(
                        padding: const EdgeInsets.all(Spacing.md),
                        decoration: BoxDecoration(
                          color: color.surface,
                          border: Border.all(color: color.outlineVariant),
                          borderRadius: BorderRadius.circular(
                            Spacing.radiusSm,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const ShimmerPlaceholder.rect(
                              width: 120,
                              height: 12,
                              borderRadius: Spacing.radiusXs,
                            ),
                            const SizedBox(height: Spacing.sm),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Expanded(
                                  child: Column(
                                    children: [
                                      ShimmerPlaceholder.circle(size: 28),
                                      SizedBox(height: Spacing.xs),
                                      ShimmerPlaceholder.rect(
                                        width: 38,
                                        height: 10,
                                        borderRadius: Spacing.radiusXs,
                                      ),
                                      SizedBox(height: Spacing.xs),
                                      ShimmerPlaceholder.rect(
                                        width: 32,
                                        height: 16,
                                        borderRadius: Spacing.radiusXs,
                                      ),
                                      SizedBox(height: Spacing.xs),
                                      ShimmerPlaceholder.rect(
                                        width: 36,
                                        height: 8,
                                        borderRadius: Spacing.radiusXs,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: Spacing.avatarLg,
                                  child: VerticalDivider(
                                    color: color.outlineVariant,
                                  ),
                                ),
                                for (var i = 0; i < 3; i++) ...[
                                  const Expanded(
                                    child: Column(
                                      children: [
                                        ShimmerPlaceholder.circle(
                                          size: Spacing.avatarMd,
                                        ),
                                        SizedBox(height: Spacing.xs),
                                        ShimmerPlaceholder.rect(
                                          width: 36,
                                          height: 10,
                                          borderRadius: Spacing.radiusXs,
                                        ),
                                        SizedBox(height: Spacing.xs),
                                        ShimmerPlaceholder.rect(
                                          width: 28,
                                          height: 9,
                                          borderRadius: Spacing.radiusXs,
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (i < 2)
                                    SizedBox(
                                      height: Spacing.avatarLg,
                                      child: VerticalDivider(
                                        color: color.outlineVariant,
                                      ),
                                    ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: Spacing.xxl),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
