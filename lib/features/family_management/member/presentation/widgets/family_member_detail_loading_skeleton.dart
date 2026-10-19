import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';
import 'package:meal_meat_user/features/family_management/member/presentation/widgets/family_member_detail_section_card.dart';

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
          FamilyMemberDetailSectionCard(
            height: Spacing.familyMemberDetailProfileHeight,
            child: Row(
              children: [
                const ShimmerPlaceholder.rect(
                  width: 14,
                  height: 24,
                  borderRadius: Spacing.radiusXs,
                ),
                const SizedBox(width: Spacing.sm),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    ShimmerPlaceholder.rect(
                      width: 70,
                      height: 18,
                      borderRadius: Spacing.radiusXs,
                    ),
                    SizedBox(height: Spacing.xs),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ShimmerPlaceholder.rect(
                          width: Spacing.iconSm,
                          height: Spacing.iconSm,
                          borderRadius: Spacing.radiusXs,
                        ),
                        SizedBox(width: Spacing.xs),
                        ShimmerPlaceholder.rect(
                          width: 48,
                          height: 10,
                          borderRadius: Spacing.radiusXs,
                        ),
                      ],
                    ),
                    SizedBox(height: Spacing.xs),
                    ShimmerPlaceholder.rect(
                      width: 54,
                      height: Spacing.familyMemberDetailChipHeight,
                      borderRadius: Spacing.familyMemberDetailChipRadius,
                    ),
                    SizedBox(height: Spacing.xs),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ShimmerPlaceholder.rect(
                          width: Spacing.iconSm,
                          height: Spacing.iconSm,
                          borderRadius: Spacing.radiusXs,
                        ),
                        SizedBox(width: Spacing.xs),
                        ShimmerPlaceholder.rect(
                          width: 70,
                          height: 10,
                          borderRadius: Spacing.radiusXs,
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                const Stack(
                  alignment: AlignmentDirectional.bottomStart,
                  children: [
                    ShimmerPlaceholder.circle(
                      size: Spacing.familyMemberDetailAvatarSize,
                    ),
                    ShimmerPlaceholder.circle(
                      size: Spacing.familyMemberDetailAvatarStatusSize,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: Spacing.familyMemberDetailCardGap),

          // 2. Program Card Skeleton
          FamilyMemberDetailSectionCard(
            height: Spacing.familyMemberDetailStandardCardHeight + Spacing.xxl,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ShimmerPlaceholder.rect(
                      width: Spacing.familyMemberDetailHeaderIconSize,
                      height: Spacing.familyMemberDetailHeaderIconSize,
                      borderRadius: Spacing.radiusXs,
                    ),
                    SizedBox(width: Spacing.sm),
                    ShimmerPlaceholder.rect(
                      width: 95,
                      height: 14,
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
                    width: 130,
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
          FamilyMemberDetailSectionCard(
            height: Spacing.familyMemberDetailStandardCardHeight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ShimmerPlaceholder.rect(
                      width: Spacing.familyMemberDetailHeaderIconSize,
                      height: Spacing.familyMemberDetailHeaderIconSize,
                      borderRadius: Spacing.radiusXs,
                    ),
                    SizedBox(width: Spacing.sm),
                    ShimmerPlaceholder.rect(
                      width: 60,
                      height: 14,
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
                    width: 180,
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
          FamilyMemberDetailSectionCard(
            height: Spacing.familyMemberDetailProgressCardHeight,
            padding: const EdgeInsetsDirectional.only(
              start: Spacing.xl,
              top: Spacing.md,
              end: Spacing.md,
              bottom: Spacing.sm,
            ),
            child: Column(
              children: const [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ShimmerPlaceholder.rect(
                      width: Spacing.familyMemberDetailHeaderIconSize,
                      height: Spacing.familyMemberDetailHeaderIconSize,
                      borderRadius: Spacing.radiusXs,
                    ),
                    SizedBox(width: Spacing.sm),
                    ShimmerPlaceholder.rect(
                      width: 80,
                      height: 14,
                      borderRadius: Spacing.radiusXs,
                    ),
                  ],
                ),
                Expanded(
                  child: Row(
                    children: [
                      ShimmerPlaceholder.circle(
                        size: Spacing.familyMemberDetailProgressRingSize,
                      ),
                      Spacer(),
                      ShimmerPlaceholder.rect(
                        width: Spacing.familyMemberDetailCalendarButtonWidth,
                        height: Spacing.familyMemberDetailCalendarButtonHeight,
                        borderRadius:
                            Spacing.familyMemberDetailCalendarButtonRadius,
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
              boxShadow: [
                BoxShadow(
                  color: color.shadow.withValues(alpha: 0.1),
                  offset: const Offset(Spacing.zero, Spacing.xs),
                  blurRadius: Spacing.xs,
                ),
              ],
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ShimmerPlaceholder.rect(
                        width: Spacing.familyMemberDetailShortcutIconSize,
                        height: Spacing.familyMemberDetailShortcutIconSize,
                        borderRadius: Spacing.radiusXs,
                      ),
                      SizedBox(width: Spacing.xs),
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShimmerPlaceholder.rect(
                              width: 65,
                              height: 11,
                              borderRadius: Spacing.radiusXs,
                            ),
                            SizedBox(height: Spacing.xs),
                            ShimmerPlaceholder.rect(
                              width: 85,
                              height: 9,
                              borderRadius: Spacing.radiusXs,
                            ),
                          ],
                        ),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ShimmerPlaceholder.rect(
                        width: Spacing.familyMemberDetailShortcutIconSize,
                        height: Spacing.familyMemberDetailShortcutIconSize,
                        borderRadius: Spacing.radiusXs,
                      ),
                      SizedBox(width: Spacing.xs),
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShimmerPlaceholder.rect(
                              width: 60,
                              height: 11,
                              borderRadius: Spacing.radiusXs,
                            ),
                            SizedBox(height: Spacing.xs),
                            ShimmerPlaceholder.rect(
                              width: 80,
                              height: 9,
                              borderRadius: Spacing.radiusXs,
                            ),
                          ],
                        ),
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
