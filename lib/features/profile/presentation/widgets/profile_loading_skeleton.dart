import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class ProfileLoadingSkeleton extends StatelessWidget {
  const ProfileLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.profileScreenHorizontalPadding,
        ),
        child: Semantics(
          label: locale.nav_profile,
          child: Column(
            children: [
              SizedBox(
                height: Spacing.profileHeaderHeight,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: const [
                        ShimmerPlaceholder.circle(
                          size: Spacing.profileAvatarSize,
                        ),
                        ShimmerPlaceholder.circle(
                          size: Spacing.profileAvatarEditSize,
                        ),
                      ],
                    ),
                    const SizedBox(width: Spacing.base),
                    const Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerPlaceholder.rect(
                            height: Spacing.lg,
                            borderRadius: Spacing.radiusSm,
                          ),
                          SizedBox(height: Spacing.sm),
                          ShimmerPlaceholder.rect(
                            height: Spacing.base,
                            borderRadius: Spacing.radiusSm,
                          ),
                          SizedBox(height: Spacing.md),
                          Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: FractionallySizedBox(
                              widthFactor: Spacing.border,
                              child: ShimmerPlaceholder.rect(
                                height: Spacing.xxl,
                                borderRadius: Spacing.xss,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Spacing.profileStatsTopGap),
              Container(
                height: Spacing.profileStatsHeight,
                decoration: BoxDecoration(
                  color: color.surface,
                  borderRadius: BorderRadius.circular(
                    Spacing.profileCardRadius,
                  ),
                  border: Border.all(color: color.outlineVariant),
                  boxShadow: [
                    BoxShadow(
                      color: color.shadow.withValues(alpha: 0.1),
                      blurRadius: Spacing.xs,
                      offset: const Offset(0, Spacing.xs),
                    ),
                  ],
                ),
                child: Row(
                  children: List.generate(4, (index) {
                    return Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: index == 3
                              ? null
                              : BorderDirectional(
                                  start: BorderSide(
                                    color: color.outlineVariant,
                                  ),
                                ),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ShimmerPlaceholder.circle(
                              size: Spacing.profileStatIconSize,
                            ),
                            SizedBox(height: Spacing.xs),
                            ShimmerPlaceholder.rect(
                              width: Spacing.xxxl,
                              height: Spacing.lg,
                              borderRadius: Spacing.radiusSm,
                            ),
                            SizedBox(height: Spacing.xs),
                            ShimmerPlaceholder.rect(
                              width: Spacing.avatarLg,
                              height: Spacing.md,
                              borderRadius: Spacing.radiusSm,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: Spacing.profileSettingsTopGap),
              Container(
                height: Spacing.profileSettingsHeight,
                decoration: BoxDecoration(
                  color: color.surface,
                  borderRadius: BorderRadius.circular(
                    Spacing.profileCardRadius,
                  ),
                  border: Border.all(color: color.outlineVariant),
                  boxShadow: [
                    BoxShadow(
                      color: color.shadow.withValues(alpha: 0.1),
                      blurRadius: Spacing.xs,
                      offset: const Offset(0, Spacing.xs),
                    ),
                  ],
                ),
                child: Column(
                  children: List.generate(6, (index) {
                    return SizedBox(
                      height: Spacing.profileSettingsTileHeight,
                      child: Column(
                        children: [
                          const Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: Spacing.profileSettingsInset,
                              ),
                              child: Row(
                                children: [
                                  ShimmerPlaceholder.rect(
                                    width: Spacing.profileSettingsIconContainer,
                                    height:
                                        Spacing.profileSettingsIconContainer,
                                    borderRadius: Spacing.xss,
                                  ),
                                  SizedBox(width: Spacing.sm),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ShimmerPlaceholder.rect(
                                          height: Spacing.md,
                                          borderRadius: Spacing.radiusSm,
                                        ),
                                        SizedBox(height: Spacing.xs),
                                        ShimmerPlaceholder.rect(
                                          height: Spacing.md,
                                          borderRadius: Spacing.radiusSm,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: Spacing.sm),
                                  ShimmerPlaceholder.circle(
                                    size: Spacing.iconSm,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (index != 5)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Spacing.profileSettingsInset,
                              ),
                              child: Divider(
                                height: Spacing.hairline,
                                color: color.outlineVariant,
                              ),
                            ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: Spacing.profileLogoutTopGap),
              const ShimmerPlaceholder.rect(
                height: Spacing.profileLogoutHeight,
                borderRadius: Spacing.profileLogoutRadius,
              ),
              const SizedBox(height: Spacing.xxxl),
            ],
          ),
        ),
      ),
    );
  }
}
