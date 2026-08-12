import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class DietaryPreferencesLoadingSkeleton extends StatelessWidget {
  const DietaryPreferencesLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.screenH,
          vertical: Spacing.sm,
        ).copyWith(bottom: Spacing.xxl),
        child: Semantics(
          label: locale.profile_dietary_preferences,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ShimmerPlaceholder.rect(
                height: Spacing.dietaryHeroHeight,
                borderRadius: Spacing.dietaryHeroRadius,
              ),
              const SizedBox(height: Spacing.dietarySectionGap),
              ...List.generate(3, (index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: Spacing.dietarySectionGap),
                  child: Container(
                    constraints: const BoxConstraints(
                      minHeight: Spacing.dietaryCardHeight,
                    ),
                    padding: const EdgeInsetsDirectional.only(
                      top: Spacing.dietaryDietHeaderTopInset,
                      start: Spacing.dietaryCardInset,
                    ),
                    decoration: BoxDecoration(
                      color: color.surface,
                      borderRadius: BorderRadius.circular(
                        Spacing.dietaryCardRadius,
                      ),
                      border: Border.all(
                        color: color.outlineVariant,
                        width: Spacing.dietaryCardBorderWidth,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: color.shadow.withValues(alpha: 0.07),
                          blurRadius: Spacing.xs,
                          offset: const Offset(0, Spacing.xs),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: const [
                        Align(
                          alignment: AlignmentDirectional.topStart,
                          child: ShimmerPlaceholder.rect(
                            width: Spacing.avatarLg,
                            height: Spacing.lg,
                            borderRadius: Spacing.radiusSm,
                          ),
                        ),
                        SizedBox(height: Spacing.base),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              ShimmerPlaceholder.rect(
                                width: Spacing.avatarLg,
                                height: Spacing.dietaryChipHeight,
                                borderRadius: Spacing.dietaryChipRadius,
                              ),
                              SizedBox(width: Spacing.sm),
                              ShimmerPlaceholder.rect(
                                width: Spacing.avatarLg,
                                height: Spacing.dietaryChipHeight,
                                borderRadius: Spacing.dietaryChipRadius,
                              ),
                              SizedBox(width: Spacing.sm),
                              ShimmerPlaceholder.rect(
                                width: Spacing.avatarLg,
                                height: Spacing.dietaryChipHeight,
                                borderRadius: Spacing.dietaryChipRadius,
                              ),
                              SizedBox(width: Spacing.sm),
                              ShimmerPlaceholder.rect(
                                width: Spacing.avatarLg,
                                height: Spacing.dietaryChipHeight,
                                borderRadius: Spacing.dietaryChipRadius,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              Container(
                constraints: const BoxConstraints(
                  minHeight: Spacing.dietaryCardHeight,
                ),
                padding: const EdgeInsets.only(
                  top: Spacing.dietaryNotesHeaderTopInset,
                ),
                decoration: BoxDecoration(
                  color: color.surface,
                  borderRadius: BorderRadius.circular(
                    Spacing.dietaryCardRadius,
                  ),
                  border: Border.all(
                    color: color.outlineVariant,
                    width: Spacing.dietaryCardBorderWidth,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: color.shadow.withValues(alpha: 0.07),
                      blurRadius: Spacing.xs,
                      offset: const Offset(0, Spacing.xs),
                    ),
                  ],
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Spacing.dietaryCardInset,
                      ),
                      child: Align(
                        alignment: AlignmentDirectional.topStart,
                        child: ShimmerPlaceholder.rect(
                          width: Spacing.avatarLg,
                          height: Spacing.lg,
                          borderRadius: Spacing.radiusSm,
                        ),
                      ),
                    ),
                    SizedBox(height: Spacing.base),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Spacing.dietaryNotesFieldHorizontalInset,
                      ),
                      child: ShimmerPlaceholder.rect(
                        height: Spacing.dietaryNotesFieldHeight,
                        borderRadius: Spacing.radiusSm,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Spacing.dietarySectionGap),
              const ShimmerPlaceholder.rect(
                height: Spacing.dietaryNoticeHeight,
                borderRadius: Spacing.dietaryCardRadius,
              ),
              const SizedBox(height: Spacing.sm),
              const ShimmerPlaceholder.rect(
                height: Spacing.dietarySaveButtonHeight,
                borderRadius: Spacing.dietarySaveButtonRadius,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
