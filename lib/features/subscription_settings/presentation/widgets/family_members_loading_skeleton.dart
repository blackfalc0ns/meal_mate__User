import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class FamilyMembersLoadingSkeleton extends StatelessWidget {
  const FamilyMembersLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsetsDirectional.only(
        start: Spacing.familyMembersHorizontalPadding,
        end: Spacing.familyMembersHorizontalPadding,
        bottom:
            Spacing.bottomNavHeight + Spacing.familyMembersBottomNavTopGap,
      ),
      children: [
        const SizedBox(height: Spacing.familyMembersSearchTopGap),
        const ShimmerPlaceholder.rect(
          height: Spacing.familyMembersSearchHeight,
          borderRadius: Spacing.familyMembersSearchRadius,
        ),
        const SizedBox(height: Spacing.familyMembersListTopGap),
        for (int i = 0; i < 4; i++)
          Padding(
            padding: const EdgeInsets.only(
              bottom: Spacing.familyMembersCardGap,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.familyMembersCardHorizontalPadding,
                vertical: Spacing.familyMembersCardVerticalPadding,
              ),
              decoration: BoxDecoration(
                color: color.surface,
                borderRadius: BorderRadius.circular(
                  Spacing.familyMembersCardRadius,
                ),
                border: Border.all(
                  color: color.outlineVariant,
                  width: Spacing.familyMembersCardBorder,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const ShimmerPlaceholder.rect(
                          width: 80,
                          height: 14,
                          borderRadius: Spacing.radiusXs,
                        ),
                        const SizedBox(height: Spacing.xs),
                        const ShimmerPlaceholder.rect(
                          width: 60,
                          height: 10,
                          borderRadius: Spacing.radiusXs,
                        ),
                        const SizedBox(height: Spacing.xs),
                        const ShimmerPlaceholder.rect(
                          width: 100,
                          height: 10,
                          borderRadius: Spacing.radiusXs,
                        ),
                        const SizedBox(height: Spacing.xs),
                        const ShimmerPlaceholder.rect(
                          width: 48,
                          height: Spacing.familyMembersStatusChipHeight,
                          borderRadius: Spacing.radiusPill,
                        ),
                        const SizedBox(height: Spacing.xs),
                        const ShimmerPlaceholder.rect(
                          width: 130,
                          height: Spacing.familyMembersNoteChipHeight,
                          borderRadius: Spacing.radiusPill,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: Spacing.md),
                  Column(
                    children: const [
                      ShimmerPlaceholder.circle(
                        size: Spacing.familyMembersAvatarSize,
                      ),
                      SizedBox(height: Spacing.xs),
                      ShimmerPlaceholder.rect(
                        width: 52,
                        height: Spacing.familyMembersAccountChipHeight,
                        borderRadius: Spacing.radiusPill,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: Spacing.familyMembersAddButtonTopGap),
        const ShimmerPlaceholder.rect(
          height: Spacing.familyMembersAddButtonHeight,
          borderRadius: Spacing.familyMembersAddButtonRadius,
        ),
      ],
    );
  }
}
