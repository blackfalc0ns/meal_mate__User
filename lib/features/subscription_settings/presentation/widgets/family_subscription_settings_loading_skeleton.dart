import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class FamilySubscriptionSettingsLoadingSkeleton extends StatelessWidget {
  const FamilySubscriptionSettingsLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.familyManageHorizontalPadding,
      ),
      children: [
        const SizedBox(height: Spacing.md),
        const ShimmerPlaceholder.rect(
          height: Spacing.familyManagePlanCardHeight,
          borderRadius: Spacing.familyManagePlanCardRadius,
        ),
        const SizedBox(height: Spacing.xl),
        Row(
          children: const [
            ShimmerPlaceholder.rect(
              width: 90,
              height: 16,
              borderRadius: Spacing.radiusXs,
            ),
            Spacer(),
            ShimmerPlaceholder.rect(
              width: 55,
              height: 14,
              borderRadius: Spacing.radiusXs,
            ),
          ],
        ),
        const SizedBox(height: Spacing.md),
        Row(
          children: [
            for (int i = 0; i < 2; i++) ...[
              if (i > 0) const SizedBox(width: 11.58),
              Expanded(
                child: Container(
                  height: Spacing.familyManageMemberCardHeight,
                  decoration: BoxDecoration(
                    color: color.surface,
                    border: Border.all(color: color.outlineVariant),
                    borderRadius: BorderRadiusDirectional.circular(11.5),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      ShimmerPlaceholder.circle(
                        size: Spacing.familyManageMemberAvatarSize,
                      ),
                      SizedBox(height: Spacing.xs),
                      ShimmerPlaceholder.rect(
                        width: 50,
                        height: 11,
                        borderRadius: Spacing.radiusXs,
                      ),
                      SizedBox(height: Spacing.sm),
                      ShimmerPlaceholder.rect(
                        width: 60,
                        height: 9,
                        borderRadius: Spacing.radiusXs,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: Spacing.xl),
        const ShimmerPlaceholder.rect(
          width: 80,
          height: 16,
          borderRadius: Spacing.radiusXs,
        ),
        const SizedBox(height: Spacing.md),
        Row(
          children: [
            for (int i = 0; i < 3; i++) ...[
              if (i > 0) const SizedBox(width: Spacing.sm),
              Expanded(
                child: Container(
                  height: Spacing.familyManageQuickTileHeight,
                  decoration: BoxDecoration(
                    color: color.surface,
                    border: Border.all(
                      color: color.outlineVariant,
                      width: 1.45,
                    ),
                    borderRadius: BorderRadiusDirectional.circular(13.07),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      ShimmerPlaceholder.rect(
                        width: Spacing.familyManageQuickIconSize,
                        height: Spacing.familyManageQuickIconSize,
                        borderRadius: Spacing.radiusSm,
                      ),
                      SizedBox(height: Spacing.xs),
                      ShimmerPlaceholder.rect(
                        width: 40,
                        height: 9,
                        borderRadius: Spacing.radiusXs,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: Spacing.xl),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.base,
            vertical: Spacing.md,
          ),
          decoration: BoxDecoration(
            color: color.surface,
            border: Border.all(color: color.outlineVariant, width: 1.85),
            borderRadius: BorderRadiusDirectional.circular(14.48),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ShimmerPlaceholder.rect(
                width: 100,
                height: 14,
                borderRadius: Spacing.radiusXs,
              ),
              const SizedBox(height: Spacing.xss),
              const ShimmerPlaceholder.rect(
                width: 75,
                height: 11,
                borderRadius: Spacing.radiusXs,
              ),
              const SizedBox(height: Spacing.md),
              Row(
                children: const [
                  Expanded(
                    child: Row(
                      children: [
                        ShimmerPlaceholder.circle(size: 20),
                        SizedBox(width: Spacing.xs),
                        ShimmerPlaceholder.rect(
                          width: 42,
                          height: 10,
                          borderRadius: Spacing.radiusXs,
                        ),
                        SizedBox(width: Spacing.xs),
                        Expanded(
                          child: ShimmerPlaceholder.rect(
                            height: 4,
                            borderRadius: Spacing.radiusXs,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: Spacing.md),
                  Expanded(
                    child: Row(
                      children: [
                        ShimmerPlaceholder.circle(size: 20),
                        SizedBox(width: Spacing.xs),
                        ShimmerPlaceholder.rect(
                          width: 42,
                          height: 10,
                          borderRadius: Spacing.radiusXs,
                        ),
                        SizedBox(width: Spacing.xs),
                        Expanded(
                          child: ShimmerPlaceholder.rect(
                            height: 4,
                            borderRadius: Spacing.radiusXs,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Spacing.base),
              const ShimmerPlaceholder.rect(
                height: Spacing.xxl,
                borderRadius: Spacing.radiusPill,
              ),
            ],
          ),
        ),
        const SizedBox(height: Spacing.md),
        Container(
          height: Spacing.familyManageWarningHeight,
          padding: const EdgeInsets.symmetric(horizontal: Spacing.xl),
          decoration: BoxDecoration(
            color: color.surface,
            border: Border.all(color: color.outlineVariant),
            borderRadius: BorderRadiusDirectional.circular(13.31),
          ),
          child: Row(
            children: const [
              ShimmerPlaceholder.circle(size: 29.04),
              SizedBox(width: Spacing.md),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerPlaceholder.rect(
                      width: 120,
                      height: 10,
                      borderRadius: Spacing.radiusXs,
                    ),
                    SizedBox(height: Spacing.xss),
                    ShimmerPlaceholder.rect(
                      width: 160,
                      height: 10,
                      borderRadius: Spacing.radiusXs,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: Spacing.xl),
      ],
    );
  }
}
