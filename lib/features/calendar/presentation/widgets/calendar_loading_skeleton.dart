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
        DecoratedBox(
          decoration: BoxDecoration(
            color: color.surfaceContainerHighest,
            border: Border(bottom: BorderSide(color: color.outlineVariant)),
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
                    children: List.generate(
                      7,
                      (_) => const ShimmerPlaceholder.rect(
                        width: 44,
                        height: 59,
                        borderRadius: Spacing.radiusSm,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: Spacing.md),
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
