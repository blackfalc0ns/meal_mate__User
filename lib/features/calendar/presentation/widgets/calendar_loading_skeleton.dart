import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_day_meals_loading_skeleton.dart';

class CalendarLoadingSkeleton extends StatelessWidget {
  const CalendarLoadingSkeleton({super.key, this.showBottomSpace = false});

  final bool showBottomSpace;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Column(
      key: const ValueKey('calendar-loading-skeleton'),
      children: [
        // Picker panel skeleton
        SizedBox(
          width: double.infinity,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: Spacing.md),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: color.surface,
                    border: Border(
                      bottom: BorderSide(color: color.outlineVariant),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Month title row
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: Spacing.sm,
                          horizontal: Spacing.screenH,
                        ),
                        child: SizedBox(
                          height: 42,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ShimmerPlaceholder.circle(size: 32),
                              ShimmerPlaceholder.rect(
                                width: 130,
                                height: 22,
                                borderRadius: Spacing.radiusXs,
                              ),
                              ShimmerPlaceholder.circle(size: 32),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: Spacing.xs),

                      // Days week strip skeleton
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SizedBox(
                          height: 67,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(7, (index) {
                              final isSelected = index == 3;
                              return Container(
                                width: 44,
                                height: 59,
                                padding: const EdgeInsets.symmetric(
                                  vertical: Spacing.xs,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? color.primary.withValues(alpha: 0.12)
                                      : color.surface,
                                  borderRadius: BorderRadius.circular(
                                    Spacing.radiusSm,
                                  ),
                                  border: Border.all(
                                    color: isSelected
                                        ? color.primary.withValues(alpha: 0.4)
                                        : color.outlineVariant.withValues(
                                            alpha: 0.5,
                                          ),
                                  ),
                                ),
                                child: const Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ShimmerPlaceholder.rect(
                                      width: 18,
                                      height: 13,
                                      borderRadius: 2,
                                    ),
                                    ShimmerPlaceholder.rect(
                                      width: 26,
                                      height: 8,
                                      borderRadius: 2,
                                    ),
                                    ShimmerPlaceholder.circle(size: 6),
                                  ],
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                      const SizedBox(height: Spacing.md),
                    ],
                  ),
                ),
              ),

              // Grip chevron handle at bottom center
              Positioned(
                bottom: 0,
                child: SizedBox(
                  width: 52,
                  height: 36,
                  child: Center(
                    child: SizedBox(
                      width: 22,
                      height: 22,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: color.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: color.onPrimary,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Day meals content skeleton
        Expanded(
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsetsDirectional.only(
              start: Spacing.screenH,
              end: Spacing.screenH,
              top: Spacing.base,
              bottom: showBottomSpace
                  ? Spacing.bottomNavHeight + Spacing.xxxl + Spacing.md
                  : Spacing.xl,
            ),
            child: const CalendarDayMealsLoadingSkeleton(),
          ),
        ),
      ],
    );
  }
}
