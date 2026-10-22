import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class PaymentLoadingSkeleton extends StatelessWidget {
  const PaymentLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Semantics(
      label: locale.payment_title,
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.only(top: Spacing.sm, bottom: Spacing.lg),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.base),
                  child: Container(
                    padding: const EdgeInsets.all(Spacing.md),
                    decoration: BoxDecoration(
                      color: color.surface,
                      borderRadius: BorderRadius.circular(Spacing.cardRadius),
                      border: Border.all(color: color.outlineVariant),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShimmerPlaceholder.rect(
                              width: Spacing.xxxl * 3.5,
                              height: Spacing.xxxl * 2.7,
                              borderRadius: Spacing.sm,
                            ),
                            SizedBox(width: Spacing.sm),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  ShimmerPlaceholder.rect(
                                    width: Spacing.xxxl * 2,
                                    height: Spacing.lg,
                                    borderRadius: Spacing.radiusPill,
                                  ),
                                  SizedBox(height: Spacing.md),
                                  ShimmerPlaceholder.rect(
                                    height: Spacing.lg,
                                    borderRadius: Spacing.radiusPill,
                                  ),
                                  SizedBox(height: Spacing.sm),
                                  ShimmerPlaceholder.rect(
                                    width: Spacing.xxxl,
                                    height: Spacing.lg,
                                    borderRadius: Spacing.radiusPill,
                                  ),
                                  SizedBox(height: Spacing.md),
                                  ShimmerPlaceholder.rect(
                                    width: Spacing.xxxl * 1.6,
                                    height: Spacing.base,
                                    borderRadius: Spacing.radiusPill,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: Spacing.md),
                        ShimmerPlaceholder.rect(
                          height: Spacing.md,
                          borderRadius: Spacing.radiusPill,
                        ),
                        SizedBox(height: Spacing.sm),
                        ShimmerPlaceholder.rect(
                          height: Spacing.md,
                          borderRadius: Spacing.radiusPill,
                        ),
                        SizedBox(height: Spacing.base),
                        ShimmerPlaceholder.rect(
                          width: Spacing.xxxl * 3,
                          height: Spacing.xxl,
                          borderRadius: Spacing.radiusPill,
                        ),
                        SizedBox(height: Spacing.base),
                        ShimmerPlaceholder.rect(
                          height: Spacing.xxl,
                          borderRadius: Spacing.sm,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: Spacing.xl),
                const Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: Spacing.base),
                    child: ShimmerPlaceholder.rect(
                      width: Spacing.xxxl * 3,
                      height: Spacing.xl,
                      borderRadius: Spacing.radiusPill,
                    ),
                  ),
                ),
                const SizedBox(height: Spacing.md),
                for (var index = 0; index < 3; index++)
                  Padding(
                    padding: EdgeInsets.only(
                      left: Spacing.base,
                      right: Spacing.base,
                      bottom: index == 2 ? Spacing.zero : Spacing.md,
                    ),
                    child: const ShimmerPlaceholder.rect(
                      height: Spacing.xxxl * 1.5,
                      borderRadius: Spacing.cardRadius,
                    ),
                  ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
