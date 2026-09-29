import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class AddressesLoadingSkeleton extends StatelessWidget {
  const AddressesLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding:
            const EdgeInsets.symmetric(
              horizontal: Spacing.addressesScreenHorizontalPadding,
            ).copyWith(
              top: Spacing.addressesContentTopPadding,
              bottom: Spacing.xxxl,
            ),
        child: Semantics(
          label: locale.profile_addresses,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: Spacing.addressesCurrentCardHeight,
                decoration: BoxDecoration(
                  color: color.surface,
                  borderRadius: BorderRadius.circular(
                    Spacing.addressesCardRadius,
                  ),
                  border: Border.all(color: color.outlineVariant),
                  boxShadow: [
                    BoxShadow(
                      color: color.shadow.withValues(alpha: 0.07),
                      blurRadius: Spacing.xs,
                      offset: const Offset(0, Spacing.xs),
                    ),
                  ],
                ),
                child: const Padding(
                  padding: EdgeInsets.all(Spacing.xss),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerPlaceholder.rect(
                        width: Spacing.addressesMapSize,
                        height: Spacing.addressesMapSize,
                        borderRadius: Spacing.addressesMapRadius,
                      ),
                      SizedBox(width: Spacing.md),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: Spacing.xss),
                          child: Column(
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
                              SizedBox(height: Spacing.xs),
                              ShimmerPlaceholder.rect(
                                height: Spacing.base,
                                borderRadius: Spacing.radiusSm,
                              ),
                              Spacer(),
                              ShimmerPlaceholder.rect(
                                height: Spacing.xxl,
                                borderRadius: Spacing.radiusSm,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: Spacing.sm),
                      ShimmerPlaceholder.rect(
                        width: Spacing.profileSettingsIconContainer,
                        height: Spacing.profileSettingsIconContainer,
                        borderRadius: Spacing.radiusSm,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: Spacing.addressesSectionGap),
              const Align(
                alignment: AlignmentDirectional.centerStart,
                child: ShimmerPlaceholder.rect(
                  width: Spacing.avatarLg,
                  height: Spacing.lg,
                  borderRadius: Spacing.radiusSm,
                ),
              ),
              const SizedBox(height: Spacing.sm),
              ...List.generate(2, (index) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index == 1
                        ? Spacing.zero
                        : Spacing.addressesCardGap,
                  ),
                  child: Container(
                    height: Spacing.addressesSavedTileHeight,
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.addressesCardContentPadding,
                    ),
                    decoration: BoxDecoration(
                      color: color.surface,
                      borderRadius: BorderRadius.circular(
                        Spacing.addressesCardRadius,
                      ),
                      border: Border.all(color: color.outlineVariant),
                      boxShadow: [
                        BoxShadow(
                          color: color.shadow.withValues(alpha: 0.07),
                          blurRadius: Spacing.xs,
                          offset: const Offset(0, Spacing.xs),
                        ),
                      ],
                    ),
                    child: const Row(
                      children: [
                        ShimmerPlaceholder.rect(
                          width: Spacing.addressesIconContainerSize,
                          height: Spacing.addressesIconContainerSize,
                          borderRadius: Spacing.addressesIconRadius,
                        ),
                        SizedBox(width: Spacing.sm),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                          size: Spacing.addressesOverflowButtonSize,
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: Spacing.addressesSectionGap),
              const SizedBox(height: Spacing.addressesSectionGap),
              const ShimmerPlaceholder.rect(
                height: Spacing.addressesAddButtonHeight,
                borderRadius: Spacing.addressesCardRadius,
              ),
              const SizedBox(height: Spacing.addressesSectionGap),
              const ShimmerPlaceholder.rect(
                height: Spacing.addressesAvailabilityNoticeHeight,
                borderRadius: Spacing.addressesCardRadius,
              ),
              const SizedBox(height: Spacing.xxl),
              const ShimmerPlaceholder.rect(
                height: Spacing.addressesSaveButtonHeight,
                borderRadius: Spacing.addressesSaveButtonRadius,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
