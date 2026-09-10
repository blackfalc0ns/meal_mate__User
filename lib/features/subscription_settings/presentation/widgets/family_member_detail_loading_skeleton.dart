import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class FamilyMemberDetailLoadingSkeleton extends StatelessWidget {
  const FamilyMemberDetailLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsetsDirectional.only(
        start: Spacing.familyMemberDetailHorizontalPadding,
        end: Spacing.familyMemberDetailHorizontalPadding,
        top: Spacing.familyMemberDetailCardGap,
        bottom: Spacing.xl,
      ),
      child: Column(
        children: [
          // 1. Profile Card Skeleton
          Container(
            height: Spacing.familyMemberDetailProfileHeight,
            padding: const EdgeInsets.all(
              Spacing.familyMemberDetailCardPadding,
            ),
            decoration: BoxDecoration(
              color: color.surface,
              borderRadius: BorderRadius.circular(
                Spacing.familyMemberDetailCardRadius,
              ),
              border: Border.all(
                color: color.outlineVariant,
                width: Spacing.familyMemberDetailCardBorder,
              ),
            ),
            child: Row(
              children: [
                const ShimmerPlaceholder.circle(
                  size: Spacing.familyMemberDetailAvatarSize,
                ),
                const Spacer(),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ShimmerPlaceholder.rect(
                      width: 80,
                      height: 16,
                      borderRadius: Spacing.radiusXs,
                    ),
                    SizedBox(height: Spacing.xs),
                    ShimmerPlaceholder.rect(
                      width: 60,
                      height: 12,
                      borderRadius: Spacing.radiusXs,
                    ),
                    SizedBox(height: Spacing.xs),
                    ShimmerPlaceholder.rect(
                      width: 50,
                      height: Spacing.familyMemberDetailChipHeight,
                      borderRadius: Spacing.familyMemberDetailChipRadius,
                    ),
                    SizedBox(height: Spacing.xs),
                    ShimmerPlaceholder.rect(
                      width: 70,
                      height: 12,
                      borderRadius: Spacing.radiusXs,
                    ),
                  ],
                ),
                const SizedBox(width: Spacing.md),
                const ShimmerPlaceholder.rect(
                  width: 12,
                  height: 18,
                  borderRadius: Spacing.radiusXs,
                ),
              ],
            ),
          ),
          const SizedBox(height: Spacing.familyMemberDetailCardGap),

          // 2. Program Card Skeleton
          Container(
            height: Spacing.familyMemberDetailStandardCardHeight + Spacing.xxl,
            padding: const EdgeInsets.all(
              Spacing.familyMemberDetailCardPadding,
            ),
            decoration: BoxDecoration(
              color: color.surface,
              borderRadius: BorderRadius.circular(
                Spacing.familyMemberDetailCardRadius,
              ),
              border: Border.all(
                color: color.outlineVariant,
                width: Spacing.familyMemberDetailCardBorder,
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ShimmerPlaceholder.rect(
                      width: 90,
                      height: 14,
                      borderRadius: Spacing.radiusXs,
                    ),
                    SizedBox(width: Spacing.sm),
                    ShimmerPlaceholder.rect(
                      width: Spacing.familyMemberDetailHeaderIconSize,
                      height: Spacing.familyMemberDetailHeaderIconSize,
                      borderRadius: Spacing.radiusXs,
                    ),
                  ],
                ),
                Spacer(),
                Center(
                  child: ShimmerPlaceholder.circle(
                    size: Spacing.familyMemberDetailProgramImageHeight,
                  ),
                ),
                SizedBox(height: Spacing.xs),
                Center(
                  child: ShimmerPlaceholder.rect(
                    width: 70,
                    height: 16,
                    borderRadius: Spacing.radiusXs,
                  ),
                ),
                Spacer(),
                ShimmerPlaceholder.rect(
                  height: Spacing.familyMemberDetailButtonHeight,
                  borderRadius: Spacing.familyMemberDetailButtonRadius,
                ),
              ],
            ),
          ),
          const SizedBox(height: Spacing.familyMemberDetailCardGap),

          // 3. Package Card Skeleton
          Container(
            height: Spacing.familyMemberDetailStandardCardHeight,
            padding: const EdgeInsets.all(
              Spacing.familyMemberDetailCardPadding,
            ),
            decoration: BoxDecoration(
              color: color.surface,
              borderRadius: BorderRadius.circular(
                Spacing.familyMemberDetailCardRadius,
              ),
              border: Border.all(
                color: color.outlineVariant,
                width: Spacing.familyMemberDetailCardBorder,
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ShimmerPlaceholder.rect(
                      width: 60,
                      height: 14,
                      borderRadius: Spacing.radiusXs,
                    ),
                    SizedBox(width: Spacing.sm),
                    ShimmerPlaceholder.rect(
                      width: Spacing.familyMemberDetailHeaderIconSize,
                      height: Spacing.familyMemberDetailHeaderIconSize,
                      borderRadius: Spacing.radiusXs,
                    ),
                  ],
                ),
                Spacer(),
                Center(
                  child: ShimmerPlaceholder.rect(
                    width: 100,
                    height: 18,
                    borderRadius: Spacing.radiusXs,
                  ),
                ),
                SizedBox(height: Spacing.sm),
                Center(
                  child: ShimmerPlaceholder.rect(
                    width: 120,
                    height: 12,
                    borderRadius: Spacing.radiusXs,
                  ),
                ),
                Spacer(),
                ShimmerPlaceholder.rect(
                  height: Spacing.familyMemberDetailButtonHeight,
                  borderRadius: Spacing.familyMemberDetailButtonRadius,
                ),
              ],
            ),
          ),
          const SizedBox(height: Spacing.familyMemberDetailCardGap),

          // 4. Progress Card Skeleton
          Container(
            height: Spacing.familyMemberDetailProgressCardHeight,
            padding: const EdgeInsetsDirectional.only(
              start: Spacing.xl,
              top: Spacing.md,
              end: Spacing.md,
              bottom: Spacing.sm,
            ),
            decoration: BoxDecoration(
              color: color.surface,
              borderRadius: BorderRadius.circular(
                Spacing.familyMemberDetailCardRadius,
              ),
              border: Border.all(
                color: color.outlineVariant,
                width: Spacing.familyMemberDetailCardBorder,
              ),
            ),
            child: const Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ShimmerPlaceholder.rect(
                      width: 90,
                      height: 14,
                      borderRadius: Spacing.radiusXs,
                    ),
                    SizedBox(width: Spacing.sm),
                    ShimmerPlaceholder.rect(
                      width: Spacing.familyMemberDetailHeaderIconSize,
                      height: Spacing.familyMemberDetailHeaderIconSize,
                      borderRadius: Spacing.radiusXs,
                    ),
                  ],
                ),
                Expanded(
                  child: Row(
                    children: [
                      ShimmerPlaceholder.rect(
                        width: Spacing.familyMemberDetailCalendarButtonWidth,
                        height: Spacing.familyMemberDetailCalendarButtonHeight,
                        borderRadius:
                            Spacing.familyMemberDetailCalendarButtonRadius,
                      ),
                      Spacer(),
                      ShimmerPlaceholder.circle(
                        size: Spacing.familyMemberDetailProgressRingSize,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Spacing.familyMemberDetailCardGap),

          // 5. Shortcut Bar Skeleton
          Container(
            height: Spacing.familyMemberDetailShortcutHeight,
            padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
            decoration: BoxDecoration(
              color: color.surface,
              borderRadius: BorderRadius.circular(Spacing.radiusLg),
              border: Border.all(
                color: color.outlineVariant,
                width: Spacing.familyMemberDetailCardBorder,
              ),
            ),
            child: Row(
              children: [
                const ShimmerPlaceholder.rect(
                  width: 14,
                  height: 14,
                  borderRadius: Spacing.radiusXs,
                ),
                const SizedBox(width: Spacing.sm),
                const Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerPlaceholder.rect(
                        width: 60,
                        height: 12,
                        borderRadius: Spacing.radiusXs,
                      ),
                      SizedBox(height: Spacing.xs),
                      ShimmerPlaceholder.rect(
                        width: 80,
                        height: 10,
                        borderRadius: Spacing.radiusXs,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: Spacing.familyMemberDetailShortcutDividerHeight,
                  child: VerticalDivider(
                    color: color.outlineVariant,
                    thickness: Spacing.hairline,
                  ),
                ),
                const Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ShimmerPlaceholder.rect(
                        width: 60,
                        height: 12,
                        borderRadius: Spacing.radiusXs,
                      ),
                      SizedBox(height: Spacing.xs),
                      ShimmerPlaceholder.rect(
                        width: 80,
                        height: 10,
                        borderRadius: Spacing.radiusXs,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: Spacing.sm),
                const ShimmerPlaceholder.rect(
                  width: 14,
                  height: 14,
                  borderRadius: Spacing.radiusXs,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
