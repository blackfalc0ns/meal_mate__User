import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class FamilyMemberPermissionsLoadingSkeleton extends StatelessWidget {
  const FamilyMemberPermissionsLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(Spacing.md),
      children: [
        const ShimmerPlaceholder.rect(
          width: 220,
          height: 14,
          borderRadius: Spacing.radiusXs,
        ),
        const SizedBox(height: Spacing.md),

        // Group 1: الوجبات (3 items)
        const ShimmerPlaceholder.rect(
          width: 60,
          height: 16,
          borderRadius: Spacing.radiusXs,
        ),
        const SizedBox(height: Spacing.xs),
        Card(
          color: color.surface,
          child: Column(
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Spacing.base,
                  vertical: Spacing.md,
                ),
                child: Row(
                  children: [
                    ShimmerPlaceholder.rect(
                      width: 140,
                      height: 14,
                      borderRadius: Spacing.radiusXs,
                    ),
                    Spacer(),
                    ShimmerPlaceholder.rect(
                      width: 52,
                      height: 32,
                      borderRadius: Spacing.radiusPill,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Spacing.base,
                  vertical: Spacing.md,
                ),
                child: Row(
                  children: [
                    ShimmerPlaceholder.rect(
                      width: 150,
                      height: 14,
                      borderRadius: Spacing.radiusXs,
                    ),
                    Spacer(),
                    ShimmerPlaceholder.rect(
                      width: 52,
                      height: 32,
                      borderRadius: Spacing.radiusPill,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Spacing.base,
                  vertical: Spacing.md,
                ),
                child: Row(
                  children: [
                    ShimmerPlaceholder.rect(
                      width: 100,
                      height: 14,
                      borderRadius: Spacing.radiusXs,
                    ),
                    Spacer(),
                    ShimmerPlaceholder.rect(
                      width: 52,
                      height: 32,
                      borderRadius: Spacing.radiusPill,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: Spacing.md),

        // Group 2: البرنامج (2 items)
        const ShimmerPlaceholder.rect(
          width: 65,
          height: 16,
          borderRadius: Spacing.radiusXs,
        ),
        const SizedBox(height: Spacing.xs),
        Card(
          color: color.surface,
          child: Column(
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Spacing.base,
                  vertical: Spacing.md,
                ),
                child: Row(
                  children: [
                    ShimmerPlaceholder.rect(
                      width: 100,
                      height: 14,
                      borderRadius: Spacing.radiusXs,
                    ),
                    Spacer(),
                    ShimmerPlaceholder.rect(
                      width: 52,
                      height: 32,
                      borderRadius: Spacing.radiusPill,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Spacing.base,
                  vertical: Spacing.md,
                ),
                child: Row(
                  children: [
                    ShimmerPlaceholder.rect(
                      width: 110,
                      height: 14,
                      borderRadius: Spacing.radiusXs,
                    ),
                    Spacer(),
                    ShimmerPlaceholder.rect(
                      width: 52,
                      height: 32,
                      borderRadius: Spacing.radiusPill,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: Spacing.md),

        // Group 3: التوصيل (2 items)
        const ShimmerPlaceholder.rect(
          width: 60,
          height: 16,
          borderRadius: Spacing.radiusXs,
        ),
        const SizedBox(height: Spacing.xs),
        Card(
          color: color.surface,
          child: Column(
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Spacing.base,
                  vertical: Spacing.md,
                ),
                child: Row(
                  children: [
                    ShimmerPlaceholder.rect(
                      width: 130,
                      height: 14,
                      borderRadius: Spacing.radiusXs,
                    ),
                    Spacer(),
                    ShimmerPlaceholder.rect(
                      width: 52,
                      height: 32,
                      borderRadius: Spacing.radiusPill,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Spacing.base,
                  vertical: Spacing.md,
                ),
                child: Row(
                  children: [
                    ShimmerPlaceholder.rect(
                      width: 105,
                      height: 14,
                      borderRadius: Spacing.radiusXs,
                    ),
                    Spacer(),
                    ShimmerPlaceholder.rect(
                      width: 52,
                      height: 32,
                      borderRadius: Spacing.radiusPill,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: Spacing.md),

        // Group 4: الحساب (1 item)
        const ShimmerPlaceholder.rect(
          width: 55,
          height: 16,
          borderRadius: Spacing.radiusXs,
        ),
        const SizedBox(height: Spacing.xs),
        Card(
          color: color.surface,
          child: Column(
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Spacing.base,
                  vertical: Spacing.md,
                ),
                child: Row(
                  children: [
                    ShimmerPlaceholder.rect(
                      width: 120,
                      height: 14,
                      borderRadius: Spacing.radiusXs,
                    ),
                    Spacer(),
                    ShimmerPlaceholder.rect(
                      width: 52,
                      height: 32,
                      borderRadius: Spacing.radiusPill,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: Spacing.md),
      ],
    );
  }
}
